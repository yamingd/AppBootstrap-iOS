//
//  UIViewController+Ext.m
//  EnglishCafe
//  http://imallen.com/blog/2013/10/22/how-to-set-bartintcolor-correctly-in-ios-7.html
//  Created by yaming_deng on 15/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "UIViewController+Ext.h"
#import "HYCircleLoadingView.h"

@implementation UIViewController (Ext)

-(void)ios7Fix{
    if(OSVersionIsAtLeastiOS7()){
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout=UIRectEdgeNone;
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(contentSizeDidChangeNotification:) name:UIContentSizeCategoryDidChangeNotification
         object:nil];
    }
}

-(void)contentSizeDidChangeNotification:(NSNotification*)notification{
    [self contentSizeDidChange:notification.userInfo[UIContentSizeCategoryNewValueKey]];
}

-(void)contentSizeDidChange:(NSString *)size{
    //Implement in subclass
}

-(CGSize)ScreenSize{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    return screenSize;
}
-(CGSize)sizeInPoint{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return screenBounds.size;
}
-(BOOL)Retina{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return screenScale > 1.0;
}
-(void)retinaFit{
    CGRect frame = self.view.frame;
    frame.size.height = [self sizeInPoint].height;
    self.view.frame = frame;
}
-(void)fitHeight:(UIView*)view{
    CGRect frame = view.frame;
    frame.size.height = [self sizeInPoint].height;
    view.frame = frame;
}
/*navigation controller setting*/
-(void)setNavColor{
    
#ifdef kNavBgColor
    if(OSVersionIsAtLeastiOS7()){
        [self.navigationController.navigationBar setBarTintColor:kNavBgColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:kNavBgColor];
    }
#endif
    
}
-(void)setNavLeftButton:(NSString*)title action:(SEL)action
{
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    self.navigationItem.leftBarButtonItem = btn;
}
-(void)setNavLeftImage:(NSString*)name action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    if (action) {
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn addTarget:self action:@selector(backToPrevView) forControlEvents:UIControlEventTouchUpInside];
    }
    //[closeBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 9, 5, 9)];
    btn.frame = CGRectMake(0, 0, 42, 29);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (void)backToPrevView
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setNavRightButton:(NSString*)title action:(SEL)action
{
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:action];
    self.navigationItem.rightBarButtonItem = btn;
}
-(void)setNavRightImage:(NSString*)name action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    if (action) {
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setContentEdgeInsets:UIEdgeInsetsMake(5, 9, 5, 9)];
    btn.frame = CGRectMake(0, 0, 42, 29);
    btn.tag = 1000;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 29)];
    [view addSubview:btn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}
-(UIButton*)setNavShareImage:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    if (action) {
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setContentEdgeInsets:UIEdgeInsetsMake(5, 9, 5, 9)];
    btn.frame = CGRectMake(0, 0, 42, 33);
    btn.tag = 1000;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 33)];
    [view addSubview:btn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    return btn;
}
-(void)showLoadingCircle:(UIColor*)color{
    UIView* view = self.navigationItem.rightBarButtonItem.customView;
    HYCircleLoadingView* loadingView = [[HYCircleLoadingView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    loadingView.lineColor = color;
    loadingView.tag = 1001;
    [view viewWithTag:1000].hidden = YES;
    [view addSubview:loadingView];
    [loadingView startAnimation];
}
-(void)hideLoadingCircle{
    UIView* view = self.navigationItem.rightBarButtonItem.customView;
    HYCircleLoadingView* loadingView = (HYCircleLoadingView*)[view viewWithTag:1001];
    [loadingView stopAnimation];
    [loadingView removeFromSuperview];
}
-(void)showLoadingCircleCenter:(UIColor*)color{
    UIView* view = self.view;
    CGRect frame = self.view.bounds;
    float x = (frame.size.width - 35)/2;
    float y = (frame.size.height - 35)/2;
    HYCircleLoadingView* loadingView = [[HYCircleLoadingView alloc]initWithFrame:CGRectMake(x, y, 35, 35)];
    loadingView.lineColor = color;
    loadingView.tag = 1011;
    [view addSubview:loadingView];
    [loadingView startAnimation];
}
-(void)hideLoadingCircleCenter{
    UIView* view = self.view;
    HYCircleLoadingView* loadingView = (HYCircleLoadingView*)[view viewWithTag:1011];
    [loadingView stopAnimation];
    [loadingView removeFromSuperview];
}
-(void)replaceWithLoadingCircle:(UIView*)view color:(UIColor*)color{
    UIView* cview = self.view;
    CGRect frame = view.frame;
    float x = frame.origin.x + (frame.size.width - 35)/2;
    float y = frame.origin.y + (frame.size.height - 35)/2;
    HYCircleLoadingView* loadingView = [[HYCircleLoadingView alloc]initWithFrame:CGRectMake(x, y, 35, 35)];
    loadingView.lineColor = color;
    loadingView.tag = 1011;
    [cview addSubview:loadingView];
    view.hidden = YES;
    [loadingView startAnimation];
}
-(void)reshowReplacedView:(UIView*)view{
    view.hidden = NO;
    UIView* cview = self.view;
    HYCircleLoadingView* loadingView = (HYCircleLoadingView*)[cview viewWithTag:1011];
    [loadingView stopAnimation];
    [loadingView removeFromSuperview];
}
- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)popupView:(UIViewController*)view{
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:view];
        [self presentViewController:navController animated:YES completion:^{
        }];
    });
}

-(void)doActionOnTime:(NSString *)key duration:(int)duration action:(void (^)(void))action{
    NSNumber* ts = [[NSUserDefaults standardUserDefaults] objectForKey:key];
#ifdef DEBUG
    ts = @(0);
#endif
    
    double now = [[NSDate date] timeIntervalSince1970];
    if (!ts || ts.doubleValue < now) {
        now = now + duration;
        [[NSUserDefaults standardUserDefaults] setObject:@(now) forKey:key];
        action();
    }
}
@end
