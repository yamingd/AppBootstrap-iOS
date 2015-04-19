//
//  FDDMobClick.h
//  SecondHouseBroker
//
//  Created by JoeyZeng on 14-3-28.
//  Copyright (c) 2014年 Lin Dongpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"

#define UmengVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

@interface KMobClick : MobClick

+ (void)start;

+ (void)event:(NSString *)eventId;
+ (void)event:(NSString *)eventId label:(NSString *)label;
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;

@end
