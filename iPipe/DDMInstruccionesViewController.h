//
//  DDMInstruccionesViewController.h
//  iPipe
//
//  Created by Ivan Diaz on 3/27/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMInstruccionesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagenI;
@property (weak, nonatomic) IBOutlet UITextView *instruccionTV;
- (IBAction)backPresionado:(id)sender;
- (IBAction)nextPresionado:(id)sender;

@end
