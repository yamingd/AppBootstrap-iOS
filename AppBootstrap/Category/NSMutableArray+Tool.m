//
//  NSMutableArray+Tool.m
//  k12
//
//  Created by Joey on 8/4/15.
//  Copyright (c) 2015 jiaxiaobang.com. All rights reserved.
//

#import "NSMutableArray+Tool.h"

@implementation NSMutableArray(Tool)

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, objects.count)];
    [self insertObjects:objects atIndexes:indexSet];
}

@end
