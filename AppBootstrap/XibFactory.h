//
//  XibFactory.h
//

#import <Foundation/Foundation.h>

#define kMainStoryboardName @"Main"

@interface XibFactory : NSObject

// return the first instance object in nib list
+ (id)productWithNibClass:(Class)aClass;
+ (id)productWithNibName:(NSString *)nibName;
+ (id)productWithNibName:(NSString *)nibName objectIndex:(NSInteger)index;
+ (id)productWithNibName:(NSString *)nibName isKindOfClass:(Class)c;

// storyboard production
+ (id)productWithStoryboardName:(NSString *)storyboardName class:(Class)c;
+ (id)productWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier;
+ (id)productWithStoryboardIdentifier:(NSString *)identifier;   //storyboardName is main

@end
