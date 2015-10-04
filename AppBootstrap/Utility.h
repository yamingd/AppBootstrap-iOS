//
//  Utility.h
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFullScreenHeight (CGRectGetHeight([UIScreen mainScreen].bounds))
#define kFullScreenWidth (CGRectGetWidth([UIScreen mainScreen].bounds))

@interface Utility : NSObject

+(NSDictionary*) dictFromPlist:(NSString *)name;

+(NSArray*) arrayFromPlist:(NSString *)name;

+(NSString*)loadTxt:(NSString*)name;

+(NSDictionary*) loadJsonFile:(NSString*)name;

+(NSString*) asJson:(id)object;
+(id) asObject:(NSString*)data;
+(id) asObject2:(NSData*)data;

+(NSString*)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params;
+(NSString*)urlEscape:(NSString *)unencodedString;

+(UIColor *)colorFromARGB:(int)argb;

+(void)pframe:(CGRect)frame;

+(int)random:(int)from end:(int)end;

+(void)addSkipBackupAttributeToItemAtURL:(NSURL*)url;

+(BOOL)mobileOK:(NSString*)mobile;

+(id)toHumanSize:(long long)value;

/**
 *  拨打电话
 *
 *  @param phone 手机号码，或者带分机号
 */
+ (void)callPhone:(NSString *)phone;

@end
