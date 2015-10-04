
#import "NSMutableArray+Tool.h"

@implementation NSMutableArray(Tool)

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, objects.count)];
    [self insertObjects:objects atIndexes:indexSet];
}

@end
