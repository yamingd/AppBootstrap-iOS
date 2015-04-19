//
//  UITabBarController+Ext.m
//  EnglishCafe
//
//  Created by Simsion on 11/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "UITabBarController+Ext.h"

@implementation UITabBarController (Ext)

- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:YES];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (self.tabBar.hidden == hidden)
        return;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    BOOL isLandscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
    float height =  isLandscape ? screenSize.width : screenSize.height;
    
    if (!hidden)
        height -= CGRectGetHeight(self.tabBar.frame);
    
    void (^animations)();
    
    // Check if running iOS 7
    if ([self.tabBar respondsToSelector:@selector(barTintColor)])
    {
        UIView *view = self.selectedViewController.view;
        
        animations = ^{
            
            CGRect frame = self.tabBar.frame;
            frame.origin.y = height;
            self.tabBar.frame = frame;
            
            frame = view.frame;
            frame.size.height += (hidden ? 1.0f : -1.0f) * CGRectGetHeight(self.tabBar.frame);
            view.frame = frame;
        };
    }
    else
    {
        animations = ^{
            for (UIView *subview in self.view.subviews)
            {
                CGRect frame = subview.frame;
                
                if (subview == self.tabBar)
                {
                    frame.origin.y = height;
                }
                else
                {
                    frame.size.height = height;
                }
                
                subview.frame = frame;
            }
        };
    }
    
    [UIView animateWithDuration:(animated ? 0.25f : 0) animations:animations completion:^(BOOL finished) {
        self.tabBar.hidden = hidden;
    }];
}

@end
