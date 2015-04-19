//
//  APIClient.m
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//
#import "APIClient.h"
#import "AppSession.h"

@implementation APIClient

+ (instancetype)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString* apibase = [[AppSession current].config objectForKey:@"ApiBaseUrl"];
        //NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //configuration.HTTPAdditionalHeaders = params;
        //_sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:apibase] sessionConfiguration:configuration];
        //_sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:apibase]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        [_sharedClient setHeaderValue:_sharedClient.requestSerializer];
        
    });
    return _sharedClient;
}
- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    self.format = [[AppSession current].config objectForKey:@"ApiFormat"];
    if (!self.format) {
        self.format = X_JSON_V;
    }
    if ([self.format isEqualToString:X_PROTOBUF_V]) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self.requestSerializer setValue:X_PROTOBUF forHTTPHeaderField:@"Accept"];
    }
    return self;
}
-(void) setHeaderValue:(AFHTTPRequestSerializer*)req{
    NSDictionary *params = [[AppSession current] header];
    for (NSString* key in params) {
        NSString *sKey = [key description];
        NSString *sVal = [[params objectForKey:key] description];
        //LOG(@"%@=%@", sKey, sVal);
        [req setValue:sVal forHTTPHeaderField:sKey];
    }
}
-(void)resetHeaderValue{
    [self setHeaderValue:self.requestSerializer];
}
-(id)parseError:(NSError *)error{
    LOG(@"Error:%@", error);
    if ([self.format isEqualToString:X_PROTOBUF_V]) {
        TSAppResponse* resp = [[TSAppResponse alloc] init];
        resp.code = error.code;
        if ([error code] == -1001 || [error code] == -1009) {
            resp.msg = @"Network is unstable. connection timeout";
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetworkError object:nil userInfo:nil];
        }else{
            resp.msg = error.localizedDescription;
        }
        return resp;
    }else{
        AppResponse* resp = [[AppResponse alloc] init];
        resp.code = [NSNumber numberWithLong:error.code];
        if ([error code] == -1001 || [error code] == -1009) {
            resp.msg = @"Network is unstable. connection timeout";
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetworkError object:nil userInfo:nil];
        }else{
            resp.msg = error.localizedDescription;
        }
        return resp;
    }
    
}
-(id)parseData:(id)data{
    if ([self.format isEqualToString:X_PROTOBUF_V]) {
        TSAppResponse* resp = [[TSAppResponse alloc] initWithProtocolData:data];
        return resp;
    }else{
        return [[AppResponse alloc] initWith:data];
    }
}

-(void) query:(NSString *)urlString
       params:(NSDictionary *)params
        block:(void (^)(id response, NSError* error))block{
#ifdef DEBUG
    LOG(@"query: %@", urlString);
#endif
    [self GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id data) {
        NSError* error = nil;
        if ([self.format isEqualToString:X_PROTOBUF_V]) {
            TSAppResponse* resp = [self parseData:data];
            if (resp.code > 200) {
                error = [NSError errorWithDomain:resp.msg code:resp.code userInfo:@{@"ex": resp.errors}];
                block(resp, error);
                if (resp.code == 500) {
                    [self showNetworkErrorToast:@"服务器走神了～"];
                }
                
            }else{
                block(resp, nil);
            }
        }else{
            AppResponse* resp = [self parseData:data];
            if (resp.code.intValue > 200) {
                error = [NSError errorWithDomain:resp.msg code:resp.code.intValue userInfo:nil];
                block(resp, error);
                if (resp.code.intValue == 500) {
                    [self showNetworkErrorToast:@"服务器走神了～"];
                }
            }else{
                block(resp, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"Error:%@", error);
        id resp = [self parseError:error];
        if (block) {
            block(resp, error);
        }
        
        if (error.code == -1001) {
            [self showNetworkErrorToast:@"请求超时～"];
        } else {
            [self showNetworkErrorToast:@"服务器走神了～"];
        }
        
    }];
    
    /*
    [self GET:urlString parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON) {
        APIResponse* resp = [[APIResponse alloc] initWith:JSON];
        resp.networkError = NO;
        if (block) {
            block(resp, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        LOG(@"Error:%@", error);
        APIResponse* resp = [self parseError:error];
        if (block) {
            block(resp, error);
        }
    }];
     */
}


-(void) postForm:(NSString *)urlString
          params:(NSDictionary *)params
           block:(void (^)(id response, NSError* error))block{
#ifdef DEBUG
    LOG(@"postForm: %@", urlString);
#endif
    [self POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id data) {
        NSError* error = nil;
        if ([self.format isEqualToString:X_PROTOBUF_V]) {
            TSAppResponse* resp = [self parseData:data];
            if (resp.code > 200) {
                error = [NSError errorWithDomain:resp.msg code:resp.code userInfo:@{@"ex": resp.errors}];
                block(resp, error);
                if (resp.code == 500) {
                    [self showNetworkErrorToast:@"服务器走神了～"];
                }
            }else{
                block(resp, nil);
            }
        }else{
            AppResponse* resp = [self parseData:data];
            if (resp.code.intValue > 200) {
                error = [NSError errorWithDomain:resp.msg code:resp.code.intValue userInfo:nil];
                block(resp, error);
                if (resp.code.intValue == 500) {
                    [self showNetworkErrorToast:@"服务器走神了～"];
                }
            }else{
                block(resp, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id resp = [self parseError:error];
        if (block) {
            block(resp, error);
        }
        
        [self showNetworkErrorToast:@"网络走神了～"];
    }];
    
    /*
    [self POST:urlString parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON) {
        APIResponse* resp = [[APIResponse alloc] initWith:JSON];
        if (block) {
            block(resp, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        APIResponse* resp = [self parseError:error];
        if (block) {
            block(resp, error);
        }
    }];*/
}


-(void) postXForm:(NSString *)urlString
           params:(NSDictionary *)params
         formBody:(void (^)(id <AFMultipartFormData> formData))formBody
            block:(void (^)(id response, NSError* error))block{
#ifdef DEBUG
    LOG(@"postXForm: %@", urlString);
#endif
    [self POST:urlString parameters:params constructingBodyWithBlock:formBody success:^(AFHTTPRequestOperation *operation, id data) {
        NSError* error = nil;
        if ([self.format isEqualToString:X_PROTOBUF_V]) {
            TSAppResponse* resp = [self parseData:data];
            if (resp.code > 200) {
                error = [NSError errorWithDomain:resp.msg code:resp.code userInfo:@{@"ex": resp.errors}];
                block(resp, error);
                if (resp.code == 500) {
                    [self showNetworkErrorToast:@"服务器走神了～"];
                }
            }else{
                block(resp, nil);
            }
        }else{
            AppResponse* resp = [self parseData:data];
            if (resp.code.intValue > 200) {
                error = [NSError errorWithDomain:resp.msg code:resp.code.intValue userInfo:nil];
                block(resp, error);
                if (resp.code.intValue == 500) {
                    [self showNetworkErrorToast:@"服务器走神了～"];
                }
            }else{
                block(resp, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id resp = [self parseError:error];
        if (block) {
            block(resp, error);
        }
        
        [self showNetworkErrorToast:@"网络走神了～"];
    }];
    
    /*
    [self POST:urlString parameters:params constructingBodyWithBlock:formBody success:^(NSURLSessionDataTask *task, id JSON) {
        APIResponse* resp = [[APIResponse alloc] initWith:JSON];
        if (block) {
            block(resp, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        APIResponse* resp = [self parseError:error];
        if (block) {
            block(resp, error);
        }
    }];*/
}

- (void)showNetworkErrorToast:(NSString *)text
{
#if AppConfig_showNetworkErrorToast
    [[[UIApplication sharedApplication] keyWindow] showToast:text];
#endif
}

-(void)test{
    
}

-(AFHTTPRequestOperation*)download:(NSString*)urlString
                          filePath:(NSString *)filePath
                           process:(void (^)(long long readBytes, long long totalBytes))process
                          complete:(void (^)(BOOL successed, NSDictionary *response))complete{
#ifdef DEBUG
    LOG(@"download: %@", urlString);
#endif
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [self setHeaderValue:serializer];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer.acceptableContentTypes = nil;
    
    //LOG(@"save to filePath: %@", filePath);
    
    NSString *tmpPath = [filePath stringByAppendingString:@".tmp"];
    operation.outputStream=[[NSOutputStream alloc] initToFileAtPath:tmpPath append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *moveError = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:filePath error:&moveError];
        
        if (complete && !moveError) {
            complete(true,responseObject);
        }else{
            complete?complete(false,responseObject):nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"get error :  %@",error);
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
        if (complete) {
            complete(false,nil);
        }
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //LOG(@"download process: %.2lld%% (%ld/%ld)",100*totalBytesRead/totalBytesExpectedToRead,(long)totalBytesRead,(long)totalBytesExpectedToRead);
        if (process) {
            process(totalBytesRead, totalBytesExpectedToRead);
        }
    }];
    
    [operation start];
    
    return operation;
    
}

-(AFHTTPRequestOperation*)downloadNSData:(NSString*)urlString
                                 process:(void (^)(long long readBytes, long long totalBytes))process
                                complete:(void (^)(BOOL successed, NSData* data))complete{
    

#ifdef DEBUG
    LOG(@"download: %@", urlString);
#endif
    
    if (!complete) {
        return nil;
    }
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [self setHeaderValue:serializer];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer.acceptableContentTypes = nil;
    
    operation.outputStream = [[NSOutputStream alloc] initToMemory];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        complete(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"get error :  %@",error);
        complete(NO, nil);
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //LOG(@"download process: %.2lld%% (%ld/%ld)",100*totalBytesRead/totalBytesExpectedToRead,(long)totalBytesRead,(long)totalBytesExpectedToRead);
        if (process) {
            process(totalBytesRead, totalBytesExpectedToRead);
        }
    }];
    
    [operation start];
    
    return operation;
    
}

-(AFHTTPRequestOperation*)download3rd:(NSString*)urlString
                          filePath:(NSString *)filePath
                           process:(void (^)(long long readBytes, long long totalBytes))process
                          complete:(void (^)(BOOL successed, NSDictionary *response))complete{
#ifdef DEBUG
    LOG(@"download3rd: %@", urlString);
#endif
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer.acceptableContentTypes = nil;
    
    //LOG(@"save to filePath: %@", filePath);
    
    NSString *tmpPath = [filePath stringByAppendingString:@".tmp"];
    operation.outputStream=[[NSOutputStream alloc] initToFileAtPath:tmpPath append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG(@"response: %@", responseObject);
        NSError *moveError = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:filePath error:&moveError];
        
        if (complete && !moveError) {
            complete(true,responseObject);
        }else{
            complete?complete(false,responseObject):nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"get error :  %@",error);
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
        if (complete) {
            complete(false,nil);
        }
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //LOG(@"download process: %.2lld%% (%ld/%ld)",100*totalBytesRead/totalBytesExpectedToRead,(long)totalBytesRead,(long)totalBytesExpectedToRead);
        if (process) {
            process(totalBytesRead, totalBytesExpectedToRead);
        }
    }];
    
    [operation start];
    
    return operation;
    
}

+(NSString *)formatUrl:(NSString *)url args:(NSDictionary *)args{
    if (url == nil || url.length == 0) {
        return nil;
    }
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        return url;
    }
    NSString* apibase = [[AppSession current].config objectForKey:@"ApiBaseUrl"];
    NSDictionary *params = [[AppSession current] apidict];
    if (args != nil) {
        for (NSString *key in args) {
            [params setValue:[args objectForKey:key] forKey:key];
        }
    }
    url = [Utility addQueryStringToUrl:url params:params];
    url = [NSString stringWithFormat:@"%@%@", apibase, url];
    return url;
}

@end
