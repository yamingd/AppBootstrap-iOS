//
//  XibFactory.h
//

#import <Foundation/Foundation.h>

@interface XibFactory : NSObject

// return the first instance object in nib list
+ (id)productWithNibClass:(Class)aClass;
+ (id)productWithNibName:(NSString *)nibName;
+ (id)productWithNibName:(NSString *)nibName objectIndex:(NSInteger)index;
+ (id)productWithNibName:(NSString *)nibName isKindOfClass:(Class)c;

@end
