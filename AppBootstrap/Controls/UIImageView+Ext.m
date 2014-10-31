//
//  UIImageView+Ext.m
//  EnglishCafe
//
//  Created by yaming_deng on 14/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "UIImageView+Ext.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Ext)

- (void)setImageWith:(NSString *)urlOrName
         placeholder:(NSString *)holderName{
    
    UIImage* holder = nil;
    if (holderName) {
        holder = [UIImage imageNamed:holderName];
    }
    if (urlOrName.length == 0) {
        [self setImage:holder];
        return;
    }
    if ([urlOrName hasPrefix:@"http://"]) {
        [self setImageWithURL:[NSURL URLWithString:urlOrName] placeholderImage:holder];
    }else{
        [self setImage:[UIImage imageNamed:urlOrName]];
    }
    
}

@end
