//
//  XibFactory.m
//

#import "XibFactory.h"

@implementation XibFactory

+ (id)productWithNibName:(NSString *)nibName
{
    return [XibFactory productWithNibName:nibName objectIndex:0];
}

+ (id)productWithNibClass:(Class)aClass
{
    return [[self class] productWithNibName:NSStringFromClass(aClass)];
}

+ (id)productWithNibName:(NSString *)nibName objectIndex:(NSInteger)index
{
    NSArray *xibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    if (xibObjects.count > 0 && index < xibObjects.count) {
        return [xibObjects objectAtIndex:index];
    }
    
    return nil;
}

+ (id)productWithNibName:(NSString *)nibName isKindOfClass:(Class)c
{
    NSArray *xibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    for (id obj in xibObjects) {
        if ([obj isKindOfClass:c]) {
            return obj;
        }
    }
    
    return nil;
}

+ (id)productWithStoryboardIdentifier:(NSString *)identifier
{
    return [self productWithStoryboardName:kMainStoryboardName identifier:identifier];
}

+ (id)productWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier;
{
    return [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

@end
