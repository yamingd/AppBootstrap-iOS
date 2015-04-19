//
//  UIViewController+Ads.h
//  BookReader
//
//  Created by yaming_deng on 20/7/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __BAIDU_ADS__

#import "BaiduMobAdDelegateProtocol.h"
#import "BaiduMobAdInterstitialDelegate.h"
#import "BaiduMobAdView.h"
#import "BaiduMobAdInterstitial.h"

@interface UIViewController (Ads) <BaiduMobAdViewDelegate, BaiduMobAdInterstitialDelegate>

@property(strong, nonatomic) BaiduMobAdView* sharedAdView;
@property(strong, nonatomic) NSNumber* mobAdViewHidden;
@property(strong, nonatomic) BaiduMobAdInterstitial *adInter;
@property(strong, nonatomic) UIViewController *adsController;
@property(strong, nonatomic) NSNumber* adInterRolling;

//banner ads
- (void)showBaiduAds:(UIView*)relate;
- (void)removeBaiduAds;

//pop up ads
-(void)showInterstitialAds;
-(void)hideInterstitialAds;

@end

#endif
