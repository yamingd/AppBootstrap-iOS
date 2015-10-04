//
//  RLMObject+Protobuf.h
//  AppBootstrap
//
//  Created by Yaming on 10/30/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import <string>
#endif

#define kNULL_VALUE @""

@interface PBObjc : NSObject

// these pre or post pend version and hmac info to serialized protocol buffer
// C++<->Objc dates

#ifdef __cplusplus
+(uint64_t) objcDateToCpp:(NSDate*)objcDate;
+(NSDate*) cppDateToObjc:(uint64_t)cppDate;
#endif

// C++<->Objc strings
#ifdef __cplusplus

+(const std::string) objcStringToCpp:(NSString*)objcString;
+(NSString*) cppStringToObjc:(const std::string)cppString;

+(const std::string) objcDataToCppString:(NSData*)objcData;
+(NSData*) cppStringToObjcData:(const std::string) cppString;

#endif

// C++<->Objc ints
+(uint32_t) objcNumberToCppUInt32:(NSNumber*)objcNumber;
+(NSNumber*) cppUInt32ToNSNumber:(uint32_t)cppInt;
+(int) cppUInt32ToInt:(uint32_t)cppInt;

+(float) objcNumberToCppFloat:(NSNumber*)objcNumber;
+(NSNumber*) cppFloatToNSNumber:(float)cppFloat;
+(float) cppFloatToFloat:(float)cppFloat;

+(double) objcNumberToCppDouble:(NSNumber*)objcNumber;
+(NSNumber*) cppDoubleToNSNumber:(double)cppDouble;
+(double) cppDoubleToDouble:(double)cppDouble;

+(uint64_t) objcNumberToCppUInt64:(NSNumber*)objcNumber;
+(NSNumber*) cppUInt64ToNSNumber:(uint64_t)cppInt;
+(long) cppUInt64ToLong:(uint64_t)cppInt;

@end
