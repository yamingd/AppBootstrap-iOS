//
//  UIView+HUD.h
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView(HUD)

- (void)showHUD:(NSString *)text;
- (void)hideHUD;

- (void)showToast:(NSString *)text;
- (void)showToast:(NSString *)text afterDelay:(NSTimeInterval)delay;

@end
