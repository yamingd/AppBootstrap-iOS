//
//  UIViewController+Ext.h
//  EnglishCafe
//
//  Created by yaming_deng on 15/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define ADD_DYNAMIC_PROPERTY(PROPERTY_TYPE,PROPERTY_NAME,SETTER_NAME) \
@dynamic PROPERTY_NAME ; \
static char kProperty##PROPERTY_NAME; \
- ( PROPERTY_TYPE ) PROPERTY_NAME \
{ \
return ( PROPERTY_TYPE ) objc_getAssociatedObject(self, &(kProperty##PROPERTY_NAME ) ); \
} \
\
- (void) SETTER_NAME :( PROPERTY_TYPE ) PROPERTY_NAME \
{ \
objc_setAssociatedObject(self, &kProperty##PROPERTY_NAME , PROPERTY_NAME , OBJC_ASSOCIATION_RETAIN); \
} \

@interface UIViewController (Ext)

-(void)ios7Fix;
-(void)contentSizeDidChange:(NSString *)size;

-(void)retinaFit;
-(void)fitHeight:(UIView*)view;

-(CGSize)sizeInPoint;
-(CGSize)ScreenSize;
-(BOOL)Retina;

/*navigation controller setting*/
-(void)setNavColor;
-(void)setNavLeftButton:(NSString*)title action:(SEL)action;
-(void)setNavLeftImage:(NSString*)name action:(SEL)action;

-(void)setNavRightButton:(NSString*)title action:(SEL)action;
-(void)setNavRightImage:(NSString*)name action:(SEL)action;

-(UIButton*)setNavShareImage:(SEL)action;

-(void)showLoadingCircle:(UIColor*)color;
-(void)hideLoadingCircle;

-(void)showLoadingCircleCenter:(UIColor*)color;
-(void)hideLoadingCircleCenter;

-(void)replaceWithLoadingCircle:(UIView*)view color:(UIColor*)color;
-(void)reshowReplacedView:(UIView*)view;

-(void)closeAction;
-(void)backToPrevView;
-(void)popupView:(UIViewController*)view;

-(void)doActionOnTime:(NSString*)key duration:(int)duration action:(void (^)(void))action;

@end
