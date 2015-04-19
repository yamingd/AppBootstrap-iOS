//
//  UIView+HUD.m
//  k12
//
//  Created by jiaxiaobang on 15/1/10.
//  Copyright (c) 2015年 jiaxiaobang.com. All rights reserved.
//

#import "UIView+HUD.h"

#define kToastDefaultDuration 1.2

@implementation UIView(HUD)

- (void)showHUD:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = text;
}

- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)showToast:(NSString *)text
{
    [self showToast:text afterDelay:kToastDefaultDuration];
}

- (void)showToast:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.userInteractionEnabled = NO;    //can touch while show toast
    [hud hide:YES afterDelay:delay];
}

@end
