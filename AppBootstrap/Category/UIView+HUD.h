//
//  UIView+HUD.h
//  k12
//
//  Created by jiaxiaobang on 15/1/10.
//  Copyright (c) 2015年 jiaxiaobang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView(HUD)

- (void)showHUD:(NSString *)text;
- (void)hideHUD;

- (void)showToast:(NSString *)text;
- (void)showToast:(NSString *)text afterDelay:(NSTimeInterval)delay;

@end
