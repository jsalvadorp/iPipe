//
//  Tip.h
//  iPipe
//
//  Created by Salvador Pamanes on 10/05/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tip : NSManagedObject

@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * tip;

@end
