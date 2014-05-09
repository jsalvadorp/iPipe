//
//  DDMMuestraTipViewController.h
//  iPipe
//
//  Created by Isabel Guevara on 4/20/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMTieneJuego.h"
@import AVFoundation;

@interface DDMMuestraTipViewController : UIViewController <DDMTieneJuego>
@property (strong, nonatomic) IBOutlet UITextView *tipTxtV;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *cargandoAI;

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@end
