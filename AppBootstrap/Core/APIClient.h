//
//  APIClient.h
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#define X_PROTOBUF @"application/x-protobuf"
#define X_PROTOBUF_V @"protobuf"

#define X_JSON @"application/json"
#define X_JSON_V @"json"

#import "AFNetworking.h"
#import "AppResponse.h"
#import "TSAppResponse.hh"

@interface APIClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@property(nonatomic,strong)NSString* format;

-(void) setHeaderValue:(AFHTTPRequestSerializer*)req;

//用户变更时需要重置Header Value
-(void) resetHeaderValue;

-(void) query:(NSString *)urlString
                params:(NSDictionary *)params
            block:(void (^)(id response, NSError* error))block;


-(void) postForm:(NSString *)urlString
          params:(NSDictionary *)params
           block:(void (^)(id response, NSError* error))block;


-(void) postXForm:(NSString *)urlString
           params:(NSDictionary *)params
         formBody:(void (^)(id <AFMultipartFormData> formData))formBody
          block:(void (^)(id response, NSError* error))block;

-(void)test;

-(AFHTTPRequestOperation*)download:(NSString*)urlString
                          filePath:(NSString *)filePath
                           process:(void (^)(long long readBytes, long long totalBytes))process
                          complete:(void (^)(BOOL successed, NSDictionary *response))complete;

-(AFHTTPRequestOperation*)download3rd:(NSString*)urlString
                          filePath:(NSString *)filePath
                           process:(void (^)(long long readBytes, long long totalBytes))process
                          complete:(void (^)(BOOL successed, NSDictionary *response))complete;

-(AFHTTPRequestOperation*)downloadNSData:(NSString*)urlString
                           process:(void (^)(long long readBytes, long long totalBytes))process
                          complete:(void (^)(BOOL successed, NSData* data))complete;

+(NSString *)formatUrl:(NSString *)url args:(NSDictionary *)args;

-(id)parseError:(NSError*)error;
-(id)parseData:(id)data;

@end
