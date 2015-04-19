//
//  UIImageEdView.m
//  k12
//
//  Created by Yaming on 3/13/15.
//  Copyright (c) 2015 jiaxiaobang.com. All rights reserved.
//

#import "UIImageEdView.h"
#import "UIImageView+Ext.h"
#import "UIImageView+WebCache.h"

@implementation UIImageEdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)setRemoveIcon:(NSString *)iconName{
    float width = self.frame.size.width;
    _removeIconName = iconName;
    _enableRemove = YES;
    _imgRemoveIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imgRemoveIcon setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [_imgRemoveIcon sizeToFit];
    [_imgRemoveIcon setFrame:CGRectMake(width - 20, 0, 20, 20)];
    [self addSubview:_imgRemoveIcon];
    _imgRemoveIcon.tag = 1;
    [_imgRemoveIcon addTarget:self action:@selector(onDeleteButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

-(instancetype)setImagehUrl:(NSString *)thumbUrl bigUrl:(NSString *)bigUrl holder:(NSString*)holder{
    _thumbUrl = thumbUrl;
    _bigUrl = bigUrl;
    
    [self setImageWith:_thumbUrl placeholder:holder];
    
    return self;
}

-(instancetype)setImagehUrl:(NSString *)thumbUrl bigUrl:(NSString *)bigUrl holderImage:(UIImage*)holderImage{
    _thumbUrl = thumbUrl;
    _bigUrl = bigUrl;
    
    [self setImageWithHolder:_thumbUrl placeholder:holderImage];
    
    return self;
}

-(instancetype)setImageData:(NSData *)imgData{
    self.image  = [UIImage imageWithData:imgData];
    return self;
}

-(instancetype)setEnableEnlarge:(BOOL)able{
    _enableEnlarge = able;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onImageTouched:)];
    [gesture setNumberOfTapsRequired:1];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:gesture];
    
    return self;
}

-(void)onImageTouched:(UITapGestureRecognizer*)tap{
    __block UIImage* image = self.image;
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _originalFrame=[self convertRect:self.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    
    __block CGSize imgsize = image.size;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:_originalFrame];
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBigImage:)];
    [backgroundView addGestureRecognizer: tap2];
    
    if (_bigUrl) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:_bigUrl] placeholderImage:image completed:^(UIImage *imageBig, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                image = imageBig;
            }
            imgsize = image.size;
            [UIView animateWithDuration:0.3 animations:^{
                float r = size.width/imgsize.width;
                imageView.frame=CGRectMake(0,(size.height-imgsize.height*r)/2, size.width, imgsize.height*r);
                backgroundView.alpha=1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        imageView.image = image;
        [UIView animateWithDuration:0.3 animations:^{
            float r = size.width/imgsize.width;
            imageView.frame=CGRectMake(0,(size.height-imgsize.height*r)/2, size.width, imgsize.height*r);
            backgroundView.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(onPresentEnlargeImageView:)]) {
        [self.delegate onPresentEnlargeImageView:self];
    }
}

- (void)closeBigImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=_originalFrame;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(onDismissEnlargeImageView:)]) {
            [self.delegate onDismissEnlargeImageView:self];
        }
    }];
}

-(void)onDeleteButtonTouched{
    [self removeFromSuperview];
    if (self.delegate) {
        [self.delegate onUIImageEdViewDeleted:self];
    }
}

-(instancetype)makeRound{
    self.contentMode = UIViewContentModeScaleAspectFill;
    float radius = self.frame.size.width / 2;
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radius];
    return self;
}

-(instancetype)makeCornerRound:(float)radius{
    self.layer.cornerRadius = radius;
    return self;
}

-(instancetype)addBorder:(float)width color:(UIColor*)color{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    return self;
}

-(void)showFullScreen{
    [self onImageTouched:nil];
}

@end
