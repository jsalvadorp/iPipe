//
//  DDMCargarViewController.m
//  iPipe
//
//  Created by Isabel Guevara on 4/19/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMCargarViewController.h"
#import "DDMCargarCellTableViewCell.h"
#import "DDMManejoDB.h"
#import "DDMTieneJuego.h"
#import "Juego.h"

// la primera celda corresponde a un juego nuevo
// las demas a los juegos guardados

@interface DDMCargarViewController (){
    NSArray *juegos;
}

@end

@implementation DDMCargarViewController

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
    self.juegosTV.delegate = self;
    self.juegosTV.dataSource = self;
    
    juegos = [[DDMManejoDB instancia] juegos];
}

-(void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return juegos.count;// + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMCargarCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    /*if(indexPath.row == 0) {
        NSLog(@"nuevo juego");
        cell.nombreLabel.text = @"Nuevo Juego";
    } else {
    
        Juego *j = juegos[indexPath.row - 1];
        cell.nombreLabel.text = j.nombre;
    }*/
    
    Juego *j = juegos[indexPath.row];
    cell.nombreLabel.text = j.nombre;
    
    if(j.state) {
        NSString *str = j.state;
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding] options: 0
                                                               error: &e];
        cell.puntosLabel.text = [NSString stringWithFormat:@"%@ L", dict[@"wasted"]];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //DDMCargarCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    /*if(indexPath.row == 0) {
        [self performSegueWithIdentifier: @"nuevo" sender: self];
    } else {*/
        [self performSegueWithIdentifier: @"tip" sender: self];
    /*}*/
}


/**/
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"nuevo"]) { // crear juego nuevo
    
    } else { // carga juego existente
        NSIndexPath *indexPath = [self.juegosTV indexPathForSelectedRow];
        NSLog(@"row %ld", (long)indexPath.row);
        id<DDMTieneJuego> dest = segue.destinationViewController;
        dest.juego = juegos[indexPath.row];
    }
}
/**/

@end
