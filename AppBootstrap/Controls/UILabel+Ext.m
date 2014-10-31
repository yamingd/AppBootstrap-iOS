//
//  UILabel+Ext.m
//  EnglishCafe
//
//  Created by Simsion on 10/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "UILabel+Ext.h"

@implementation UILabel (Ext)

- (void) setVerticalAlignmentTop
{
    CGSize textSize = [self.text sizeWithFont:self.font
                            constrainedToSize:self.frame.size
                                lineBreakMode:self.lineBreakMode];
    
    CGRect textRect = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y,
                                 self.frame.size.width,
                                 textSize.height);
    [self setFrame:textRect];
    [self setNeedsDisplay];
}

@end
