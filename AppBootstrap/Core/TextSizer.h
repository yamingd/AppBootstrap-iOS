//
//  TextSizer.h
//  EnglishCafe
//
//  Created by Simsion on 17/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextSizer : NSObject

+(instancetype)create:(NSString*)text;

-(id)withText:(NSString*)txt;
-(id)withFont:(float)size;
-(id)withFont2:(UIFont*)font;
-(id)withSize:(float)width height:(float)height;
-(id)withLineBreak:(NSLineBreakMode)mode;

-(CGSize)compound;

-(CGSize)withLabel:(UILabel*)lbl width:(float)width height:(float)height;
-(CGSize)withLabel2:(UILabel*)lbl height:(float)height;

@property (nonatomic, strong)NSString* text;

@end
