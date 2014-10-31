//
//  APIResponse.m
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "AppResponse.h"

@implementation AppResponse

@synthesize msg, code, sessionid, total, data, v;
@synthesize networkError;

-(id)initWith:(NSDictionary *)dict{
    self = [super init];
    if (self && dict) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
