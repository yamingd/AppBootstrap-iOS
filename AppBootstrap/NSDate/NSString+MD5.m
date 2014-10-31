//
//  NSString+MD5.m
//  iosMD5
//
//  Created by demeng on 11-12-26.
//  Copyright (c) 2011年 HOLDiPhone.com. All rights reserved.
//
 
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+MD5.h"

@implementation NSString(MD5)
 
-(NSString*)MD5
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
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *signature = [HMAC base64EncodedString];
    return signature;
}

@end