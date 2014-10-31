

#import <UIKit/UIKit.h>
#import "UIViewController+Ext.h"

@interface BaseViewController : UIViewController

-(void)logClickEvent:(NSString*)name data:(NSDictionary*)data;

@end
