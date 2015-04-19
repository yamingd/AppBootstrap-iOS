//
//  UIImageView+Ext.h
//  EnglishCafe
//
//  Created by yaming_deng on 14/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Ext)

- (void)setImageWith:(NSString *)urlOrName
         placeholder:(NSString *)holderName;

- (void)setImageWithHolder:(NSString *)urlOrName
         placeholder:(UIImage *)holder;

- (void)circleCover;
- (void)roundCover:(float)radius;

@end
