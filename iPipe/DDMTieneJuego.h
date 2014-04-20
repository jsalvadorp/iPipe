//
//  DDMTieneJuego.h
//  iPipe
//
//  Created by Isabel Guevara on 4/20/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Juego.h"

@protocol DDMTieneJuego <NSObject>

@property (strong, atomic) Juego *juego;

@end
