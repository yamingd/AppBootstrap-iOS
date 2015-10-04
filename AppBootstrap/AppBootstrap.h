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

-(void)setRootController:(UIViewController *)vc;

-(NSString*)getAppNameString;

-(BOOL)shouldEnableAPNS;

-(void)application:(UIApplication *)application prepareAppSession:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareRootController:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareOpenControllers:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareDatabase:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareComponents:(NSDictionary *)launchOptions;

-(void)onNetworkLost;
-(void)onNetworkReconnect;

@end
