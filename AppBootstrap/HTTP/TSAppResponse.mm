//
//  TSAppResponse.m
//  k12
//
//  Created by Yaming on 10/25/14.
//  Copyright (c) 2014 jiaxiaobang.com. All rights reserved.
//

#import "TSAppResponse.hh"
#import "PAppResponse.pb.hh"
#import "PBObjc.hh"

@interface TSAppResponse ()

@property (nonatomic,strong) NSArray* data;
@property (nonatomic,strong) NSArray* errors;
@property (nonatomic,strong) NSData *protocolData;

@end


@implementation TSAppResponse

-(instancetype) initWithProtocolData:(NSData*) data {
    return [self initWithData:data];
}
-(instancetype) initWithProtocolObj:(google::protobuf::Message*)pbmsg{
    PAppResponse* pbobj = (PAppResponse*)pbmsg;
    const std::string msg = pbobj->msg();
    const std::string sessionId = pbobj->sessionid();
    const uint32_t version = pbobj->version();
    const uint32_t code = pbobj->code();
    const uint32_t total = pbobj->total();
    
    NSMutableArray *errors= [[NSMutableArray alloc] init];
    for (int i=0; i<pbobj->errors_size(); i++) {
        const std::string e = pbobj->errors(i);
        [errors addObject:[PBObjc cppStringToObjc:e]];
    }
    
    NSMutableArray *dslist= [[NSMutableArray alloc] init];
    for (int i=0; i<pbobj->data_size(); i++) {
        const std::string ds = pbobj->data(i);
        [dslist addObject:[PBObjc cppStringToObjcData:ds]];
    }
    
    // c++->objective C
    self.msg = [PBObjc cppStringToObjc:msg];
    self.sessionId = [PBObjc cppStringToObjc:sessionId];
    self.version = version;
    self.code = code;
    self.total = total;
    self.errors = errors;
    self.data = dslist;
    return self;
}

-(NSData*) getProtocolData {
    return self.protocolData;
}

-(NSMutableDictionary*)asDict{
    return nil;
}

-(instancetype) initWithData:(NSData*) data {
    
    if(self = [super init]) {
        // c++
        PAppResponse* resp = [self deserialize:data];
        self = [self initWithProtocolObj:resp];
        self.protocolData = data;
    }
    return self;
}

-(NSMutableArray*) parseData:(Class)type{
    NSMutableArray *dslist= [[NSMutableArray alloc] init];
    for (NSData* item in self.data) {
        id obj = [[type alloc] initWithProtocolData:item];
        [dslist addObject:obj];
    }
    self.data = dslist;
    return dslist;
}


#pragma mark private

-(const std::string) serializedProtocolBufferAsString {
    PAppResponse *message = new PAppResponse;
    // objective c->c++
    const std::string msg = [PBObjc objcStringToCpp:self.msg];
    const std::string sessionId = [PBObjc objcStringToCpp:self.sessionId];
    const uint32_t code = self.code;
    const uint32_t total = self.total;

    for (NSString* error in self.errors) {
        message->add_errors([PBObjc objcStringToCpp:error]);
    }
    
    for (NSData* item in self.data) {
        message->add_data([PBObjc objcDataToCppString:item]);
    }
    
    // c++->protocol buffer
    message->set_msg(msg);
    message->set_sessionid(sessionId);
    message->set_version(self.version);
    message->set_code(code);
    message->set_total(total);
    
    std::string ps = message->SerializeAsString();
    return ps;
}

#pragma mark private methods
- (PAppResponse *)deserialize:(NSData *)data {
    int len = [data length];
    char raw[len];
    PAppResponse *resp = new PAppResponse;
    [data getBytes:raw length:len];
    resp->ParseFromArray(raw, len);
    return resp;
}

@end
