//
//  DDMTile.m
//  iPipe
//
//  Created by Isabel Guevara on 4/25/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMTile.h"

@implementation DDMTile

-(BOOL)isWet:(DDMPipeEnd)checkEnd {
    if(self.pipe != nil)
        return [self.pipe isWet:checkEnd];
    else
        return FALSE;
}

-(DDMPipeEnd)fillFrom:(DDMPipeEnd)checkEnd {
    if(self.pipe != nil)
        return [self.pipe fillFrom:checkEnd];
    else
        return FALSE;
}

@end
