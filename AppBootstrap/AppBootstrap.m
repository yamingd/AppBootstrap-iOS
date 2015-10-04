//
//  AppBootstrap.m
//  AppBootstrap
//
//  Created by Yaming on 10/28/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import "AppSession.h"
#import "AppBootstrap.h"
#import "AFNetworking.h"
#import "AFNetworking/AFNetworkActivityIndicatorManager.h"
#import "AFNetworkActivityLogger/AFNetworkActivityLogger.h"

@implementation AppBootstrap

- (void)setRootController:(UIViewController *)vc
{
    [self.window setRootViewController:vc];
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    LOG(@"willFinishLaunchingWithOptions");
    
    [self application:application prepareAppSession:launchOptions];
    [self application:application prepareDatabase:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(OSVersionIsAtLeastiOS7){
        [self.window setTintColor:kColor_tint];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor_text}];
    }
    
    [self application:application prepareRootController:launchOptions];
    
    return YES;
}

-(NSString*)getAppNameString{
    return @"appBootstrap";
}

-(BOOL)shouldEnableAPNS{
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the app badge to 0 when launching
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.launchOptions = launchOptions;
    LOG(@"didFinishLaunchingWithOptions BEGIN");
    if (launchOptions) {
        id value = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if (value) {
            NSDictionary *userInfo = (NSDictionary *)value;
            self.userNotification = userInfo;
        }
    }
    
    if ([self shouldEnableAPNS]) {
        
        //-- Set Notification
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [application registerForRemoteNotifications];
        }
        else
        {
            // iOS < 8 Notifications
            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        }
    }
    
    [self application:application prepareComponents:launchOptions];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (self.userNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotificationReceived object:nil userInfo:self.userNotification];
    }
    
    [self application:application prepareOpenControllers:launchOptions];
    
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
    
    [AppSession current].session.deviceToken = deviceTokenStr;
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
    return YES;
    //return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
    //return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - prepare

-(void)application:(UIApplication *)application prepareAppSession:(NSDictionary *)launchOptions{
    [[AppSession current] load:[self getAppNameString]];
}

-(void)application:(UIApplication *)application prepareRootController:(NSDictionary *)launchOptions{
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

-(void)application:(UIApplication *)application prepareOpenControllers:(NSDictionary *)launchOptions{
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    dispatch_async(kBG_QUEUE, ^{
        [self startNetworkMonitor];
    });
    
}

-(void)application:(UIApplication *)application prepareDatabase:(NSDictionary *)launchOptions{
    
}

-(void)application:(UIApplication *)application prepareComponents:(NSDictionary *)launchOptions{
    
}

#pragma mark - Network Monitor

static BOOL networNotReachableFlag = NO;

- (void)startNetworkMonitor{
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                LOG(@"网络不通");
                networNotReachableFlag = YES;
                [self onNetworkLost];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                LOG(@"网络通过WIFI连接");
                if (networNotReachableFlag) {
                    networNotReachableFlag = NO;
                    [self onNetworkReconnect];
                }
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                LOG(@"网络通过无线连接");
                if (networNotReachableFlag) {
                    networNotReachableFlag = NO;
                    [self onNetworkReconnect];
                }
                break;
            }
            default:
                break;
        }
        
        LOG(@"网络状态数字返回：%i", status)
        LOG(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
    }];
    
    //return [AFNetworkReachabilityManager sharedManager].isReachable;
}

-(void)onNetworkLost{
    
}

-(void)onNetworkReconnect{
    
}

@end
