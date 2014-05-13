//
//  DDMInstruccionesViewController.m
//  iPipe
//
//  Created by Ivan Diaz on 3/27/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMInstruccionesViewController.h"

@interface DDMInstruccionesViewController () {
    NSArray *_instrucciones;
}

@end

@implementation DDMInstruccionesViewController

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
    /**
    _instrucciones = @[@{@"texto" : @"El agua se está desperdiciando cada segundo. ¡Construye una tubería para cerrar la fuga!",
                         @"imagen" : [UIImage imageNamed: @"instrucciones/0.jpg"]},
                       @{@"texto" : @"Te daremos piezas para construirla, una por una. Debes planear cómo usarlas para llevar el agua a la coladera.",
                         @"imagen" : [UIImage imageNamed: @"instrucciones/1.jpg"]},
                       @{@"texto" : @"Si desperdicias más del agua permitida, ¡estás fuera!",
                         @"imagen" : [UIImage imageNamed: @"instrucciones/2.jpg"]}];
    **/
    
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
