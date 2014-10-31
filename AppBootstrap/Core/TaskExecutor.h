//
//  OfflieTaskPool.h
//  EnglishCafe
//
//  Created by yaming_deng on 3/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDQueue.h"

#define TASK_NAME_API @"api"

@interface TaskExecutor : NSObject<EDQueueDelegate>

+(instancetype)instance;

-(void)start;
-(void)stop;

+(void)put:(NSString *)name data:(NSDictionary *)data;

@end
