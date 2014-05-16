//
//  DDMJuegoViewController.h
//  iPipe
//
//  Created by Isabel Guevara on 4/20/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMTieneJuego.h"
@import AVFoundation;

@interface DDMJuegoViewController : UIViewController <DDMTieneJuego>
- (IBAction)salirPresionado:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *fondoIV;
@property (strong, nonatomic) IBOutlet UIImageView *progIV;
- (IBAction)guardarPresionado:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *puntosL;

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@end
