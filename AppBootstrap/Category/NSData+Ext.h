//
//  NSData+MD5.h
//  iosMD5
//
//  Created by demeng on 11-12-26.
//  Copyright (c) 2011年 HOLDiPhone.com. All rights reserved.
//

#import "NSData+Ext.h"
 
@interface NSData(Ext)
 
- (NSString *)md5;

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

// added by Hiroshi Hashiguchi
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;

- (NSString *)hexString;

@end