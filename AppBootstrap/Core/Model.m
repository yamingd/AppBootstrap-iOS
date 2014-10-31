//
//  BaseModel.m
//  EnglishCafe
//
//  Created by yaming_deng on 1/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "Model.h"

@implementation Model

+(id)createWith:(Class)clazz data:(NSDictionary *)data{
    return [[clazz alloc] initWith:data];
}
+(NSArray*) asArrays:(NSArray *)items model:(Class)mclass{
    if (!items) {
        return nil;
    }
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSDictionary* item in items) {
        [result addObject:[Model createWith:mclass data:item]];
    }
    return result;
}
-(id)initWith:(NSDictionary *)data{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:data];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未定义的key:%@",key);
}
- (NSArray*)asList:(NSString*)key{
    id items = [self valueForKey:key];
    if (!items) {
        return nil;
    }
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (id item in items) {
        if ([item isKindOfClass:[self class]]) {
            return items;
        }
        [result addObject:[Model createWith:[self class] data:item]];
    }
    [self setValue:result forKey:key];
    return result;
}

@end
