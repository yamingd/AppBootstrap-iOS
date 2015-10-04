//
//  AppSecurity.h
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 whosbean.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSAppSession.hh"
#import "AppSession.h"

@interface AppSecurity : NSObject

+ (instancetype)instance;
+ (NSString*)randomCode;


+ (NSString*)aes128Encrypt:(NSString*)text salt:(NSString*)salt iv:(NSString *)iv;
+ (NSString*)aes128Decrypt:(NSString*)text salt:(NSString*)salt iv:(NSString *)iv;

@property(strong, nonatomic) NSString* cookieId;
@property(strong, nonatomic) NSString* cookieSalt;

-(NSDictionary*)signSession:(TSAppSession*)session;

-(NSString*)signRequest:(NSString*)url;

@end
