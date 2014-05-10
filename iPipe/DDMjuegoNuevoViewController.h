//
//  DDMjuegoNuevoViewController.h
//  iPipe
//
//  Created by Isabel Guevara on 4/19/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface DDMjuegoNuevoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nombreTF;
@property (strong, nonatomic) IBOutlet UIButton *startB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dificultadSC;

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@end
