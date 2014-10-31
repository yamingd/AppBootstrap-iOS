//
//  RealmHelper.h
//  AppBootstrap
//
//  Created by Yaming on 10/31/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface RealmContext : NSObject

+(RLMRealm*)open:(NSString*)name;
+(void)erase:(NSString*)name;
+(void)update:(NSString*)name block:(void (^)(RLMRealm* realm))block;
+(void)query:(NSString*)name block:(void (^)(RLMRealm* realm))block;

@end
