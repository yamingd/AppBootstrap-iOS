//
//  AppBootstrap.h
//  AppBootstrap
//
//  Created by Yaming on 10/28/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppBootstrap : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *launchOptions;
@property (strong, nonatomic) NSDictionary *userNotification;

-(void)initRootController;
-(void)init3rdOptions;
-(void)initRateLaunch;
-(void)removeTempData;

@end
