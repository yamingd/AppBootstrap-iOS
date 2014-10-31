//
//  TextSizer.m
//  EnglishCafe
//
//  Created by yaming_deng on 17/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "TextSizer.h"

@implementation TextSizer{
    UIFont* _font;
    CGSize _range;
    NSLineBreakMode _mode;
    CGSize actualSize;
}

+(instancetype)create:(NSString*)text{
    TextSizer* inst = [[TextSizer alloc] init];
    inst.text = text;
    return inst;
}
- (id)init{
    _font = [UIFont systemFontOfSize:12.0f];
    _mode = NSLineBreakByWordWrapping;
    _range = CGSizeMake(100.0, 100.0);
    actualSize = CGSizeMake(0, 0);
    return self;
}
-(id)withFont:(float)size{
    _font = [UIFont systemFontOfSize:size];
    return self;
}
-(id)withFont2:(UIFont*)font{
    _font = font;
    return self;
}
-(id)withSize:(float)width height:(float)height{
    _range = CGSizeMake(width, height);
    return self;
}
-(id)withText:(NSString*)txt{
    _text = txt;
    return self;
}
-(id)withLineBreak:(NSLineBreakMode)mode{
    _mode = mode;
    return self;
}

-(CGSize)compound{
    actualSize = [self.text sizeWithFont:_font constrainedToSize:_range lineBreakMode:_mode];
    return actualSize;
}

-(CGSize)withLabel:(UILabel*)lbl width:(float)width height:(float)height{
    self.text = lbl.text;
    _font = lbl.font;
    _range = CGSizeMake(width, height);
    return [self compound];
}
-(CGSize)withLabel2:(UILabel*)lbl height:(float)height{
    self.text = lbl.text;
    _font = lbl.font;
    _range = CGSizeMake(lbl.frame.size.width, height);
    return [self compound];
}

@end
