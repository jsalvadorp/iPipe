//
//  DDMPipe.m
//  iPipe
//
//  Created by Isabel Guevara on 4/25/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMPipe.h"

@implementation DDMPipe

+(UIImage *)imageForEnds: (DDMPipeEnd) ends andWet: (BOOL) wet {
    NSString *imageName = @"";
    
    if(ends == (DDMPipeEndDown | DDMPipeEndLeft)) {
        imageName = [imageName stringByAppendingString:@"dl"];
    } else if(ends == (DDMPipeEndDown | DDMPipeEndRight)) {
        imageName = [imageName stringByAppendingString:@"dr"];
    } else if(ends == (DDMPipeEndUp | DDMPipeEndLeft)) {
        imageName = [imageName stringByAppendingString:@"ul"];
    } else if(ends == (DDMPipeEndUp | DDMPipeEndRight)) {
        imageName = [imageName stringByAppendingString:@"ur"];
    } else if(ends == (DDMPipeEndUp | DDMPipeEndDown)) {
        imageName = [imageName stringByAppendingString:@"ud"];
    } else if(ends == (DDMPipeEndLeft | DDMPipeEndRight)) {
        imageName = [imageName stringByAppendingString:@"lr"];
    } else return nil;
    
    if(wet)
        imageName = [imageName stringByAppendingString:@"w"];
    
    imageName = [imageName stringByAppendingString:@".png"];
    
    //NSLog(imageName);
    
    return [UIImage imageNamed:imageName];
}

-(BOOL) isWet: (DDMPipeEnd) checkEnd {
    return (self.wet || self.type == DDMPipeTypeFaucet) && (self.ends & checkEnd);
}

-(id)initWithEnds:(DDMPipeEnd)ends andType:(DDMPipeType) type andFrame: (CGRect) frame {
    if (self = [super init]) {
        self.ends = ends;
        self.type = type;
        self.wet = false;
        
        UIImageView * img;
        img = [[UIImageView alloc] initWithImage:[DDMPipe imageForEnds:ends andWet:NO]];
        img.frame = frame;
        img.contentMode = UIViewContentModeScaleAspectFit;
        self.sprite = img;

    }
    return self;
}

+(id) faucetWithFrame: (CGRect) frame{
    UIImageView * img;
    img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"faucet.png"]];
    img.frame = frame;
    img.contentMode = UIViewContentModeScaleAspectFit;
    DDMPipe *nuevo = [[DDMPipe alloc] init];
    nuevo.ends = DDMPipeEndRight;
    nuevo.type = DDMPipeTypeFaucet;
    nuevo.wet = YES;
    nuevo.sprite = img;
    return nuevo;
}

+(id) drainWithFrame: (CGRect) frame{
    UIImageView * img;
    img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drain.png"]];
    img.frame = frame;
    img.contentMode = UIViewContentModeScaleAspectFit;
    DDMPipe *nuevo = [[DDMPipe alloc] init];
    nuevo.ends = DDMPipeEndLeft;
    nuevo.type = DDMPipeTypeDrain;
    nuevo.wet = NO;
    nuevo.sprite = img;
    return nuevo;
}

-(DDMPipeEnd)fillFrom:(DDMPipeEnd)checkEnd {
    if(self.ends & checkEnd) { // si el agua puede entrar por ese end
        self.wet = TRUE; // el pipe se moja
        self.sprite.image = [DDMPipe imageForEnds:self.ends andWet:YES];
        return self.ends & (~checkEnd); // el agua sale por todos los demas ends
    }
    return 0; // si no, no sale
}


@end
