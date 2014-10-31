//
//  DeviceHelper.m
//  MyKingdee
//
//

#import "DeviceHelper.h"
#import "sys/utsname.h"
#import "OpenUDID.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"

@implementation DeviceHelper

/*
 *功能：获取设备类型
 *
 *  AppleTV2,1    AppleTV(2G)
 *  i386          simulator
 *
 *  iPod1,1       iPodTouch(1G)
 *  iPod2,1       iPodTouch(2G)
 *  iPod3,1       iPodTouch(3G)
 *  iPod4,1       iPodTouch(4G)
 *
 *  iPhone1,1     iPhone
 *  iPhone1,2     iPhone 3G
 *  iPhone2,1     iPhone 3GS
 *
 *  iPhone3,1     iPhone 4
 *  iPhone3,3     iPhone4 CDMA版(iPhone4(vz))
 
 *  iPhone4,1     iPhone 4S
 *
 *  iPad1,1       iPad
 *  iPad2,1       iPad2 Wifi版
 *  iPad2,2       iPad2 GSM3G版
 *  iPad2,3       iPad2 CDMA3G版
 *  @return null
 */
+ (NSString *)getDeviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machine;
}

+ (NSString *)getDeviceName{
    return [[UIDevice currentDevice]name];
}
+ (NSString *)getDeviceVName{
    if ([DeviceHelper isIphone]) {
        return @"iPhone";
    }else if ([DeviceHelper isIpad]){
        return @"iPad";
    }else{
        return @"UN";
    }
}
/** 获取IOS系统的版本号 */
+ (NSString*)getOSVersion
{
    return [[UIDevice currentDevice]systemVersion];
}

+ (NSString*)getOSName{
    return [[UIDevice currentDevice]systemName];
}

+ (NSString*)getScreenSize{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return [NSString stringWithFormat:@"%.0f*%.0f", screenRect.size.width,screenRect.size.height];
}

+ (float)getScreenWith{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

+ (float)getScreenHeight{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}
+ (float)getHeight{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    return pixelHeight;
}
+ (NSString*)getAppName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString*)getAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getDeviceUdid{
    NSString *ver = [[UIDevice currentDevice] systemVersion]; // iOS version as string
    int vint = [ver intValue]; // iOS version as int
    if (vint >= 6) {
        NSString *ouuid = [SSKeychain passwordForService:@"com.whosbean.com" account:@"uuid"];
        if (ouuid == nil || [ouuid isEqualToString:@""]) {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            assert(uuid != NULL);
            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
            ouuid = [NSString stringWithFormat:@"%@", uuidStr];
            ouuid = [[ouuid stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
            [SSKeychain setPassword:ouuid forService:@"com.whosbean.com" account:@"uuid"];
        }
        ouuid = [[ouuid stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
        return ouuid;
    }
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *value = [dict objectForKey:@"AppUdid"];
    if (value && [value isEqualToString:@"default"]) {
        return [OpenUDID value];
    }else{
        return [OpenUDID value];
    }
}
+ (NSString *)getAdsUdid{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}
/** 判断当前设备是否ipad */
+ (BOOL)isIpad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

/** 判断当前设备是否iphone */

+ (BOOL)isIphone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
    
}

/** 判断当前系统是否有摄像头 */
+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end
