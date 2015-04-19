//
//  KMobClick.m
//
//  Created by JoeyZeng on 14-3-28.
//  Copyright (c) 2014年 inno.com. All rights reserved.
//

#import "KMobClick.h"

#define UmengLogEnabled 1   //是否打印统计log (比较耗性能，调试Umeng可以开启跟踪，发布要关闭)

static BOOL isEventEnable = NO;

@implementation KMobClick

+ (void)start
{
    isEventEnable = [[[AppSession current].config objectForKey:@"AppUMengEnable"] boolValue];
    
    if (isEventEnable) {
        NSString* appKey = [[AppSession current].config objectForKey:@"AppUMengId"];
        [self startWithAppkey:appKey reportPolicy:REALTIME channelId:nil];
        [self setAppVersion:UmengVersion];
        [self setCrashReportEnabled:YES];
        [self setLogEnabled:UmengLogEnabled];
    }
}

+ (void)event:(NSString *)eventId
{
    if (isEventEnable) {
        [super event:eventId];
    }
}

+ (void)event:(NSString *)eventId label:(NSString *)label
{
    if (isEventEnable) {
        [super event:eventId label:label];
    }
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    if (isEventEnable) {
        [super event:eventId attributes:attributes];
    }
}

+ (void)beginLogPageView:(NSString *)pageName
{
    if (isEventEnable) {
        [super beginLogPageView:pageName];
    }
}

+ (void)endLogPageView:(NSString *)pageName
{
    if (isEventEnable) {
        [super endLogPageView:pageName];
    }
}

@end
