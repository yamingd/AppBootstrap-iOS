//
//  APIClient.h
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "AFNetworking.h"
#import "TSAppResponse.hh"
#import "AFProtobufResponseSerializer.h"

@interface APIClient : AFHTTPSessionManager

+ (instancetype)shared;

@property(strong, nonatomic)NSString* baseUrlString;

- (instancetype)initWithApiBase:(NSString*)url;

- (void) setHeaderValue:(AFHTTPRequestSerializer*)req;

//用户变更时需要重置Header Value
-(void) resetHeaderValue;

-(void) getPath:(NSString *)urlString
                params:(NSDictionary *)params
            block:(void (^)(id response, NSError* error))block;


-(void) postPath:(NSString *)urlString
          params:(NSDictionary *)params
          formBody:(void (^)(id <AFMultipartFormData> formData))formBody
           block:(void (^)(id response, NSError* error))block;


-(void) deletePath:(NSString *)urlString
           params:(NSDictionary *)params
          block:(void (^)(id response, NSError* error))block;


-(void) putPath:(NSString *)urlString
           params:(NSDictionary *)params
            block:(void (^)(id response, NSError* error))block;

-(void) patchPath:(NSString *)urlString
         params:(NSDictionary *)params
          block:(void (^)(id response, NSError* error))block;

-(void)test;

-(NSURLSessionDownloadTask*)download:(NSString*)urlString
                          filePath:(NSString *)filePath
                           process:(void (^)(long long readBytes, long long totalBytes))process
                          complete:(void (^)(BOOL successed, NSURL *filePath))complete;

-(NSURLSessionDownloadTask*)downloadNSData:(NSString*)urlString
                           process:(void (^)(long long readBytes, long long totalBytes))process
                          complete:(void (^)(BOOL successed, NSData* data))complete;

-(NSString *)formatUrl:(NSString *)url args:(NSDictionary *)args;


@end
