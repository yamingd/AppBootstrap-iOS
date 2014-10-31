//
//  OfflieTaskPool.m
//  EnglishCafe
//
//  Created by yaming_deng on 3/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "TaskExecutor.h"

@implementation TaskExecutor

+(instancetype)instance{
    static TaskExecutor *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TaskExecutor alloc] init];
        [[EDQueue sharedInstance] setDelegate:_sharedClient];
    });
    return _sharedClient;
}

-(void)start{
    LOG(@"Start OfflieTaskPool TaskExecutor.");
    [[EDQueue sharedInstance] start];
}
-(void)stop{
    LOG(@"Stop OfflieTaskPool TaskExecutor.");
    [[EDQueue sharedInstance] stop];
}
+(void)put:(NSString *)name data:(NSDictionary *)data{
    [[EDQueue sharedInstance] enqueueWithData:data forTask:name];
}
-(void)queue:(EDQueue *)queue processJob:(NSDictionary *)job completion:(void (^)(EDQueueResult))block{
    sleep(1);  // This won't block the main thread. Yay!
    // Wrap your job processing in a try-catch. Always use protection!
    @try {
        NSString *name = [job objectForKey:@"task"];
        NSDictionary *data = [job objectForKey:@"data"];
        if ([TASK_NAME_API isEqualToString:name]) {
            NSString* actionUrl = [data objectForKey:@"actionUrl"];
            NSDictionary* params = [data objectForKey:@"params"];
            //TODO: check network status
            [[APIClient sharedClient] postForm:actionUrl params:params block:^(TSAppResponse *response, NSError *error) {
                if (error) {
                    LOG(@"Exception: %@", error);
                    block(EDQueueResultFail);
                }else{
                    block(EDQueueResultSuccess);
                }
            }];
        }
    }
    @catch (NSException *exception) {
        LOG(@"Exception: %@", exception);
        block(EDQueueResultFail);
    }
}

@end
