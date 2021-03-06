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
    int instActual;
    
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
    /**/
    _instrucciones = @[@{@"texto" : @"Este marcador muestra cuántos litros de agua has desperdiciado. ¡Construye una tubería para cerrar la fuga!",
                         @"imagen" : [UIImage imageNamed: @"0.png"]},
                       @{@"texto" : @"Hay un máximo de litros de agua que puedes desperdiciar. Si te pasas, ¡estás fuera!",
                         @"imagen" : [UIImage imageNamed: @"1.png"]},
                       @{@"texto" : @"Conecta tu tubería a la llave para rescatar el agua.",
                         @"imagen" : [UIImage imageNamed: @"2.png"]},
                       @{@"texto" : @"Presiona sobre cualquier lugar vacío de la cuadrícula para colocar el siguiente tubo",
                         @"imagen" : [UIImage imageNamed: @"4.png"]},
                       @{@"texto" : @"Debes llevar el agua a la coladera para reciclarla.",
                         @"imagen" : [UIImage imageNamed: @"3.png"]},
                       @{@"texto" : @"Si logras llevar el agua a tiempo, ¡Ganaste! ¡Desperdicia lo menos posible para figurar en el ranking!",
                         @"imagen" : [UIImage imageNamed: @"5.png"]}];
    instActual = 0;
    /**/

    
    self.imagenI.image = _instrucciones[instActual][@"imagen"];
    self.instruccionTV.text = _instrucciones[instActual][@"texto"];
    //[self.instruccionTV sizeToFit];
}

-(void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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



- (IBAction)backPresionado:(id)sender {
    instActual = (_instrucciones.count + instActual - 1) % _instrucciones.count;
    
    self.imagenI.image = _instrucciones[instActual][@"imagen"];
    self.instruccionTV.text = _instrucciones[instActual][@"texto"];
    //[self.instruccionTV sizeToFit];
}

- (IBAction)nextPresionado:(id)sender {
    instActual = (instActual + 1) % _instrucciones.count;
    
    self.imagenI.image = _instrucciones[instActual][@"imagen"];
    self.instruccionTV.text = _instrucciones[instActual][@"texto"];
    //[self.instruccionTV sizeToFit];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    NSLog(@"instrucciones shouldautorotateto");
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
-(BOOL)shouldAutorotate {
    NSLog(@"instrucciones shouldautorotate");
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"instrucciones supported");
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end
