//
//  Ranking.h
//  iPipe
//
//  Created by Salvador Pamanes on 10/05/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ranking : NSManagedObject

@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * puntos;
@property (nonatomic, retain) NSNumber * dificultad;

@end
