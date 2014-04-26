//
//  DDMPipe.m
//  iPipe
//
//  Created by Isabel Guevara on 4/25/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMPipe.h"

@implementation DDMPipe

-(BOOL) isWet: (DDMPipeEnd) checkEnd {
    return (self.wet || self.type == DDMPipeTypeFaucet) && (self.ends & checkEnd);
}

-(id)initWithEnds:(DDMPipeEnd)ends andType:(DDMPipeType) type {
    if (self = [super init]) {
        self.ends = ends;
        self.type = type;
    }
    return self;
}

+(id) faucet{
        UIImageView * faucet;
        faucet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagenes/faucet.png"]];
    
   faucet.contentMode = UIViewContentModeScaleAspectFit;
    DDMPipe *nuevo = [[DDMPipe alloc] initWithEnds:DDMPipeEndRight andType:DDMPipeTypeFaucet];
    nuevo.wet = YES;
    nuevo.image = faucet;
    return nuevo;
}

+(id) drain{
    UIImageView * drain;
    drain = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagenes/drain.png"]];
    drain.contentMode = UIViewContentModeScaleAspectFit;
    DDMPipe *nuevo = [[DDMPipe alloc] initWithEnds:DDMPipeEndLeft andType:DDMPipeTypeDrain];
    nuevo.wet = YES;
    nuevo.image = drain;
    return nuevo;
}



@end
