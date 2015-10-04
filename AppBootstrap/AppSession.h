//
//  AppSession.h
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSAppSession.hh"

#define kRealmSession @"session"

@interface AppSession : NSObject

+ (AppSession*)current;

@property(strong, nonatomic) TSAppSession* session;
@property(strong, nonatomic) NSMutableDictionary *flash;
@property(strong, nonatomic) NSString* userAgent;

- (instancetype)init;

//是否匿名
- (BOOL)isAnonymous;
- (BOOL)isSignIn;

//环境参数DICT
- (NSDictionary*) envdict;

//API调用参数DICT
- (NSDictionary*) apidict;
- (NSDictionary*) header;

- (void)remember;
- (void)clear;
- (void)load:(NSString*)appName;

@end
