//
//  AppBootstrap.m
//  AppBootstrap
//
//  Created by Yaming on 10/28/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import "AppBootstrap.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "KMobClick.h"
#import "AFNetworking/AFNetworkActivityIndicatorManager.h"
#import "AFNetworkActivityLogger/AFNetworkActivityLogger.h"

@implementation AppBootstrap

-(void)init3rdOptions{
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSString* appKey = [[AppSession current].config objectForKey:@"AppUMengId"];
    BOOL appUMengEnable = [[[AppSession current].config objectForKey:@"AppUMengEnable"] boolValue];
    
    if (appUMengEnable) {
        [UMSocialData setAppKey:appKey];
    }
    
    NSDictionary* qq = [[AppSession current].config objectForKey:@"QQ"];
    NSString* storeUrl = [[AppSession current].config objectForKey:@"StoreUrl"];
    if (qq && storeUrl) {
        [UMSocialQQHandler setQQWithAppId:[qq objectForKey:@"AppId"] appKey:[qq objectForKey:@"AppKey"] url:storeUrl];
        [UMSocialWechatHandler setWXAppId:[qq objectForKey:@"wxId"] appSecret:[qq objectForKey:@"wxSecret"] url:storeUrl];
    }
    
    [KMobClick start];
}
-(void)initRootController{
    //TODO: implement in subclass.
    /*
     NSString* appTitle = [[AppSession current].config objectForKey:@"AppTitle"];
     self.loadingController = [[LoadingViewController alloc] init];
     self.loadingController.title = appTitle;
     self.navController = [[UINavigationController alloc] init];
     [self.navController pushViewController:self.loadingController animated:YES];
     [self.window setRootViewController:self.navController];
     */
}
- (void)setRootController:(UIViewController *)vc
{
    [self.window setRootViewController:vc];
}
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    LOG(@"willFinishLaunchingWithOptions");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(OSVersionIsAtLeastiOS7){
        [self.window setTintColor:kColor_tint];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor_text}];
    }
    
    [self initRootController];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.launchOptions = launchOptions;
    LOG(@"didFinishLaunchingWithOptions BEGIN");
    if (launchOptions) {
        id value = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if (value) {
            NSDictionary *userInfo = (NSDictionary *)value;
            self.userNotification = userInfo;
        }
    }
    
    if ([[AppSession current] apnsEnabled]) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound ];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self init3rdOptions];
    [self initRateLaunch];
    
    return YES;
    
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}
- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return nil;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    @try {
        [self removeTempData];
        LOG(@"remove dbfile. app and vocas.");
    }
    @catch (NSException *exception) {
        
    }
}
-(void)removeTempData{
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [AppSession current].deviceToken = deviceTokenStr;
    [[AppSession current] remember];
    NSMutableDictionary* userinfo = [[NSMutableDictionary alloc] init];
    [userinfo setObject:deviceToken forKey:@"token"];
    LOG(@"Device Token: %@", deviceTokenStr);
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotificationAccepted object:nil userInfo:userinfo];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    LOG(@"%@", [NSString stringWithFormat:@"Error:%@", error]);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotificationReceived object:nil userInfo:userInfo];
}

//QQ分享集成
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


@end
