//
//  Audio.h
//  AppBootstrap
//
//  Created by Yaming on 13-6-13.
//  Copyright (c) 2013年 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioStreamer.h"

#define _CACHE_OBJECT_VIDEO_  @"video"

@interface Audio : NSObject <DOUAudioFile>

@property (retain, nonatomic) NSString *linkUrl;
@property (retain, nonatomic) NSData *data;
@property (retain, nonatomic) NSNumber *audioId;
@property (retain, nonatomic) NSString *title;

+ (NSString *)trimNameWithUrl:(NSString *)url;

- (id)initWithCacheObject:(NSData *)cacheObject;

@end
