//
//  Juego.h
//  iPipe
//
//  Created by Salvador Pamanes on 09/05/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Juego : NSManagedObject

@property (nonatomic, retain) NSNumber * new;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * puntos;
@property (nonatomic, retain) NSString * state;

@end
