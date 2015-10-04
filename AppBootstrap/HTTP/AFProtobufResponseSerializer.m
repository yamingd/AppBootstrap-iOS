//
//  AFProtobufResponseSerializer.m
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 whosbean.com. All rights reserved.
//

#import "AFProtobufResponseSerializer.h"
#import "TSAppResponse.hh"

@implementation AFProtobufResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:X_PROTOBUF, nil];
    
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    [self validateResponse:(NSHTTPURLResponse *)response data:data error:error];
    
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        return nil;
    }
    
    TSAppResponse* resp = [[TSAppResponse alloc] initWithProtocolData:data];
    return resp;
    
    return resp;
}

@end
