//
//  AppSession.m
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "AppSession.h"
#import "AESCrypt.h"
#import "DeviceHelper.h"
#import "NSString+Ext.h"
#import "NSData+Ext.h"
#import "NSData+CommonCrypto.h"

@implementation AppSession

+ (instancetype)current {
    static AppSession *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[AppSession alloc] init];
        _shared.apnsEnabled = 0;
        _shared.flash = [[NSMutableDictionary alloc] init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"plist"];
        assert(path);
        _shared.config = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        _shared.appMode = kAppModeServer;
        [_shared load];
        
    });
    return _shared;
}

@synthesize sessionId, userName, realName, secret, signinDate;
@synthesize deviceName, deviceScreenSize, deviceId, deviceToken;
@synthesize osName, osVersion;
@synthesize packageName, packageVersion, profileImageUrl;
@synthesize appName, latesAppVers;
@synthesize config,localeIdentifier, apnsEnabled;

- (BOOL)isAnonymous{
    return self.sessionId == nil || self.userName == nil;
}

- (BOOL)isSignIn{
    return self.sessionId !=nil && self.userName && ![self.userName isEqual: kAnonymous];
}

- (NSLocale *)getLocale{
    if (self.localeIdentifier==nil || self.localeIdentifier.length == 0) {
        NSString *def = [self.config objectForKey:@"AppLocale"];
        if (def == nil || def.length == 0) {
            return [NSLocale currentLocale];
        }
        self.localeIdentifier = def;
        return [[NSLocale alloc] initWithLocaleIdentifier:def];
    }else{
        return [[NSLocale alloc] initWithLocaleIdentifier:self.localeIdentifier];
    }
}

- (NSString*) asJSON{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.sessionId forKey:@"sessionId"];
    [dict setValue:self.userName forKey:@"userName"];
    [dict setValue:self.realName forKey:@"realName"];
    [dict setValue:self.secret forKey:@"secret"];
    [dict setValue:self.userId forKey:@"userId"];
    [dict setValue:self.deviceToken forKey:@"deviceToken"];
    [dict setValue:self.signinDate forKey:@"signinDate"];
    [dict setValue:self.profileImageUrl forKey:@"profileImageUrl"];
    [dict setValue:self.apnsEnabled forKey:@"apnsEnabled"];
    
    NSString *aString = [Utility asJson:dict];
    return aString;
}

//环境字典
- (NSMutableDictionary*) envdict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.deviceId forKey:@"device_id"];
    
    [dict setValue:self.deviceName forKey:@"device_name"];
    [dict setValue:self.deviceScreenSize forKey:@"device_screensize"];
    
    [dict setValue:self.osName forKey:@"os_name"];
    [dict setValue:self.osVersion forKey:@"os_version"];
    
    [dict setValue:self.packageVersion forKey:@"package_version"];
    [dict setValue:self.packageName forKey:@"package_name"];
    
    return dict;
}

//API调用参数DICT
- (NSMutableDictionary*) apidict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.sessionId == nil) {
        NSDate *now = [[NSDate alloc] init];
        self.sessionId = [NSString stringWithFormat:@"%ld", lrint([now timeIntervalSince1970])];
    }
    [dict setValue:self.sessionId forKey:@"sessionid"];
    [dict setValue:self.userName forKey:@"uname"];
    return dict;
}
- (NSMutableDictionary*) header{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.sessionId == nil) {
        NSDate *now = [[NSDate alloc] init];
        self.sessionId = [NSString stringWithFormat:@"%f", [now timeIntervalSince1970]];
    }
    [dict setValue:self.sessionId forKey:@"X-sessionid"];
    [dict setValue:self.appName forKey:@"X-app"];
    [dict setValue:self.deviceId forKey:@"X-cid"];
    [dict setValue:self.deviceName forKey:@"X-client"];
    [dict setValue:self.packageVersion forKey:@"X-ver"]; //客户端版本标示，用于跟踪使用情况
    [dict setValue:[[[AppSession current] getLocale] objectForKey:NSLocaleLanguageCode] forKeyPath:@"x-lang"];
    //Configuration
    NSString *signed_key = [self.config objectForKey:@"AppSecret"];
    assert(signed_key);
    if (signed_key!=nil && signed_key.length > 0) {
        NSString* data = [NSString stringWithFormat:@"%@%@%@", self.deviceId, self.appName, self.sessionId];
        LOG(@"signed_key: %@", signed_key);
        LOG(@"data: %@", data);
        [dict setValue:[data hmac:signed_key] forKey:@"X-signed"];
    }
    //cookie
    NSString* cookieId = [self.config objectForKey:@"CookieId"];
    if (cookieId !=nil ) {
        NSString* cookieSecret = [[self.config objectForKey:@"CookieSecret"] md5];
        long timestamp = 1000 * [[NSDate date] timeIntervalSince1970];
        NSData* ds = [[self.userId stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        NSString* uv = [NSString base64StringFromData:ds length:ds.length];
        LOG(@"uv:%@", uv);
        LOG(@"timestamp:%ld", timestamp);
        LOG(@"secret:%@", secret);
        NSString* sign = [NSString stringWithFormat:@"%ld|%@|%@|%@", timestamp, cookieSecret, cookieId, uv];
        ds = [[sign dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash];
        sign = [ds hexString];
        sign = [NSString stringWithFormat:@"%@|%ld|%@", uv, timestamp, sign];
        LOG(@"x-auth:%@", sign);
        [dict setValue:sign forKey:@"X-auth"];
    }
    
    LOG(@"header: %@", dict);
    return dict;
}

- (BOOL)appHasNewVers{
    if (self.latesAppVers == nil || self.latesAppVers.length == 0) {
        return NO;
    }
    BOOL flag = self.latesAppVers && [self.latesAppVers isEqualToString:self.packageVersion];
    return !flag;
}

- (void)savePortrait:(NSData *)data{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserPortrait];
    });
}

- (UIImage *)getPortrait{
    NSData *photoData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPortrait];
    if (photoData) {
        UIImage *image = [UIImage imageWithData:photoData];
        return image;
    }
    return nil;
}

- (BOOL)isEnabled:(NSString *)name{
    if (self.config) {
        NSNumber *val = [self.config objectForKey:name];
        if (val && val.intValue == 0) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)remember{
    //save session to local file
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* jsonData = [self asJSON];
    NSString* salt = [self.config objectForKey:@"AppSessionSalt"];
    NSString* encdata = [AESCrypt encrypt:jsonData password:salt];
    [defaults setValue:encdata forKey:kSessionCacheKey];
    [defaults synchronize];
}

-(void)clear{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kSessionCacheKey];
    [defaults synchronize];
}
- (void)load{
    //load session from local file.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *utf8JSON = (NSString *) [userDefaults stringForKey:kSessionCacheKey];
    if (utf8JSON) {
        NSString* salt = [self.config objectForKey:@"AppSessionSalt"];
        utf8JSON = [AESCrypt decrypt:utf8JSON password:salt];
        NSDictionary  *dictionary  =  [Utility asObject:utf8JSON];
        for (id key in dictionary) {
            [self setValue:[dictionary objectForKey:key] forKey:key];
        }
    }
    
    self.osName = [DeviceHelper getOSName];
    self.osVersion = [DeviceHelper getOSVersion];
    self.deviceName = [DeviceHelper getDeviceName];
    self.deviceScreenSize = [DeviceHelper getScreenSize];
    self.packageName = [DeviceHelper getAppName];
    self.packageVersion = [DeviceHelper getAppVersion];
    
    NSString *tmpId = [self.config objectForKey:@"AppDeviceId"];
    if (tmpId != nil) {
        self.deviceId = tmpId;
    }else{
        self.deviceId = [DeviceHelper getDeviceUdid];
    }
    self.appName = [self.config objectForKey:@"AppName"];
    assert(self.appName);
#ifdef AppLocal
    self.appMode = kAppModeLocal;
#endif
    
    NSDate *now = [[NSDate alloc] init];
    self.sessionId = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
}
@end
