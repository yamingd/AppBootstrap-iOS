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

+(NSString*)userFolder;
+(NSString*)commonFolder;

+(RLMRealm*)open:(NSString*)name;
+(RLMRealm*)openCommon:(NSString*)name;

+(void)erase:(NSString*)name;
+(void)update:(NSString*)name block:(void (^)(RLMRealm* realm))block;
+(void)query:(NSString*)name block:(void (^)(RLMRealm* realm))block;

+(void)eraseCommon:(NSString*)name;
+(void)updateCommon:(NSString*)name block:(void (^)(RLMRealm* realm))block;
+(void)queryCommon:(NSString*)name block:(void (^)(RLMRealm* realm))block;

+(void)migrateTo:(int)version withMigrationBlock:(RLMMigrationBlock)block;

@end
