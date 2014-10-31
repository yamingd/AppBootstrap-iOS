//
//  Utility.h
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(NSDictionary*) dictFromPlist:(NSString *)name;

+(NSArray*) arrayFromPlist:(NSString *)name;
+(NSArray*) arrayFromPlist:(NSString *)name model:(Class)mclass;

+(void)urlToFile:(NSString **)url toLocalURL:(NSString *)fileName;

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

@end
