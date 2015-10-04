//
//  TSAppSession.m
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 whosbean.com. All rights reserved.
//

#import "TSAppSession.hh"
#import "PAppSession.pb.hh"
#import "PBObjc.hh"

@implementation TSAppSession

+(instancetype)newOne{
    TSAppSession* one = [[TSAppSession alloc] init];
    one.id = 1;
    one.realName = @"Guest";
    one.userName = @"Guest";
    one.userId = 0;
    one.deviceToken = @"NULL";
    
    return one;
}

-(void)resetSessionId{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    self.sessionId = [NSString stringWithFormat:@"%llu",dTime];
}

-(instancetype) initWithProtocolData:(NSData*) data {
    return [self initWithData:data];
}
-(instancetype) initWithProtocolObj:(google::protobuf::Message*)pbmsg{
    // c++
    if (self = [super init]) {
        PAppSession *pbobj = (PAppSession *)pbmsg;
        //
        [self initValues:pbobj];
    }
    return self;
}

- (void)initValues:(PAppSession *)pbobj {
    self.id = 1;
    if (pbobj->has_sessionid()) {
        const std::string str = pbobj->sessionid();
        self.sessionId = [PBObjc cppStringToObjc:str];
    }else{
        [self resetSessionId];
    }
    if (pbobj->has_realname()) {
        const std::string str = pbobj->realname();
        self.realName = [PBObjc cppStringToObjc:str];
    }
    else {
        self.realName = @"Guest";
    }
    if (pbobj->has_username()) {
        const std::string str = pbobj->username();
        self.userName = [PBObjc cppStringToObjc:str];
    }
    else {
        self.userName = @"Guest";
    }
    if (pbobj->has_userid()) {
        const uint64_t val = pbobj->userid();
        self.userId = [PBObjc cppUInt64ToLong:val];
    }else{
        self.userId = 0;
    }
    if (pbobj->has_secret()) {
        const std::string str = pbobj->secret();
        self.secret = [PBObjc cppStringToObjc:str];
    }
    else {
        self.secret = @"secret";
    }
    if (pbobj->has_signindate()) {
        const std::string str = pbobj->signindate();
        self.signinDate = [PBObjc cppStringToObjc:str];
    }
    else {
        self.secret = @"";
    }
    if (pbobj->has_appname()) {
        const std::string str = pbobj->appname();
        self.appName = [PBObjc cppStringToObjc:str];
    }
    else {
        self.appName = @"";
    }
    if (pbobj->has_devicename()) {
        const std::string str = pbobj->devicename();
        self.deviceName = [PBObjc cppStringToObjc:str];
    }
    else {
        self.deviceName = @"";
    }
    if (pbobj->has_devicescreensize()) {
        const std::string str = pbobj->devicescreensize();
        self.deviceScreenSize = [PBObjc cppStringToObjc:str];
    }
    else {
        self.deviceScreenSize = @"";
    }
    if (pbobj->has_osname()) {
        const std::string str = pbobj->osname();
        self.osName = [PBObjc cppStringToObjc:str];
    }
    else {
        self.osName = @"";
    }
    if (pbobj->has_osversion()) {
        const std::string str = pbobj->osversion();
        self.osVersion = [PBObjc cppStringToObjc:str];
    }
    else {
        self.osVersion = @"";
    }
    if (pbobj->has_packageversion()) {
        const std::string str = pbobj->packageversion();
        self.packageVersion = [PBObjc cppStringToObjc:str];
    }
    else {
        self.packageVersion = @"";
    }
    if (pbobj->has_packagename()) {
        const std::string str = pbobj->packagename();
        self.packageName = [PBObjc cppStringToObjc:str];
    }
    else {
        self.packageName = @"";
    }
    if (pbobj->has_deviceid()) {
        const std::string str = pbobj->deviceid();
        self.deviceId = [PBObjc cppStringToObjc:str];
    }
    else {
        self.deviceId = @"";
    }
    if (pbobj->has_devicetoken()) {
        const std::string str = pbobj->devicetoken();
        self.deviceToken = [PBObjc cppStringToObjc:str];
    }
    else {
        self.deviceToken = @"NULL";
    }
    if (pbobj->has_apnsenabled()) {
        const uint32_t val = pbobj->apnsenabled();
        self.apnsEnabled = [PBObjc cppUInt32ToInt:val];
    }else{
        self.apnsEnabled = 0;
    }
    if (pbobj->has_latesappvers()) {
        const std::string str = pbobj->latesappvers();
        NSString* ss = [PBObjc cppStringToObjc:str];
        self.latestAppVerCode = [ss intValue];
    }else{
        self.latestAppVerCode = 0;
    }
    if (pbobj->has_localeidentifier()) {
        const std::string str = pbobj->localeidentifier();
        self.localIdentifier = [PBObjc cppStringToObjc:str];
    }
    else {
        self.localIdentifier = @"zh";
    }
    if (pbobj->has_latitude()) {
        const float val = pbobj->latitude();
        self.latitude = val;
    }else{
        self.latitude = 0;
    }
    if (pbobj->has_longitude()) {
        const float val = pbobj->longitude();
        self.longitude = val;
    }else{
        self.longitude = 0;
    }
    if (pbobj->has_cityid()) {
        const uint32_t val = pbobj->cityid();
        self.cityId = [PBObjc cppUInt32ToInt:val];
    }else{
        self.cityId = 0;
    }
    if (pbobj->has_userkind()) {
        const uint32_t val = pbobj->userkind();
        self.userKind = [PBObjc cppUInt32ToInt:val];
    }else{
        self.userKind = 0;
    }
    if (pbobj->has_userdemo()) {
        const uint32_t val = pbobj->userdemo();
        self.userDemo = [PBObjc cppUInt32ToInt:val];
    }else{
        self.userDemo = 0;
    }
}

-(NSMutableDictionary*)asDict{
    return nil;
}

-(NSData*) getProtocolData{
    return nil;
}

-(instancetype) initWithData:(NSData*) data {
    
    if(self = [super init]) {
        // c++
        PAppSession* resp = [self deserialize:data];
        self = [self initWithProtocolObj:resp];
    }
    return self;
}

+ (NSString *)primaryKey {
    return @"id";
}

#pragma mark private

-(const std::string) serializedProtocolBufferAsString {
    PAppSession *message = new PAppSession;
    std::string ps = message->SerializeAsString();
    return ps;
}

#pragma mark private methods
- (PAppSession *)deserialize:(NSData *)data {
    int len = [data length];
    char raw[len];
    PAppSession *resp = new PAppSession;
    [data getBytes:raw length:len];
    resp->ParseFromArray(raw, len);
    return resp;
}

@end
