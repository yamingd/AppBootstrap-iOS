//
//  PBObjcWrapper.h
//  AppBootstrap
//
//  Created by Yaming on 10/31/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import <google/protobuf/message.h>
#endif

@protocol PBObjcWrapper <NSObject>

-(instancetype) initWithProtocolData:(NSData*) data;

#ifdef __cplusplus
-(instancetype) initWithProtocolObj:(google::protobuf::Message *)pbobj;
#endif

-(NSData*) getProtocolData;
-(NSMutableDictionary*) asDict;

@end
