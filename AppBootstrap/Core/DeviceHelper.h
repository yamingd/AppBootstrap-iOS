//
//  DeviceHelper.h
//  MyKingdee
//
//

#import <Foundation/Foundation.h>

@interface DeviceHelper : NSObject

+ (NSString *)getDeviceVersion;
+ (NSString *)getDeviceName;
+ (NSString *)getDeviceVName;

+ (NSString *)getDeviceUdid;
+ (NSString *)getAdsUdid;

+ (NSString*)getOSVersion;
+ (NSString*)getOSName;

+ (NSString*)getScreenSize;
+ (float)getScreenWith;

+ (float)getScreenHeight;

+ (NSString*)getAppName;

+ (NSString*)getAppVersion;

+ (BOOL)isIpad;

+ (BOOL)isIphone;

+ (BOOL)hasCamera;

+ (float)getHeight;

@end
