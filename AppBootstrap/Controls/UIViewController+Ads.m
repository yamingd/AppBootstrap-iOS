//
//  UIViewController+Ads.m
//  BookReader
//
//  Created by yaming_deng on 20/7/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "UIViewController+Ads.h"
#import "MobClick.h"

@implementation UIViewController (Ads)

ADD_DYNAMIC_PROPERTY(UIViewController*, adsController, setAdsController);
ADD_DYNAMIC_PROPERTY(NSNumber*, mobAdViewHidden, setMobAdViewHidden);
ADD_DYNAMIC_PROPERTY(BaiduMobAdInterstitial*, adInter, setAdInter);
ADD_DYNAMIC_PROPERTY(BaiduMobAdView*, sharedAdView, setSharedAdView);
ADD_DYNAMIC_PROPERTY(NSNumber*, adInterRolling, setAdInterRolling);

- (NSString *)publisherId
{
    NSString* baiduId = @"debug";
#ifndef DEBUG
    baiduId = [[AppSession current].config objectForKey:@"baidu.publisherId"];
#endif
    baiduId = [[AppSession current].config objectForKey:@"baidu.publisherId"];
    return  baiduId;
}

- (NSString*) appSpec
{
    NSString* baiduId = @"debug";
#ifndef DEBUG
    baiduId = [[AppSession current].config objectForKey:@"baidu.publisherId"];
#endif
    baiduId = [[AppSession current].config objectForKey:@"baidu.publisherId"];
    return  baiduId;
    
}

-(BOOL) enableLocation
{
    //启用location会有一次alert提示
    return NO;
}

// Baidu Ads
- (void)initBaiduAds{
    //call this on viewDidLoad once only
    if (self.sharedAdView) {
        return;
    }
    LOG(@"initBaiduAds");
    self.mobAdViewHidden = @(1);
    //使用嵌入广告的方法实例。
    self.sharedAdView = [[BaiduMobAdView alloc] init];
    self.sharedAdView.hidden = YES;
    //sharedAdView.AdUnitTag = @"myAdPlaceId1";
    //此处为广告位id，可以不进行设置，如需设置，在百度移动联盟上设置广告位id，然后将得到的id填写到此处。
    self.sharedAdView.AdType = BaiduMobAdViewTypeBanner;
    self.sharedAdView.delegate = self;
    [self.sharedAdView start];
}
- (void)removeBaiduAds{
    if (self.sharedAdView) {
        [self.sharedAdView removeFromSuperview];
    }
    self.sharedAdView = nil;
}
- (void)showBaiduAds:(UIView*)relate{
    if (!self.sharedAdView) {
        [self initBaiduAds];
    }
    [self.view addSubview:self.sharedAdView];
    self.mobAdViewHidden = @(0);
    self.sharedAdView.hidden = NO;
    float y = [self sizeInPoint].height;
    if (relate) {
        y = relate.frame.origin.y + relate.frame.size.height + 10;
    }
    if (!self.navigationController.navigationBarHidden) {
        y = y - self.navigationController.navigationBar.frame.size.height;
    }
    if (self.tabBarController.tabBar) {
        y = y - self.tabBarController.tabBar.frame.size.height;
    }
    y = y - 48;
    LOG(@"showBaiduAds. y = %f", y);
    self.sharedAdView.frame = CGRectMake(0, y, 320, 48);
    [self.view bringSubviewToFront:self.sharedAdView];
}
-(void) willDisplayAd:(BaiduMobAdView*) adview
{
    if (self.mobAdViewHidden.intValue == 1 || !self.sharedAdView) {
        if (self.sharedAdView) {
            self.sharedAdView.hidden = YES;
        }
        return;
    }
    //在广告即将展示时，产生一个动画，把广告条加载到视图中
    self.sharedAdView.hidden = NO;
    CGRect f = self.sharedAdView.frame;
    f.origin.x = -320;
    self.sharedAdView.frame = f;
    [UIView beginAnimations:nil context:nil];
    f.origin.x = 0;
    self.sharedAdView.frame = f;
    [UIView commitAnimations];
    LOG(@"delegate: will display ad. y = %f", f.origin.y);
    
}

-(void) failedDisplayAd:(BaiduMobFailReason) reason;
{
    LOG(@"delegate: failedDisplayAd %d", reason);
}

//弹出ads
-(void)loadInterstitialAds{
	self.adInter = [[BaiduMobAdInterstitial alloc] init];
    self.adInter.interstitialType = BaiduMobAdViewTypeInterstitialReader;
    self.adInter.delegate = self;
    self.adInterRolling = @(0);
    [self.adInter load];
}
- (void)initRootController{
    if (self.adsController) {
        [self closeAdsRootView];
        self.adsController = nil;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.adsController=[[UIViewController alloc] init];
    UIApplication* clientApp = [UIApplication sharedApplication];
    UIWindow* topWindow = [clientApp keyWindow];
    if (!topWindow){
        topWindow = [[clientApp windows] objectAtIndex:0];
    }
    //self.adsController.view.backgroundColor = [UIColor redColor];
    self.adsController.view.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    [topWindow addSubview:self.adsController.view];
    LOG(@"initRootController.");
}
- (void)closeAdsRootView{
    self.adsController.view.hidden = YES;
    for (UIView* view in self.adsController.view.subviews) {
        LOG(@"view: %@", view);
        [view removeFromSuperview];
    }
    [self.adsController.view removeFromSuperview];
}
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial{
    self.adsController.view.hidden = NO;
    dispatch_sync(kBG_QUEUE, ^{
        [MobClick event:@"ad_inter_show"];
    });
    LOG("interstitialSuccessPresentScreen");
}
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)interstitial{
    [self closeAdsRootView];
    self.adInterRolling = @(self.adInterRolling.intValue + 1);
    dispatch_sync(kBG_QUEUE, ^{
        [MobClick event:@"ad_inter_dismiss"];
    });
    LOG("interstitialDidDismissScreen");
}
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason{
    [self closeAdsRootView];
    LOG("interstitialFailPresentScreen: %d", reason);
}
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial{
    [self closeAdsRootView];
    LOG("interstitialFailToLoadAd");
}
-(void)hideInterstitialAds{
    if (self.adsController) {
        [self closeAdsRootView];
        self.adInterRolling = @(-1);
        self.adsController = nil;
        LOG("hideInterstitialAds");
    }
}
-(void)showInterstitialAds{
    LOG(@"adInterRolling %@", self.adInterRolling);
    if (self.adInterRolling.intValue == -1) {
        [self hideInterstitialAds];
        return;
    }
    if (self.adInter == nil) {
        LOG(@"adInter init.");
        [self loadInterstitialAds];
    }
    [self initRootController];
    if (self.adsController) {
        //self.adsController.view.hidden = NO;
        [self.adInter presentFromRootViewController:self.adsController];
    }
    int ts = 30 * self.adInterRolling.intValue;
    if (ts == 0) {
        ts = 10;
    }
    dispatch_sync(kBG_QUEUE, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ts * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showInterstitialAds];
        });
    });
}

@end
