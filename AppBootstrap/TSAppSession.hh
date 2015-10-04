//
//  TSAppSession.h
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 whosbean.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "PBObjcWrapper.hh"

@interface TSAppSession : RLMObject<PBObjcWrapper>

@property int id;
@property NSString* sessionId;
@property NSString* realName;
@property NSString* userName;
@property long userId;
@property NSString* secret;
@property NSString* signinDate;
@property NSString* profileImageUrl;

@property NSString* appName;
@property NSString* deviceName;
@property NSString* deviceScreenSize;
@property NSString* osName;
@property NSString* osVersion;
@property NSString* packageVersion;
@property NSString* packageName;
@property NSString* deviceId;
@property NSString* deviceToken;

@property int apnsEnabled;
@property int latestAppVerCode;
@property NSString* localIdentifier;

@property float latitude;
@property float longitude;

@property int cityId;
@property int userKind;
@property int userDemo;

+(instancetype)newOne;

-(void)resetSessionId;

@end

