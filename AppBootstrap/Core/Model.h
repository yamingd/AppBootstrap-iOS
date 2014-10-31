//
//  BaseModel.h
//  EnglishCafe
//
//  Created by Simsion on 1/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+(id)createWith:(Class)clazz data:(NSDictionary*)data;
+(NSArray*) asArrays:(NSArray*)items model:(Class)mclass;

- (id)initWith:(NSDictionary *)data;

- (NSArray*)asList:(NSString*)key;

@end
