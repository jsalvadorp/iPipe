//
//  DDMPipe.h
//  iPipe
//
//  Created by Isabel Guevara on 4/25/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, DDMPipeEnd) {
    DDMPipeEndUp = 0x1,
    DDMPipeEndLeft = 0x2,
    DDMPipeEndRight = 0x4,
    DDMPipeEndDown = 0x8,
};

typedef NS_ENUM(NSInteger, DDMPipeType) {
    DDMPipeTypeFaucet,
    DDMPipeTypeDrain,
    DDMPipeTypePipe
};


@interface DDMPipe : NSObject

@property (nonatomic) DDMPipeEnd  ends;
@property (nonatomic) DDMPipeType type;
@property (nonatomic) BOOL        wet;
@property (nonatomic) BOOL        dripping;

@property (strong, nonatomic) UIImageView *sprite;

+(UIImage *)imageForEnds: (DDMPipeEnd) ends andWet: (BOOL) wet;
-(BOOL) isWet: (DDMPipeEnd) checkEnd;
-(id)initWithEnds:(DDMPipeEnd)ends andType:(DDMPipeType) type andFrame: (CGRect) frame;
+(id) faucetWithFrame: (CGRect) frame;
+(id) drainWithFrame: (CGRect) frame;
-(DDMPipeEnd)fillFrom:(DDMPipeEnd)checkEnd;



@end
