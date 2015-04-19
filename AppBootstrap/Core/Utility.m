//
//  Utility.m
//  EnglishCafe
//
//  Created by Simsion on 2/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation Utility

+(NSArray*) arrayFromPlist:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSMutableArray *temp = [[NSMutableArray alloc] initWithContentsOfFile:path];
    return temp;
}
+(NSDictionary*) dictFromPlist:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    return temp;
}

+ (NSString *)hmac:(NSString *)text{
    return nil;
}
+(void)urlToFile:(NSString **)url toLocalURL:(NSString *)fileName{
    NSString* mode = [AppSession current].appMode;
    if ([mode isEqualToString:@"local"]) {
        *url = fileName;
    }
}
+(NSString*)loadTxt:(NSString*)name{
    NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:@"txt" inDirectory:@"Data"];
    if (!file) {
        return nil;
    }
    NSString *utf8JSON = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    if (!utf8JSON) {
        return nil;
    }
    return utf8JSON;
}
+(NSDictionary*)loadJsonFile:(NSString *)name{
    NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:@"json" inDirectory:@"Data"];
    if (!file) {
        return nil;
    }
    NSString *utf8JSON = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    if (!utf8JSON) {
        return nil;
    }
    NSData  *jsonData  = [utf8JSON  dataUsingEncoding: NSUTF8StringEncoding];
    NSError  *error  =  nil ;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
       LOG(@"load json file error: %@, name: %@", error, name);   
    }
    return dic;
}
+(NSString*)asJson:(id)object{
    NSError  *error  =  nil ;
    NSData* data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return aString;
}
+(id) asObject:(NSString*)data{
    LOG("asObject:%@", data);
    NSData  *jsonData  = [data  dataUsingEncoding: NSUTF8StringEncoding];
    NSError  *error  =  nil ;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        LOG(@"load json file error: %@", error);
    }
    return dic;
}
+(id) asObject2:(NSData*)data{
    NSError  *error  =  nil ;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        LOG(@"load json file error: %@", error);
    }
    return dic;
}
+(NSString*)urlEscape:(NSString *)unencodedString {
	NSString *s = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                      (CFStringRef)unencodedString,
                                                                      NULL,
                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                      kCFStringEncodingUTF8));
	return s;
}

+(NSString*)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params {
	NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:url];
	// Convert the params into a query string
	if (params) {
		for(id key in params) {
			NSString *sKey = [key description];
			NSString *sVal = [[params objectForKey:key] description];
			// Do we need to add ?k=v or &k=v ?
			if ([urlWithQuerystring rangeOfString:@"?"].location==NSNotFound) {
				[urlWithQuerystring appendFormat:@"?%@=%@", [Utility urlEscape:sKey], [Utility urlEscape:sVal]];
			} else {
				[urlWithQuerystring appendFormat:@"&%@=%@", [Utility urlEscape:sKey], [Utility urlEscape:sVal]];
			}
		}
	}
	return urlWithQuerystring;
}

+(UIColor *)colorFromARGB:(int)argb {
    int blue = argb & 0xff;
    int green = argb >> 8 & 0xff;
    int red = argb >> 16 & 0xff;
    //    int alpha = argb >> 24 & 0xff;
    
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.0f];
}
+(void)pframe:(CGRect)frame{
    LOG(@"frame=(x=%f,y=%f,w=%f,h=%f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

+(int)random:(int)from end:(int)end {
    return (int)from + arc4random() % (end-from+1);
}

+(void)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        
    });
    
}

+(BOOL)mobileOK:(NSString *)mobile{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobile];
    return isMatch;
}

+(id)toHumanSize:(long long)value
{
    double convertedValue = [[NSNumber numberWithLongLong:value] doubleValue];
    int multiplyFactor = 0;
    NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB"];
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, tokens[multiplyFactor]];
}

+ (void)callPhone:(NSString *)phone
{
    if (phone.length > 0) {
        phone = [phone stringByReplacingOccurrencesOfString:@"转" withString:@","];
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}

+ (NSString*)dataHex:(NSData *)data{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer){
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i){
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    LOG(@"hexString: %@", hexString);
    return [NSString stringWithString:hexString];
}

@end
