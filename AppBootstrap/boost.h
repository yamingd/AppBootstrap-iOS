//
//  sdk.h
//  AppBootstrap
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#ifndef _boost_h
#define _boost_h

#define kRemoteNotificationReceived @"RemoteNotificationReceived"
#define kRemoteNotificationAccepted @"RemoteNotificationAccepted"
#define kNotificationNetworkError @"NotificationNetworkError"
#define kNotificationServerError @"NotificationServerError"

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
#define kMAIN_QUEUE dispatch_get_main_queue()

#define OSVersionIsAtLeastiOS7 floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1

#define ADD_DYNAMIC_PROPERTY(PROPERTY_TYPE,PROPERTY_NAME,SETTER_NAME) \
@dynamic PROPERTY_NAME ; \
static char kProperty##PROPERTY_NAME; \
- ( PROPERTY_TYPE ) PROPERTY_NAME \
{ \
return ( PROPERTY_TYPE ) objc_getAssociatedObject(self, &(kProperty##PROPERTY_NAME ) ); \
} \
\
- (void) SETTER_NAME :( PROPERTY_TYPE ) PROPERTY_NAME \
{ \
objc_setAssociatedObject(self, &kProperty##PROPERTY_NAME , PROPERTY_NAME , OBJC_ASSOCIATION_RETAIN); \
} \

// weakself define
#define WEAKSELF_DEFINE \
__weak typeof(self) weakSelf = self;


#define BUTTON_TITLE_FONT [UIFont boldSystemFontOfSize:16]

//RGB转UIColor函数
#define	UIColorFromRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0  \
blue:b/255.0 alpha:1.0]

/**
 *  使用方式是UIColorHexFromRGB(0x067AB5);
 */
#define UIColorHexFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorHexFromRGBAlpha(rgbValue,alp) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]


#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kColor_tint     UIColorFromRGB(232, 70, 90)
#define kColor_tint_h   UIColorFromRGB(175, 48, 66)
#define kColor_tint_disable   UIColorFromRGB(242, 156, 159)
#define kColor_text_btn_disable    UIColorFromRGB(249, 210, 212)
#define kColor_line [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]
#define kColor_gray     UIColorFromRGB(136, 136, 136)
#define kColor_lightGray     UIColorFromRGB(237, 237, 237)
#define kColor_text    UIColorFromRGB(85, 85, 85)
#define kColor_red    UIColorFromRGB(232, 64, 52)

#endif
