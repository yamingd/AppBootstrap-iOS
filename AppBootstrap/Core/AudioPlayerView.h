//
//  AudioPlayerView.h
//  AppBootstrap
//
//  Created by Yaming on 10/29/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Audio.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"

@interface AudioPlayerView : NSObject

@property (retain, nonatomic) Audio *audio;
@property (retain, nonatomic) DOUAudioStreamer *streamer;

-(void)showProgress:(NSTimeInterval)current duration:(NSTimeInterval)duration;
-(void)freeStreamer;

-(void)start;
-(void)stop;
-(void)pause;
-(void)finish;
-(void)foundError;
-(void)playing;

@end
