//
//  NSString+Helper.m
//  EnglishCafe
//
//  Created by Simsion on 10/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "NSString+Helper.h"
#import "NSDate+Helper.h"
#import "NSDate+TimeAgo.h"

@implementation NSString (Helper)

- (NSString *)dateTimeAgo{
    NSDate* date = [NSDate dateFromString:self];
    return [date dateTimeAgo];
}

-(NSString *)unescapeUnicode {
    NSString *input = self;
    int x = 0;
    NSMutableString *mStr = [NSMutableString string];
    
    do {
        unichar c = [input characterAtIndex:x];
        if( c == '\\' ) {
            unichar c_next = [input characterAtIndex:x+1];
            if( c_next == 'u' ) {
                unichar accum = 0x0;
                int z;
                for( z=0; z<4; z++ ) {
                    unichar thisChar = [input characterAtIndex:x+(2+z)];
                    int val = 0;
                    if( thisChar >= 0x30 && thisChar <= 0x39 ) { // 0-9
                        val = thisChar - 0x30;
                    }
                    else if( thisChar >= 0x41 && thisChar <= 0x46 ) { // A-F
                        val = thisChar - 0x41 + 10;
                    }
                    else if( thisChar >= 0x61 && thisChar <= 0x66 ) { // a-f
                        val = thisChar - 0x61 + 10;
                    }
                    if( z ) {
                        accum <<= 4;
                    }
                    
                    accum |= val;
                }
                NSString *unicode = [NSString stringWithCharacters:&accum length:1];
                [mStr appendString:unicode];
                
                x+=6;
            }
            else {
                [mStr appendFormat:@"%c", c];
                x++;
            }
        }
        else {
            [mStr appendFormat:@"%c", c];
            x++;
        }
    } while( x < [input length] );
    
    return( mStr );
}

@end
