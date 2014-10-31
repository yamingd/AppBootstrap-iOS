//
//  NSString+Helper.m
//  EnglishCafe
//
//  Created by Simsion on 10/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+Ext.h"
#import "NSData+Ext.h"
#import "NSDate+Helper.h"
#import "NSDate+TimeAgo.h"

@implementation NSString (Helper)

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

+ (NSString *)base64StringFromData: (NSData *)data length: (NSUInteger)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1) {
        return @"";
    }
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) {
            break;
        }
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext) {
                input[i] = raw[ix];
            }
            else {
                input[i] = 0;
            }
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++) {
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        }
        
        for (i = ctcopy; i < 4; i++) {
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length)) {
            charsonline = 0;
        }
    }     
    return result;
}

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

-(NSString*)md5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

-(NSString*) hmac:(NSString*)secret{
    const char *cKey = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *signature = [HMAC base64EncodedString];
    return signature;
}

@end
