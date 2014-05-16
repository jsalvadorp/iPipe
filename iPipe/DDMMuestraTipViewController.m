//
//  DDMMuestraTipViewController.m
//  iPipe
//
//  Created by Isabel Guevara on 4/20/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMMuestraTipViewController.h"
#import "DDMManejoDB.h"
#import "DDMTieneJuego.h"
#import "DDMCargarViewController.h"
#import "DDMjuegoNuevoViewController.h"

@interface DDMMuestraTipViewController ()

@end

@implementation DDMMuestraTipViewController

@synthesize juego;
@synthesize vistaPrevia;

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.gif"]];
    self.tipTxtV.text = [[DDMManejoDB instancia] randomTip].tip;
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerDisparo:) userInfo:nil repeats:NO];
    [self.cargandoAI startAnimating];
    self.tipTxtV.backgroundColor = [UIColor clearColor];
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"waterPantallas" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    //[self.backgroundMusicPlayer prepareToPlay];
    //[self.backgroundMusicPlayer play];

    
}


-(void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) timerDisparo: (NSTimer *) timer {
    [self performSegueWithIdentifier: @"juego" sender: self];
}

/**/
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    id<DDMTieneJuego>dest = segue.destinationViewController;
    dest.juego = juego;
    dest.vistaPrevia = self;
}
/**/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (void) salirAlMenu {
    NSLog(@"sm tip");
    //[self dismissViewControllerAnimated:NO completion:nil];
    //[self.vistaPrevia salirAlMenu];
    /*[self dismissViewControllerAnimated:NO completion:^{
        [((UINavigationController *)self.presentingViewController) popToRootViewControllerAnimated:YES];
    }];*/
    //[((UINavigationController *)self.presentingViewController) popToRootViewControllerAnimated:NO];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [((UINavigationController *)self.presentingViewController) popToRootViewControllerAnimated:NO];
}

@end
