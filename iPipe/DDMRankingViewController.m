//
//  DDMRankingViewController.m
//  iPipe
//
//  Created by Salvador Pamanes on 12/05/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMRankingViewController.h"
#import "DDMRankingTableViewCell.h"
#import "DDMManejoDB.h"

@interface DDMRankingViewController ()

@end

@implementation DDMRankingViewController {
    NSArray *rankings;
}

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
    
    rankings = [[DDMManejoDB instancia] rankings];
    
    self.rankingTV.delegate = self;
    self.rankingTV.dataSource = self;
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rankings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    /*if(indexPath.row == 0) {
     NSLog(@"nuevo juego");
     cell.nombreLabel.text = @"Nuevo Juego";
     } else {
     
     Juego *j = juegos[indexPath.row - 1];
     cell.nombreLabel.text = j.nombre;
     }*/
    
    NSDictionary *j = rankings[indexPath.row];
    cell.numNombreL.text = [NSString stringWithFormat:@"%02d. %@", (indexPath.row + 1), j[@"nombre"]];
    cell.puntosL.text = [j[@"puntos"] stringValue];
    
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
    //[self performSegueWithIdentifier: @"tip" sender: self];
    /*}*/
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
