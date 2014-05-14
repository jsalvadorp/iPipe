//
//  DDMjuegoNuevoViewController.m
//  iPipe
//
//  Created by Isabel Guevara on 4/19/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMjuegoNuevoViewController.h"
#import "DDMManejoDB.h"
#import "Juego.h"
#import "DDMTieneJuego.h"

@interface DDMjuegoNuevoViewController ()

@end

@implementation DDMjuegoNuevoViewController

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
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quitarTeclado:)]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.gif"]];
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"waterPantallas" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
   
}

-(void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void) quitarTeclado:(UITapGestureRecognizer *) recognizer {
    [self.view endEditing:YES];
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
    

    if(sender == self.startB /*&& ![self.nombreTF.text isEqualToString:@""]*/) {
        
        if ([self.nombreTF.text isEqualToString:@""]){
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Pon tu nombre por favor"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK", nil];
            [alert show];
            
        } else {
        DDMManejoDB *db = [DDMManejoDB instancia];
        Juego *juego = [db insertarJuego:self.nombreTF.text dificultad:self.dificultadSC.selectedSegmentIndex];
        id<DDMTieneJuego>dest = segue.destinationViewController;
        dest.juego = juego;
        }
        //[self performSegueWithIdentifier: @"SegueToScene1" sender: self];
        }
    
}
/**/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
