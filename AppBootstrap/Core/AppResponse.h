//
//  APIResponse.h
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppResponse : NSObject

@property(nonatomic, strong) NSString* msg;
@property(nonatomic, strong) NSNumber* code;
@property(nonatomic, strong) NSString* v;
@property(nonatomic, strong) NSString* sessionid;
@property(nonatomic, strong) NSNumber* total;
@property(nonatomic, strong) NSData* data;

@property BOOL networkError;

- (id)initWith:(NSDictionary *)data;

@end
