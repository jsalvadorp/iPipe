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
    [self.navigationController setNavigationBarHidden:YES];
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
    if(sender == self.startB && ![self.nombreTF.text isEqualToString:@""]) {
        DDMManejoDB *db = [DDMManejoDB instancia];
        Juego *juego = [db insertarJuego:self.nombreTF.text];
        id<DDMTieneJuego>dest = segue.destinationViewController;
        dest.juego = juego;
        //[self performSegueWithIdentifier: @"SegueToScene1" sender: self];
    }
}
/**/

@end
