//
//  RealmHelper.m
//  AppBootstrap
//
//  Created by Yaming on 10/31/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import "RealmContext.h"

@implementation RealmContext

+(RLMRealm*)open:(NSString *)name{
    // Get the default Realm
    name = [NSString stringWithFormat:@"%@.realm", name];
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *customRealmPath = [documentsDirectory stringByAppendingPathComponent:name];
    LOG(@"Open Realm: %@", customRealmPath);
    return [RLMRealm realmWithPath:customRealmPath];
}
+(void)erase:(NSString*)name{
    name = [NSString stringWithFormat:@"%@.realm", name];
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *customRealmPath = [documentsDirectory stringByAppendingPathComponent:name];
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

@end
