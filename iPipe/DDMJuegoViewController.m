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
    origenX = 0.0; //screenRect.origin.x;
    origenY = 0.0; //screenRect.origin.y;
    width = 7;
    height = 6;
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
    
    [self insertarPipe];
    [self insertarPipe];
    [self insertarPipe];
    [self insertarPipe];
    [self insertarPipe];
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
    DDMPipe *faucet = [DDMPipe faucet];
    faucet.image.contentMode = UIViewContentModeScaleAspectFit;
    faucetJ = arc4random() % height;
    ((DDMTile *)_tiles[0][faucetJ]).pipe = faucet;
    [faucet.image setFrame:
     CGRectMake(0,
                origenY + faucetJ * gridSize,
                gridSize,
                gridSize)];
    
    [self.view addSubview:faucet.image];
    //NSLog(@"imagen %@", faucet.image.image);
    
    DDMPipe *drain = [DDMPipe drain];
    drainJ = arc4random() % height;
    ((DDMTile *)_tiles[width - 1][drainJ]).pipe = drain;
    [drain.image setFrame:
     CGRectMake(origenX + (width - 1) * gridSize,
                origenY + drainJ * gridSize,
                gridSize,
                gridSize)];
    
    [self.view addSubview:drain.image];
    //NSLog(@"imagen %@", drain.image.image);
    drippingI = 1;
    drippingJ = faucetJ;
    drippingEnd = DDMPipeEndLeft;
    
}

- (void) ponerPipeEnI:(int) i J: (int) j {
    if([_tiles[i][j] pipe] == nil) {
        for(int i = _pipeQueue.count - 1; i > 0; i--) {
            UIImageView *image = ((DDMPipe *)_pipeQueue[i]).image;
            
            [UIView animateWithDuration:0.40 delay:0.0 options: UIViewAnimationCurveEaseOut animations:^{
                [image setFrame:
                 CGRectMake(((DDMPipe *)_pipeQueue[i - 1]).image.frame.origin.x,
                            ((DDMPipe *)_pipeQueue[i - 1]).image.frame.origin.y,
                            gridSize, gridSize)];
                } completion:nil];
        }
        
        UIImageView *image = [((DDMPipe *)_pipeQueue[0]) image];
        
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
        
        /*if(pipe.ends & DDMPipeEndLeft && i > 0 && [_tiles[i][j] pipe] != nil && [[_tiles[i - 1][j] pipe] isWet:DDMPipeEndRight])
           || (pipe.ends & DDMPipeEndUp && j > 0 && [_tiles[i][j] pipe] != nil && [[_tiles[i][j - 1] pipe] isWet:DDMPipeEndDown])
           || (pipe.ends & DDMPipeEndDown && j < height - 1 && [_tiles[i][j + 1] pipe] != nil && [[_tiles[i][j - 1] pipe] isWet:DDMPipeEndUp])
           || (pipe.ends & DDMPipeEndRight && i < width - 1 && [_tiles[i][j + 1] pipe] != nil && [[_tiles[i][j - 1] pipe] isWet:DDMPipeEndLeft])

        ) {
            //pipe.wet = YES;
            [self mojarI: i J: j ];
        }*/
        NSLog(@"pipei = %d pipej = %d", i, j);
        if(drippingI == i && drippingJ == j) {
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
        }
    }
    
    NSLog(@"new di = %d dj = %d", drippingI, drippingJ);
}

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
}

- (void) insertarPipe {
    DDMPipeEnd randEnd = DDMPipeEndUp | DDMPipeEndLeft;
    UIImage *image;
    
    switch(arc4random() % 6) {
        case 0:
            randEnd = DDMPipeEndUp | DDMPipeEndLeft;
            image = [UIImage imageNamed:@"imagenes/ul.png"];
            break;
        case 1:
            randEnd = DDMPipeEndUp | DDMPipeEndRight;
            image = [UIImage imageNamed:@"imagenes/ur.png"];
            break;
        case 2:
            randEnd = DDMPipeEndDown | DDMPipeEndLeft;
            image = [UIImage imageNamed:@"imagenes/dl.png"];
            break;
        case 3:
            randEnd = DDMPipeEndDown | DDMPipeEndRight;
            image = [UIImage imageNamed:@"imagenes/dr.png"];
            break;
        case 4:
            randEnd = DDMPipeEndUp | DDMPipeEndDown;
            image = [UIImage imageNamed:@"imagenes/ud.png"];
            break;
        case 5:
            randEnd = DDMPipeEndLeft | DDMPipeEndRight;
            image = [UIImage imageNamed:@"imagenes/lr.png"];
            break;
    }
    
    DDMPipe *pipe = [[DDMPipe alloc] initWithEnds:randEnd andType:DDMPipeTypePipe];
    pipe.image = [[UIImageView alloc] initWithFrame:
                  CGRectMake(queueX, origenY - gridSize, gridSize, gridSize)];
    pipe.image.image = image;
    pipe.image.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:pipe.image];
    //NSLog(@"imagen %@", pipe.image.image);
    
    [UIView animateWithDuration:0.75 delay:0.0 options: UIViewAnimationCurveEaseOut animations:^{
        [pipe.image setFrame:
         CGRectMake(queueX, origenY + (height - _pipeQueue.count - 1) * gridSize, gridSize, gridSize)];} completion:nil];
    //NSLog(@"x = %lf y = %lf", origenX + gridSize * width, origenY + (_pipeQueue.count + 1) * gridSize);
    
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
