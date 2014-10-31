//
//  sdk.h
//  AppBootstrap
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#ifndef _sdk_h
#define _sdk_h

#define kRemoteNotificationReceived @"Notification_RemoteNotificationReceived"
#define kRemoteNotificationAccepted @"Notification_RemoteNotificationAccepted"
#define kAppMode @"AppMode"
#define kNotificationNetworkError @"Notification_NetworkError"

#define SHARED_INSTANCE_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

//for log, useage:use LOG instand of NSLog
#ifdef DEBUG
#define LOG(fmt, ...) NSLog((@"[%s,line:%d]\n>> " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define LOG(...);
#endif

#define kBG_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

static BOOL OSVersionIsAtLeastiOS7() {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}

#import "Model.h"
#import "Utility.h"
#import "APIClient.h"
#import "AppResponse.h"
#import "AppSession.h"
#import "TaskExecutor.h"
#import "ModelSqlEngine.h"
#import "XibFactory.h"
#import "NSString+Base64.h"
#import "NSString+MD5.h"
#import "AudioPlayerView.h"

#endif
