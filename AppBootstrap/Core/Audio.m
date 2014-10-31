//
//  Audio.m
//  els.cafe
//
//  Created by Yaming on 13-6-13.
//  Copyright (c) 2013年 whosbean. All rights reserved.
//

#import "Audio.h"

@implementation Audio
@synthesize data;
@synthesize audioId;
@synthesize title;
@synthesize linkUrl;

- (BOOL)isLocal
{
    return (self.data != nil);
}

- (NSData *)localData
{
    return self.data;
}

- (NSURL *)audioFileURL
{
    return [NSURL URLWithString:self.linkUrl];
}

+ (NSString *)trimNameWithUrl:(NSString *)url
{
    NSArray *array = [url componentsSeparatedByString:@"/"];
    NSString *string = [array lastObject];
    NSRange range = [string rangeOfString:@"."];
    string = [string substringToIndex:range.location];
    return string;
}

- (id)initWithCacheObject:(NSData *)cacheObject{
    self.data = cacheObject;
    return self;
}

@end
