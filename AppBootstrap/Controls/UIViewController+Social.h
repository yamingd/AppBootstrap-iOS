//
//  UIViewController+Social.h
//  BookReader
//
//  Created by yaming_deng on 20/7/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface UIViewController (Social)<UMSocialUIDelegate>

- (void)openShareActions:(NSString*)msg image:(UIImage*)image;
- (void)postShareAction;
- (NSDictionary*)shareArgs;

@end
