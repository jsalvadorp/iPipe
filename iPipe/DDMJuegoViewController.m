//
//  DDMJuegoViewController.m
//  iPipe
//
//  Created by Isabel Guevara on 4/20/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMJuegoViewController.h"
#import "DDMTile.h"
#import "DDMPipe.h"
#import "DDMManejoDB.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <stdlib.h>

const DDMPipeEnd possibleEnds[] = {
    DDMPipeEndUp | DDMPipeEndLeft,
    DDMPipeEndUp | DDMPipeEndRight,
    DDMPipeEndDown | DDMPipeEndLeft,
    DDMPipeEndDown | DDMPipeEndRight,
    DDMPipeEndUp | DDMPipeEndDown,
    DDMPipeEndLeft | DDMPipeEndRight
};

CGFloat endDistribution[][6] = {
    { // facil
        0.125,
        0.125,
        0.125,
        0.125,
        0.25,
        0.25
    },
    { // medio
        0.17,
        0.17,
        0.17,
        0.17,
        0.16,
        0.16
    },
    { // dificil
        0.20,
        0.20,
        0.20,
        0.20,
        0.10,
        0.10
    }
};

@interface DDMJuegoViewController () {
    NSInteger width;
    NSInteger height;
    CGFloat gridSize;
    int queueCount;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat topBarHeight;
    
    CGFloat origenX;
    CGFloat origenY;
    CGFloat queueX;
    
    int drippingI;
    int drippingJ;
    DDMPipeEnd drippingEnd;
    
    NSMutableArray *_tiles;
    NSMutableArray *_pipeQueue;
    
    CGFloat wasted;
    CGFloat max;
    CGFloat delta;
    
    int placedPipes;

    NSTimer *timer;
}

@end

@implementation DDMJuegoViewController

@synthesize juego;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];

    
    NSLog(@"juego nombre: %@ dificultad %@ nuevo %@ state %@", juego.nombre, juego.dificultad, juego.new, juego.state);
    // Do any additional setup after loading the view.
    [UIImage imageNamed:@"water.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.gif"]];
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"waterJuego" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = 640;//self.fondoIV.frame.size.width;//screenRect.size.width;
    screenHeight = 320; //self.fondoIV.frame.size.height; //screenRect.size.height;
    topBarHeight = 30.0;
    
    origenX = 0.0; //0.0 //screenRect.origin.x;
    origenY = 30.0; //0.0 //screenRect.origin.y;
    width = 7;
    height = 6;
    queueCount = height;
    gridSize = (screenHeight - topBarHeight) / height;
    queueX = origenX + gridSize * width;
    max = 15000.0;
    wasted = 0.0;
    delta = 15.0;
    self.fondoIV.frame = CGRectMake(origenX, origenY, width * gridSize, height * gridSize);
    
    //NSLog(@"origen = %lf, %lf w%lf h%lf", origenX, origenY, screenWidth, screenHeight);
    _tiles = [[NSMutableArray alloc] initWithCapacity:width];
    
    for(int i = 0; i < width; i++) {
        _tiles[i] = [[NSMutableArray alloc] initWithCapacity:height];
        
        for(int j = 0; j < height; j++) {
            _tiles[i][j] = [[DDMTile alloc] init];
        }
    }
    _pipeQueue = [[NSMutableArray alloc] init];
    
    if([self.juego.new boolValue]) {
        [self nuevoJuego];
    } else {
        [self loadGameState];
    }
    
    
    
    [self.fondoIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.fondoIV.userInteractionEnabled = YES;
    
    
    
    self.progIV.frame = CGRectMake(0.0, 0.0, 0.0, origenY);
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerDisparo:) userInfo:nil repeats:YES];
    
    
}

- (void) nuevoJuego {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int end = 0; end < 6; end++) {
        for(int i = 0; i < (width + 1) * height * endDistribution[[juego.dificultad integerValue]][end]; i++) {
            [arr addObject:
             @[[NSNumber numberWithInt:possibleEnds[end]],
               [NSNumber numberWithInt:(arc4random() % 0xFFFFFF)]]];
        }
    }
    [arr addObject:
     @[[NSNumber numberWithInt:possibleEnds[(arc4random() % 0xFFFFFF) % 6]],
       [NSNumber numberWithInt:arc4random()]]];
    
    [arr sortUsingComparator:^NSComparisonResult(id a, id b){return [a[1] compare: b[1]];}];
    
    for(int i = 0; i < arr.count; i++) {
        [self insertarPipe:[arr[i][0] integerValue]];
    }
    
    
    int faucetJ, drainJ;
    
    faucetJ = arc4random() % height;
    DDMPipe *faucet = [DDMPipe faucetWithFrame:CGRectMake(0,
                                                          origenY + faucetJ * gridSize,
                                                          gridSize,
                                                          gridSize)];
    ((DDMTile *)_tiles[0][faucetJ]).pipe = faucet;
    [self.view addSubview:faucet.sprite];
    
    drainJ = arc4random() % height;
    DDMPipe *drain = [DDMPipe drainWithFrame:CGRectMake(origenX + (width - 1) * gridSize,
                                                        origenY + drainJ * gridSize,
                                                        gridSize,
                                                        gridSize)];
    ((DDMTile *)_tiles[width - 1][drainJ]).pipe = drain;
    [self.view addSubview:drain.sprite];
    //NSLog(@"imagen %@", drain.image.image);
    drippingI = 1;
    drippingJ = faucetJ;
    drippingEnd = DDMPipeEndLeft;
    
    placedPipes = 0;
    
    NSLog(@"nuevo");
}

- (void) loadGameState {
    NSString *str = self.juego.state;
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding] options: 0
                                                           error: &e];
    int i, j;
    DDMPipeEnd end;
    DDMPipe *drain, *faucet;
    
    
    i = [dict[@"drain"][@"i"] integerValue];
    j = [dict[@"drain"][@"j"] integerValue];
    end = [dict[@"drain"][@"end"] integerValue];
    drain = [DDMPipe drainWithFrame:CGRectMake(origenX + i * gridSize,
                                               origenY + j * gridSize,
                                               gridSize,
                                               gridSize)];
    [self.view addSubview:drain.sprite];
    [_tiles[i][j] setPipe: drain];
    
    
    
    i = [dict[@"faucet"][@"i"] integerValue];
    j = [dict[@"faucet"][@"j"] integerValue];
    end = [dict[@"faucet"][@"end"] integerValue];
    faucet = [DDMPipe faucetWithFrame:CGRectMake(origenX + i * gridSize,
                                                 origenY + j * gridSize,
                                                 gridSize,
                                                 gridSize)];
    [self.view addSubview:faucet.sprite];
    [_tiles[i][j] setPipe: faucet];
    
    drippingI = i + 1;
    drippingJ = j;
    drippingEnd = end;
    
    
    wasted = [dict[@"wasted"] doubleValue];
    placedPipes = [dict[@"placedPipes"] intValue];
    NSArray *pipes = dict[@"pipes"];
    NSArray *queue = dict[@"queue"];
    
    for(NSDictionary *p in pipes) {
        [self insertarPipe:[p[@"end"] integerValue]];
        
        [self ponerPipeEnI:[p[@"i"] integerValue] J:[p[@"j"] integerValue]];
        
        
        NSLog(@"save pipe %@ %@", p[@"i"], p[@"j"]);
    }
    
    for(NSDictionary *q in queue) {
        [self insertarPipe:[q[@"end"] integerValue]];
    }
    
    
    
    //NSLog(@"load");
}

- (void) timerDisparo: (NSTimer *) timer {
    wasted += delta;
    self.puntosL.text = [NSString stringWithFormat:@"%d L/%.2lf L", (int)wasted, (double)max];
    
    if(wasted > max) {
        [self terminar:FALSE];
    } else {
        self.progIV.frame = CGRectMake(0.0, 0.0, 7 * gridSize * (wasted / max), origenY);
    }
}

- (void) saveGameState {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"wasted"] = [NSNumber numberWithDouble: wasted];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < width; i++) {
        for(int j = 0; j < height; j++) {
            
            if([_tiles[i][j] pipe] == nil) {
                
            } else if([_tiles[i][j] pipe].type == DDMPipeTypeDrain) {
                dict[@"drain"] = @{@"i" : [NSNumber numberWithInt:i],
                                   @"j" : [NSNumber numberWithInt:j],
                                   @"end" : [NSNumber numberWithInt:[_tiles[i][j] pipe].ends]};
            } else if([_tiles[i][j] pipe].type == DDMPipeTypeFaucet) {
                dict[@"faucet"] = @{@"i" : [NSNumber numberWithInt:i],
                                    @"j" : [NSNumber numberWithInt:j],
                                    @"end" : [NSNumber numberWithInt:[_tiles[i][j] pipe].ends]};
            } else {
                [arr addObject:@{@"i" : [NSNumber numberWithInt:i],
                                 @"j" : [NSNumber numberWithInt:j],
                                 @"end" : [NSNumber numberWithInt:[_tiles[i][j] pipe].ends]}];
                //NSLog(@"save pipe %d %d", i, j);
            }
        }
    }
    
    dict[@"pipes"] = arr;
    
    
    NSMutableArray *queue = [[NSMutableArray alloc] init];
    
    for(DDMPipe *pipe in _pipeQueue) {
        [queue addObject:@{@"end" : [NSNumber numberWithInt:pipe.ends]}];
        
        
    }
    
    dict[@"queue"] = queue;
    
    NSError *error;
    NSData *jsonData =
    [NSJSONSerialization dataWithJSONObject:dict
                                    options:(NSJSONWritingOptions)0
                                      error:&error];
    
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    self.juego.state = str;
    self.juego.new = @NO;
    [[DDMManejoDB instancia] saveContext];
    
    //NSLog(@"guardo %@", self.juego.state);
}




- (void) ponerPipeEnI:(int) i J: (int) j {
    if([_tiles[i][j] pipe] == nil) {
        for(int i = _pipeQueue.count - 1; i > 0; i--) {
            UIImageView *image = ((DDMPipe *)_pipeQueue[i]).sprite;
            
            [UIView animateWithDuration:0.40 delay:0.0 options: UIViewAnimationCurveEaseOut animations:^{
                [image setFrame:
                 CGRectMake(((DDMPipe *)_pipeQueue[i - 1]).sprite.frame.origin.x,
                            ((DDMPipe *)_pipeQueue[i - 1]).sprite.frame.origin.y,
                            gridSize, gridSize)];
                } completion:nil];
        }
        
        UIImageView *image = [((DDMPipe *)_pipeQueue[0]) sprite];
        
        [UIView animateWithDuration:0.40 delay:0.0 options: UIViewAnimationCurveEaseOut animations:^{
            [image setFrame:
             CGRectMake(origenX + i * gridSize,
                        origenY + j * gridSize,
                        gridSize,
                        gridSize)];} completion:nil];
        ((DDMTile *)_tiles[i][j]).pipe = _pipeQueue[0];
        DDMPipe *pipe = _pipeQueue[0];
        [_pipeQueue removeObjectAtIndex:0];
        
        placedPipes++;
        
        //[self insertarPipe];
        
        if(i > 0 && [_tiles[i - 1][j] pipe] != nil && [[_tiles[i - 1][j] pipe] isWet:DDMPipeEndRight])
            [self flowIntoI:i J:j End:DDMPipeEndLeft];
        if(j > 0 && [_tiles[i][j - 1] pipe] != nil && [[_tiles[i][j - 1] pipe] isWet:DDMPipeEndDown])
            [self flowIntoI:i J:j End:DDMPipeEndUp];
        if(j < height - 1 && [_tiles[i][j + 1] pipe] != nil && [[_tiles[i][j + 1] pipe] isWet:DDMPipeEndUp])
            [self flowIntoI:i J:j End:DDMPipeEndDown];
        if(i < width - 1 && [_tiles[i + 1][j] pipe] != nil && [[_tiles[i + 1][j] pipe] isWet:DDMPipeEndLeft])
            [self flowIntoI:i J:j End:DDMPipeEndRight];
        
        
    }
    
    //NSLog(@"new di = %d dj = %d", drippingI, drippingJ);
}

-(void)flowIntoI:(int)i J:(int)j End: (DDMPipeEnd) end {
    if(i < 0 || i >= width || j < 0 || j >= height)
        return;
    if([_tiles[i][j] pipe] == nil) {
        [self dripFromI:i J:j End:end];
        
        return;
    }
    
    if([_tiles[i][j] pipe].type == DDMPipeTypeDrain) {
        [self terminar:YES];
        return;
    }
    
    if([_tiles[i][j] pipe].wet == YES)
        return;
    
    DDMPipeEnd outs = [[_tiles[i][j] pipe] fillFrom:end];
    
    if(outs & DDMPipeEndLeft) {
        [self flowIntoI:i - 1 J:j End:DDMPipeEndRight];
    }
    
    if(outs & DDMPipeEndRight) {
        [self flowIntoI:i + 1 J:j End:DDMPipeEndLeft];
    }
    
    if(outs & DDMPipeEndUp) {
        [self flowIntoI:i J:j - 1 End:DDMPipeEndDown];
    }
    
    if(outs & DDMPipeEndDown) {
        [self flowIntoI:i J:j + 1 End:DDMPipeEndUp];
    }
}

-(void)dripFromI:(int)i J:(int)j End: (DDMPipeEnd) end {
    drippingI = i;
    drippingJ = j;
    drippingEnd = end;
    
    [UIImage imageNamed:@"water.png"];
}

- (void) insertarPipe: (DDMPipeEnd) randEnd {
    static DDMPipeEnd possibleEnds[] = {
        DDMPipeEndUp | DDMPipeEndDown,
        DDMPipeEndLeft | DDMPipeEndRight,
        DDMPipeEndUp | DDMPipeEndLeft,
        DDMPipeEndUp | DDMPipeEndRight,
        DDMPipeEndDown | DDMPipeEndLeft,
        DDMPipeEndDown | DDMPipeEndRight,
        DDMPipeEndUp | DDMPipeEndDown,
        DDMPipeEndLeft | DDMPipeEndRight
    };
    //DDMPipeEnd randEnd = possibleEnds[arc4random() % 8];
    
    DDMPipe *pipe = [[DDMPipe alloc]
                     initWithEnds:randEnd
                     andType:DDMPipeTypePipe
                     andFrame:CGRectMake(queueX, origenY - gridSize, gridSize, gridSize)];
    [self.view addSubview:pipe.sprite];
    //NSLog(@"imagen %@", pipe.image.image);
    
    [UIView animateWithDuration:0.75 delay:0.0 options: UIViewAnimationCurveEaseOut animations:^{
        [pipe.sprite setFrame:
         CGRectMake(queueX, origenY + (height - _pipeQueue.count - 1) * gridSize, gridSize, gridSize)];} completion:nil];
    
    [_pipeQueue addObject:pipe];
    
}

-(void)terminar:(BOOL)gano {
    [timer invalidate];
    
    if (gano){
        NSString *msg = ([[DDMManejoDB instancia] insertarRanking:self.juego.nombre
                                                         dificultad:[self.juego.dificultad integerValue]
                                                             puntos:wasted])
            ? @"¡Nueva puntuación alta!"
            : @"¡Ganaste!";
        
        UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:msg
                          message:nil
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"¡Desperdiciaste mucha agua!"
                              message:nil
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) tap: (UITapGestureRecognizer *)recognizer {
    //NSLog(@"TOUCH");
    if(recognizer.state == UIGestureRecognizerStateRecognized) {
      //  NSLog(@"TOUCH");
        CGPoint point = [recognizer locationInView:recognizer.view];
        
        CGFloat x = point.x,
            y = point.y;
        
        int i = (int) (x / gridSize),
            j = (int) (y / gridSize);
        
        NSLog(@"i %ld j %ld", i, j);
        
        [self ponerPipeEnI:i J:j];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**/
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [timer invalidate];
}
/**/

- (IBAction)salirPresionado:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (IBAction)guardarPresionado:(id)sender {
    //NSLog(@"%@", [self gameState]);
    [self saveGameState];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
