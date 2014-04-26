//
//  DDMPipe.h
//  iPipe
//
//  Created by Isabel Guevara on 4/25/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, DDMPipeEnd) {
    DDMPipeEndUp,
    DDMPipeEndLeft,
    DDMPipeEndRight,
    DDMPipeEndDown,
};

typedef NS_OPTIONS(NSInteger, DDMPipeType) {
    DDMPipeTypeFaucet,
    DDMPipeTypeDrain,
    DDMPipeTypePipe
};


@interface DDMPipe : NSObject

@property (nonatomic) DDMPipeEnd  ends;
@property (nonatomic) DDMPipeType type;
@property (nonatomic) BOOL        wet;
@property (nonatomic) BOOL        dripping;

@property (strong, nonatomic) UIImageView *image;

-(id)initWithEnds:(DDMPipeEnd) ends andType:(DDMPipeType) type;
-(BOOL) isWet: (DDMPipeEnd) checkEnd;
+(id) faucet;
+(id) drain;


@end
