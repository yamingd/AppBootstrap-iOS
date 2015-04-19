//
//  UIImageEdView.h
//  k12
//
//  Created by Yaming on 3/13/15.
//  Copyright (c) 2015 jiaxiaobang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUIImageViewStateThumb @"thumb"
#define kUIImageViewStateFull @"full"

@class UIImageEdView;

@protocol UIImageEdViewDelegate <NSObject>

@optional
-(void)onUIImageEdViewDeleted:(id)sender;

- (void)onPresentEnlargeImageView:(UIImageEdView *)imageView;
- (void)onDismissEnlargeImageView:(UIImageEdView *)imageView;

@end

@interface UIImageEdView : UIImageView{
    UIButton* _imgRemoveIcon;
    CGRect _originalFrame;
    NSString* _removeIconName;
    NSString* _thumbUrl;
    NSString* _bigUrl;
    BOOL _enableRemove;
    BOOL _enableEnlarge;
}

@property (nonatomic, weak) id<UIImageEdViewDelegate> delegate;

@property id data;

-(instancetype)setEnableEnlarge:(BOOL)able;

-(instancetype)setRemoveIcon:(NSString*)iconName;

-(instancetype)setImagehUrl:(NSString*)thumbUrl bigUrl:(NSString*)bigUrl holder:(NSString*)holder;
-(instancetype)setImagehUrl:(NSString *)thumbUrl bigUrl:(NSString *)bigUrl holderImage:(UIImage*)holderImage;

-(instancetype)setImageData:(NSData*)imgData;

-(instancetype)makeRound;

-(instancetype)makeCornerRound:(float)radius;

-(instancetype)addBorder:(float)width color:(UIColor*)color;

-(void)showFullScreen;

@end
