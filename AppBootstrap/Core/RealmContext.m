//
//  RealmHelper.m
//  AppBootstrap
//
//  Created by Yaming on 10/31/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import "RealmContext.h"
#import "AppSession.h"

@implementation RealmContext

+(NSString*)userFolder{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *folder = [NSString stringWithFormat:@"%@/%@", documentsDirectory, [AppSession current].userId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folder;
}
+(RLMRealm*)open:(NSString *)name{
    // Get the default Realm
    name = [NSString stringWithFormat:@"%@.realm", name];
    NSString *customRealmPath = [[RealmContext userFolder] stringByAppendingPathComponent:name];
    LOG(@"Open Realm: %@", customRealmPath);
    NSError* error;
    RLMRealm* rm = [RLMRealm realmWithPath:customRealmPath readOnly:NO error:&error];
    if (error) {
        LOG(@"ex:%@", error);
        [[NSFileManager defaultManager] removeItemAtPath:customRealmPath error:&error];
    }
    return rm;
}
+(void)erase:(NSString*)name{
    name = [NSString stringWithFormat:@"%@.realm", name];
    NSString *customRealmPath = [[RealmContext userFolder] stringByAppendingPathComponent:name];
    LOG(@"Open Realm: %@", customRealmPath);
    [[NSFileManager defaultManager] removeItemAtPath:customRealmPath error:nil];
}
+(void)update:(NSString *)name block:(void (^)(RLMRealm *))block{
    RLMRealm* realm = [RealmContext open:name];
    BOOL error = false;
    [realm beginWriteTransaction];
    @try {
        block(realm);
    }
    @catch (NSException *exception) {
        error = true;
        LOG(@"ex: %@", exception);
        @throw exception;
    }
    @finally {
        if (error) {
            [realm cancelWriteTransaction];
        }else{
            [realm commitWriteTransaction];
        }
    }
    
}

+(void)query:(NSString *)name block:(void (^)(RLMRealm *))block{
    RLMRealm* realm = [RealmContext open:name];
    block(realm);
}

#pragma common cache data for all users

+(NSString*)commonFolder{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *folder = documentsDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folder;
}
+(RLMRealm*)openCommon:(NSString *)name{
    // Get the default Realm
    name = [NSString stringWithFormat:@"%@.realm", name];
    NSString *customRealmPath = [[RealmContext commonFolder] stringByAppendingPathComponent:name];
    LOG(@"Open Realm: %@", customRealmPath);
    NSError* error;
    RLMRealm* rm = [RLMRealm realmWithPath:customRealmPath readOnly:NO error:&error];
    if (error) {
        LOG(@"ex:%@", error);
        [[NSFileManager defaultManager] removeItemAtPath:customRealmPath error:&error];
    }
    return rm;
}
+(void)eraseCommon:(NSString*)name{
    name = [NSString stringWithFormat:@"%@.realm", name];
    NSString *customRealmPath = [[RealmContext commonFolder] stringByAppendingPathComponent:name];
    LOG(@"Open Realm: %@", customRealmPath);
    [[NSFileManager defaultManager] removeItemAtPath:customRealmPath error:nil];
}
+(void)updateCommon:(NSString *)name block:(void (^)(RLMRealm *))block{
    RLMRealm* realm = [RealmContext openCommon:name];
    BOOL error = false;
    [realm beginWriteTransaction];
    @try {
        block(realm);
    }
    @catch (NSException *exception) {
        error = true;
        LOG(@"ex: %@", exception);
        @throw exception;
    }
    @finally {
        if (error) {
            [realm cancelWriteTransaction];
        }else{
            [realm commitWriteTransaction];
        }
    }
    
}

+(void)queryCommon:(NSString *)name block:(void (^)(RLMRealm *))block{
    RLMRealm* realm = [RealmContext openCommon:name];
    block(realm);
}

@end
