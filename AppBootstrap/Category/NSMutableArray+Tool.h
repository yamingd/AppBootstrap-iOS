//
//  NSMutableArray+Tool.h
//  k12
//
//  Created by Joey on 8/4/15.
//  Copyright (c) 2015 jiaxiaobang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(Tool)

/**
 *  insert mutable objects at index, for instance index is 0
 */
- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

@end
