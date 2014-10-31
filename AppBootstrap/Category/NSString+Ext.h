//
//  NSString+Helper.h
//  EnglishCafe
//
//  Created by yaming_deng on 10/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Ext)

-(NSString *)dateTimeAgo;
-(NSString *)unescapeUnicode;
-(NSString *)md5;
-(NSString *)hmac:(NSString*)secret;
+ (NSString *)base64StringFromData:(NSData *)data length:(NSUInteger)length;

@end
