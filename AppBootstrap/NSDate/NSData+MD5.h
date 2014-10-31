//
//  NSData+MD5.h
//  iosMD5
//
//  Created by demeng on 11-12-26.
//  Copyright (c) 2011年 HOLDiPhone.com. All rights reserved.
//

#import "NSData+MD5.h"
 
@interface NSData(MD5)
 
- (NSString *)MD5;

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

// added by Hiroshi Hashiguchi
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;

@end