//
//  DDMMuestraTipViewController.m
//  iPipe
//
//  Created by Isabel Guevara on 4/20/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMMuestraTipViewController.h"
#import "DDMManejoDB.h"

@interface DDMMuestraTipViewController ()

@end

@implementation DDMMuestraTipViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.gif"]];
    self.tipTxtV.text = [[DDMManejoDB instancia] randomTip].tip;
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerDisparo:) userInfo:nil repeats:NO];
    [self.cargandoAI startAnimating];
    self.tipTxtV.backgroundColor = [UIColor clearColor];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) timerDisparo: (NSTimer *) timer {
    [self performSegueWithIdentifier: @"juego" sender: self];
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

@end
