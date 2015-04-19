//
//  LPlaceholderTextView.h
//  k12
//
//  Created by Yaming on 3/4/15.
//  Copyright (c) 2015 jiaxiaobang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPlaceholderTextView : UITextView
{
    UILabel *_placeholderLabel;
}


@property (strong, nonatomic) NSString *placeholderText;
@property (strong, nonatomic) UIColor *placeholderColor;

@end
