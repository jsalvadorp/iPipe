//
//  DDMCargarViewController.h
//  iPipe
//
//  Created by Isabel Guevara on 4/19/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMCargarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *juegosTV;

@end
