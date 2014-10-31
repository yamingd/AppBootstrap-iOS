//
//  APIStub.m
//  EnglishCafe
//
//  Created by yaming_deng on 24/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "APIStub.h"
#import "OHHTTPStubs.h"

@implementation APIStub

+(instancetype)start{
    SHARED_INSTANCE_BLOCK(^(){
        APIStub* stub = [[APIStub alloc] init];
        return stub;
    });
}

-(id)init{
    
    NSString* appMode = [AppSession current].appMode;
    LOG(@"appMode: %@", appMode);
    if ([appMode isEqualToString:kAppModeServer]) {
        return self;
    }
    
    NSMutableDictionary* config = [AppSession current].config;
    NSString* host = [config objectForKey:@"ApiBaseUrl"];
    host = [host stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        //LOG(@"host: %@", request.URL.host);
        return [request.URL.host isEqualToString:host];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString* path = [request.URL.path substringFromIndex:1];
        NSString* path2 = [path stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        LOG(@"json path: %@", path2);
        NSString* filePath = [[NSBundle mainBundle] pathForResource:path2 ofType:@"json" inDirectory:@"Data"];
        if (filePath == nil) {
            NSRange end = [path2 rangeOfString:@"-" options:NSBackwardsSearch];
            path2 = [path2 substringToIndex:end.location];
            LOG(@"json path: %@", path2);
            filePath = [[NSBundle mainBundle] pathForResource:path2 ofType:@"json" inDirectory:@"Data"];
        }
        LOG(@"json filePath: %@", filePath);
        NSString *utf8JSON = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSData  *jsonData  = [utf8JSON  dataUsingEncoding: NSUTF8StringEncoding];
        // Stub it with our "wsresponse.json" stub file
        OHHTTPStubsResponse* resp = [OHHTTPStubsResponse responseWithData:jsonData
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        resp = [resp requestTime:.2 responseTime:2.0];
        return resp;
        
    }];
    
    return self;
}

@end
