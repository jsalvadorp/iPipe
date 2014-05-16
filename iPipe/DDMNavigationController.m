//
//  DDMNavigationController.m
//  iPipe
//
//  Created by Salvador Pamanes on 15/05/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMNavigationController.h"

@interface DDMNavigationController ()

@end

@implementation DDMNavigationController

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

-(NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"supportedInterfaceOrientations = %d ", [self.topViewController         supportedInterfaceOrientations]);
    //NSLog(@"navcon supported");
    return [self.visibleViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return self.visibleViewController.shouldAutorotate;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // You do not need this method if you are not supporting earlier iOS Versions
    
    return [self.visibleViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}



- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    //NSLog(@"preferred");
    return self.visibleViewController.preferredInterfaceOrientationForPresentation;
}

@end
