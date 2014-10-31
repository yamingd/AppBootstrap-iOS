//
//  AppSession.h
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAnonymous @"Anonymous"
#define kUserPortrait @"kUserPortrait"
#define kSessionCacheKey @"session-app"
#define kNotification @"Notification"
#define kAppModeServer @"server"
#define kAppModeLocal @"local"

@interface AppSession : NSObject

+ (instancetype)current;

@property(nonatomic, strong) NSString* sessionId; //32位惟一标示
@property(nonatomic, strong) NSString* realName; //用户真实名称
@property(nonatomic, strong) NSString* userName; //用户邮箱用户名
@property(nonatomic, strong) NSNumber* userId;  //用户数据库ID
@property(nonatomic, strong) NSString* secret;  //会话Salt
@property(nonatomic, strong) NSString* signinDate; //登录日期
@property(nonatomic, strong) NSString* profileImageUrl; //头像

@property(nonatomic, strong) NSString* appName; //应用业务名称
@property(nonatomic, strong) NSString* deviceName; //设备名称
@property(nonatomic, strong) NSString* deviceScreenSize; //设备屏幕
@property(nonatomic, strong) NSString* osName; //操作系统名称
@property(nonatomic, strong) NSString* osVersion; //操作系统版本
@property(nonatomic, strong) NSString* packageVersion; //应用版本号
@property(nonatomic, strong) NSString* packageName; //应用名称
@property(nonatomic, strong) NSString* deviceId; //设备惟一标示
@property(nonatomic, strong) NSString* deviceToken; //APNS
@property(nonatomic, strong) NSNumber* apnsEnabled;

@property(nonatomic, strong) NSString* latesAppVers; //服务端返回的应用最新版本号
@property(nonatomic, strong) NSString* localeIdentifier;
@property(strong, nonatomic) NSMutableDictionary *config;
@property(strong, nonatomic) NSMutableDictionary *flash;
@property(strong, nonatomic) NSString* appMode;

//是否匿名
- (BOOL)isAnonymous;
- (BOOL)isSignIn;

//将用户Session数据转为JSON
- (NSString*) asJSON;

//环境参数DICT
- (NSMutableDictionary*) envdict;

//API调用参数DICT
- (NSMutableDictionary*) apidict;
- (NSMutableDictionary*) header;

- (BOOL)appHasNewVers;
- (BOOL)isEnabled:(NSString *)name;

- (NSLocale *)getLocale;

- (void)savePortrait:(NSData *)data;
- (UIImage *)getPortrait;

- (void)remember;
- (void)clear;
- (void)load;

@end
