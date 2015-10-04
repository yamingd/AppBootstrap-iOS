//
//  TSAppResponse.hh
//  k12
//
//  Created by Yaming on 10/25/14.
//  Copyright (c) 2014 jiaxiaobang.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBObjcWrapper.hh"

@interface TSAppResponse : NSObject<PBObjcWrapper>

@property (nonatomic,strong) NSString* msg;
@property (nonatomic,strong) NSString* sessionId;
@property int version;
@property int code;
@property int total;
@property (readonly,nonatomic,strong) NSArray* data;
@property (readonly,nonatomic,strong) NSArray* errors;
@property (readonly,nonatomic,strong) NSData *protocolData;

-(NSMutableArray*) parseData:(Class)type;

@end
