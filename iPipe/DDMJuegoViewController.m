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

@interface DDMJuegoViewController () {
    NSInteger width;
    NSInteger height;
    CGFloat gridSize;
    int queueCount;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    CGFloat origenX;
    CGFloat origenY;
    CGFloat queueX;
    
    int drippingI;
    int drippingJ;
    DDMPipeEnd drippingEnd;
    
    NSMutableArray *_tiles;
    NSMutableArray *_pipeQueue;
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
    // Do any additional setup after loading the view.
    
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = self.fondoIV.frame.size.width;//screenRect.size.width;
    screenHeight = self.fondoIV.frame.size.height; //screenRect.size.height;
    origenX = self.fondoIV.frame.origin.x; //0.0 //screenRect.origin.x;
    origenY = self.fondoIV.frame.origin.x; //0.0 //screenRect.origin.y;
    width = 7;
    height = 6;
    queueCount = height;
    gridSize = screenHeight / height;
    queueX = origenX + gridSize * width;
    //self.fondoIV.frame = CGRectMake(origenX, origenY, width * gridSize, height * gridSize);
    
    
    
    
    
    _tiles = [[NSMutableArray alloc] initWithCapacity:width];
    
    for(int i = 0; i < width; i++) {
        _tiles[i] = [[NSMutableArray alloc] initWithCapacity:height];
        
        for(int j = 0; j < height; j++) {
            _tiles[i][j] = [[DDMTile alloc] init];
        }
    }
    
    _pipeQueue = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < queueCount; i++)
        [self insertarPipe];
    
    [self.fondoIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.fondoIV.userInteractionEnabled = YES;
    /*UIImageView * sample = [[UIImageView alloc] initWithFrame:
     CGRectMake(- 36, 70, gridSize, gridSize)];
    sample.image = [UIImage imageNamed:@"imagenes/ur.png"];
    sample.contentMode = UIViewContentModeScaleAspectFit;
     [self.view addSubview:sample];*/
    //NSLog(@"imagenx = %lf y = %lf", self.testIV.frame.origin.x, self.testIV.frame.origin.y);
    //NSLog(@"width = %lf height = %lf queuex = %lf gridSize = %lf", screenWidth, screenHeight, queueX, gridSize);
    
    
    
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
        
        [self insertarPipe];
        
        if(i > 0 && [_tiles[i][j] pipe] != nil && [[_tiles[i - 1][j] pipe] isWet:DDMPipeEndRight])
            [self flowIntoI:i J:j End:DDMPipeEndLeft];
        if(j > 0 && [_tiles[i][j] pipe] != nil && [[_tiles[i][j - 1] pipe] isWet:DDMPipeEndDown])
            [self flowIntoI:i J:j End:DDMPipeEndUp];
        if(j < height - 1 && [_tiles[i][j + 1] pipe] != nil && [[_tiles[i][j - 1] pipe] isWet:DDMPipeEndUp])
            [self flowIntoI:i J:j End:DDMPipeEndDown];
        if(i < width - 1 && [_tiles[i][j + 1] pipe] != nil && [[_tiles[i][j - 1] pipe] isWet:DDMPipeEndLeft])
            [self flowIntoI:i J:j End:DDMPipeEndRight];

        NSLog(@"pipei = %d pipej = %d", i, j);
        /*if(drippingI == i && drippingJ == j) {
            if(pipe.ends & drippingEnd) {
                NSLog(@"sisoy miend %d dutuend %d ", pipe.ends, drippingEnd);
                pipe.wet = YES;
                if(pipe.ends == (DDMPipeEndUp | DDMPipeEndLeft)) {
                    pipe.image.image = [UIImage imageNamed:@"imagenes/ulw.png"];
                } else if(pipe.ends == (DDMPipeEndUp | DDMPipeEndRight)) {
                    pipe.image.image = [UIImage imageNamed:@"imagenes/urw.png"];
                } else if(pipe.ends == (DDMPipeEndDown | DDMPipeEndLeft)) {
                    pipe.image.image = [UIImage imageNamed:@"imagenes/dlw.png"];
                } else if(pipe.ends == (DDMPipeEndDown | DDMPipeEndRight)) {
                    pipe.image.image = [UIImage imageNamed:@"imagenes/drw.png"];
                } else if(pipe.ends == (DDMPipeEndUp | DDMPipeEndDown)) {
                    pipe.image.image = [UIImage imageNamed:@"imagenes/udw.png"];
                } else if(pipe.ends == (DDMPipeEndLeft | DDMPipeEndRight)) {
                    pipe.image.image = [UIImage imageNamed:@"imagenes/lrw.png"];
                }
                
                if(pipe.ends & DDMPipeEndUp) {
                    drippingJ--;
                    drippingEnd = DDMPipeEndDown;
                } else if(pipe.ends & DDMPipeEndDown) {
                    drippingJ++;
                    drippingEnd = DDMPipeEndUp;
                } else if(pipe.ends & DDMPipeEndLeft) {
                    drippingI--;
                    drippingEnd = DDMPipeEndRight;
                } else if(pipe.ends & DDMPipeEndRight) {
                    drippingI++;
                    drippingEnd = DDMPipeEndLeft;
                }
                
            }
        }*/
    }
    
    //NSLog(@"new di = %d dj = %d", drippingI, drippingJ);
}
/*
- (void) mojar {//I: (int) i J: (int) j End: (DDMPipeEnd) end {
    int i = drippingI, j = drippingJ;
    DDMPipeEnd end = drippingEnd;
    //NSLog(@"maybe %d %d", i, j);
    if(i < 0 || i >= width || j < 0 || j >= height)
        return;
     //NSLog(@"maybe %d %d", i, j);
    DDMPipe *pipe = [_tiles[i][j] pipe];
    
    if(pipe.wet)
        return;
    
    if(pipe.ends & end && pipe.type == DDMPipeTypePipe) {
       // NSLog(@"wetting %d %d", i, j);
    
        pipe.wet = YES;
        if(pipe.ends == (DDMPipeEndUp | DDMPipeEndLeft)) {
            pipe.image.image = [UIImage imageNamed:@"imagenes/ulw.png"];
        } else if(pipe.ends == (DDMPipeEndUp | DDMPipeEndRight)) {
            pipe.image.image = [UIImage imageNamed:@"imagenes/urw.png"];
        } else if(pipe.ends == (DDMPipeEndDown | DDMPipeEndLeft)) {
            pipe.image.image = [UIImage imageNamed:@"imagenes/dlw.png"];
        } else if(pipe.ends == (DDMPipeEndDown | DDMPipeEndRight)) {
            pipe.image.image = [UIImage imageNamed:@"imagenes/drw.png"];
        } else if(pipe.ends == (DDMPipeEndUp | DDMPipeEndDown)) {
            pipe.image.image = [UIImage imageNamed:@"imagenes/udw.png"];
        } else if(pipe.ends == (DDMPipeEndLeft | DDMPipeEndRight)) {
            pipe.image.image = [UIImage imageNamed:@"imagenes/lrw.png"];
        }
        
        
    
    if(pipe.ends & DDMPipeEndUp) {
        drippingJ--;
        drippingEnd = DDMPipeEndDown;
    } else if(pipe.ends & DDMPipeEndDown) {
        drippingJ++;
        drippingEnd = DDMPipeEndUp;
    } else if(pipe.ends & DDMPipeEndLeft) {
        drippingI--;
        drippingEnd = DDMPipeEndRight;
    } else if(pipe.ends & DDMPipeEndRight) {
        drippingI++;
        drippingEnd = DDMPipeEndLeft;
    }
    }
}*/

-(void)flowIntoI:(int)i J:(int)j End: (DDMPipeEnd) end {
    if(i < 0 || i >= width || j < 0 || j >= height)
        return;
    if([_tiles[i][j] pipe] == nil) {
        [self dripFromI:i J:j End:end];
        
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
    
    // mostrar drip
}

- (void) insertarPipe {
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
    DDMPipeEnd randEnd = possibleEnds[arc4random() % 8];
    
    NSLog(@"randEnd = %d d%d l%d r%d u%d",
          (int)randEnd,
          (int)DDMPipeEndDown,
          (int)DDMPipeEndLeft,
          (int)DDMPipeEndRight,
          (int)DDMPipeEndUp);
    
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

- (void) tap: (UITapGestureRecognizer *)recognizer {
    //NSLog(@"TOUCH");
    if(recognizer.state == UIGestureRecognizerStateRecognized) {
      //  NSLog(@"TOUCH");
        CGPoint point = [recognizer locationInView:recognizer.view];
        
        CGFloat x = point.x - origenX,
            y = point.y - origenY;
        
        int i = (int) (x / gridSize),
            j = (int) (y / gridSize);
        
        [self ponerPipeEnI:i J:j];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)salirPresionado:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

@end
