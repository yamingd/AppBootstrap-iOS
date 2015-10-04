//
//  RLMObject+Protobuf.m
//  AppBootstrap
//
//  Created by Yaming on 10/30/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import "PBObjc.hh"

@implementation PBObjc

#pragma mark boilerplate conversion methods

+(uint64_t) objcDateToCpp:(NSDate*)objcDate {
    return round([objcDate timeIntervalSince1970]);
}

+(NSDate*) cppDateToObjc:(uint64_t)cppDate {
    return [NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithLongLong:cppDate] doubleValue]];
}

+(const std::string) objcStringToCpp:(NSString*)objcString {
    const char* cstring = [objcString cStringUsingEncoding:NSUTF8StringEncoding];
    const std::string stringFromBytes(cstring);
    return stringFromBytes;
}

+(NSString*) cppStringToObjc:(const std::string)cppString {
    return [NSString stringWithCString:cppString.c_str() encoding:NSUTF8StringEncoding];
}

+(const std::string) objcDataToCppString:(NSData*)objcData {
    int len = (int)[objcData length];
    char raw[len];
    [objcData getBytes:raw length:len];
    const std::string stringFromBytes(raw, len);
    return stringFromBytes;
}

+(NSData*) cppStringToObjcData:(const std::string)cppString {
    return [NSData dataWithBytes:cppString.data() length:cppString.size()];
}

// number int
+(uint32_t) objcNumberToCppUInt32:(NSNumber*)objcNumber {
    return [objcNumber unsignedIntValue];
}
+(NSNumber*) cppUInt32ToNSNumber:(uint32_t)cppInt {
    return [NSNumber numberWithUnsignedLong:cppInt];
}
+(int) cppUInt32ToInt:(uint32_t)cppInt{
    return cppInt;
}

// number & float
+(float) objcNumberToCppFloat:(NSNumber*)objcNumber{
    return [objcNumber floatValue];
}
+(NSNumber*) cppFloatToNSNumber:(float)cppFloat{
    return [NSNumber numberWithFloat:cppFloat];
}
+(float) cppFloatToFloat:(float)cppFloat{
    return cppFloat;
}

// number & double
+(double) objcNumberToCppDouble:(NSNumber*)objcNumber{
    return [objcNumber doubleValue];
}
+(NSNumber*) cppDoubleToNSNumber:(double)cppDouble{
    return [NSNumber numberWithDouble:cppDouble];
}
+(double) cppDoubleToDouble:(double)cppDouble{
    return cppDouble;
}

// number & long
+(uint64_t) objcNumberToCppUInt64:(NSNumber*)objcNumber {
    return [objcNumber unsignedLongLongValue];
}
+(NSNumber*) cppUInt64ToNSNumber:(uint64_t)cppInt {
    return [NSNumber numberWithUnsignedLongLong:cppInt];
}
+(long) cppUInt64ToLong:(uint64_t)cppInt{
    return (long)cppInt;
}

@end
