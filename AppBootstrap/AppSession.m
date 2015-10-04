//
//  AppSession.m
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "AppSession.h"
#import "RealmContext.h"
#import "DeviceHelper.h"
#import "AppSecurity.h"

@interface AppSession ()

@property(strong, nonatomic)RealmContext* sessionDb;

@end

@implementation AppSession

+ (instancetype)current {
    static AppSession *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[AppSession alloc] init];
    });
    return _shared;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _sessionDb = [[RealmContext alloc] initWith:kRealmSession classes:@[TSAppSession.class] version:1];
    }
    return self;
}

- (BOOL)isAnonymous{
    return self.session == nil || self.session.userId == 0;
}

- (BOOL)isSignIn{
    return self.session !=nil && self.session.userName && self.session.userId > 0;
}

//环境字典
- (NSMutableDictionary*) envdict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.session.deviceId forKey:@"device_id"];
    
    [dict setValue:self.session.deviceName forKey:@"device_name"];
    [dict setValue:self.session.deviceScreenSize forKey:@"device_screensize"];
    
    [dict setValue:self.session.osName forKey:@"os_name"];
    [dict setValue:self.session.osVersion forKey:@"os_version"];
    
    [dict setValue:self.session.packageVersion forKey:@"package_version"];
    [dict setValue:self.session.packageName forKey:@"package_name"];
    
    return dict;
}

//API调用参数DICT
- (NSMutableDictionary*) apidict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.session.sessionId forKey:@"sessionid"];
    [dict setValue:self.session.userName forKey:@"uname"];
    return dict;
}

- (NSDictionary*) header{
    return [[AppSecurity instance] signSession:self.session];
}

- (void)remember{
    //save session to local file
    [_sessionDb update:^(RLMRealm *realm) {
        [realm addOrUpdateObject:self.session];
    }];}

-(void)clear{
    
    self.session.userId = 0;
    self.session.userName = @"Guest";
    self.session.realName = @"Guest";
    
    [self remember];
}

- (void)load:(NSString*)appName{
    //load session from db file.
    __block TSAppSession* ses = nil;
    [_sessionDb query:^(RLMRealm *realm) {
        ses = [TSAppSession objectInRealm:realm forPrimaryKey:@(1)];
    }];
    
    if (!ses) {
        ses = [TSAppSession newOne];
    }
    
    ses.osName = [DeviceHelper getOSName];
    ses.osVersion = [DeviceHelper getOSVersion];
    ses.deviceName = [DeviceHelper getDeviceName];
    ses.deviceScreenSize = [DeviceHelper getScreenSize];
    ses.packageName = [DeviceHelper getAppName];
    ses.packageVersion = [DeviceHelper getAppVersion];
    ses.deviceToken = @"NULL";
    ses.deviceId = [DeviceHelper getDeviceUdid];
    ses.appName = appName;
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    ses.localIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    self.userAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@; %@)", appName, version, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ses.localIdentifier];
    
    [_sessionDb update:^(RLMRealm *realm) {
        [realm addOrUpdateObject:ses];
    }];
    
    self.session = ses;
}
@end
