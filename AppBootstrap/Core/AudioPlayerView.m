//
//  AudioPlayerView.m
//  AppBootstrap
//
//  Created by Yaming on 10/29/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AudioPlayerView.h"

#define kTestLinkUrl @"http://www.elllo.org/Audio/A1201/1201-Julia-Protest.mp3"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;

@implementation AudioPlayerView{
    NSTimer *playAudioTimer;
}

- (NSString *)formatTime:(NSTimeInterval)time{
    long ts = (long)time;
    long hours = ts / 3600;
    long minutes = ts - hours * 3600;
    minutes = minutes / 60;
    long seconds = ts - hours * 3600 - minutes * 60;
    //LOG(@"%f,%ld,%ld,%ld", time, hours, minutes, seconds);
    NSString *tips = [NSString stringWithFormat:@"%02ld:%02ld",minutes, seconds];
    return tips;
}

- (void)_timerAction:(id)timer
{
    [self showProgress:[self.streamer currentTime] duration:[self.streamer duration]];
}

- (void)updatePlayerStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            [self playing];
            break;
            
        case DOUAudioStreamerPaused:
            LOG(@"Paused ...");
            [self pause];
            break;
            
        case DOUAudioStreamerFinished:
            LOG(@"Finished ...");
            [self finish];
            break;
            
        case DOUAudioStreamerBuffering:
            //LOG(@"buffering");
            break;
            
        case DOUAudioStreamerError:
            LOG(@"Audio play occur error!~");
            [self foundError];
            break;
        default:
            LOG(@"default value");
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updatePlayerStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)freeStreamer
{
    //TODO: 退出
    LOG(@"free streamer...");
    if (self.streamer != nil) {
        [self.streamer pause];
        [self.streamer removeObserver:self forKeyPath:@"status"];
        [self.streamer removeObserver:self forKeyPath:@"duration"];
        self.streamer = nil;
    }
    if (playAudioTimer) {
        [playAudioTimer invalidate];
        playAudioTimer = nil;
    }
}
- (void)dealloc{
    [self freeStreamer];
}
- (void)resetStreamer
{
    [self freeStreamer];
    _streamer = [DOUAudioStreamer streamerWithAudioFile:_audio];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    playAudioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
}

- (void)stop{
    [self freeStreamer];
}
- (void)start{
    if (self.streamer == nil) {
        LOG("play start");
        [self resetStreamer];
        [self.streamer play];
    }
    else if ([self.streamer status] == DOUAudioStreamerFinished) {
        [self resetStreamer];
        [self.streamer play];
    } else if ([self.streamer status] == DOUAudioStreamerPaused) {
        [self.streamer play];
    }
    else {
        [self.streamer pause];
    }
}
- (void)pause{
    
}
- (void)finish{
    
}
- (void)foundError{
    
}
- (void)playing{
    
}
-(void)showProgress:(NSTimeInterval)current duration:(NSTimeInterval)duration{
    
}
@end
