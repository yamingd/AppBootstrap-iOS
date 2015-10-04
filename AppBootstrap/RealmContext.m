//
//  RealmContext.m
//  AppBootstrap
//
//  RealmContext实例 需要放在应用全局变量
//
//  Created by Yaming on 10/31/14.
//  Copyright (c) 2014 whosbean.com. All rights reserved.
//

#import "RealmContext.h"
#import "AppSession.h"

@interface RealmContext ()

@property(strong, nonatomic) RLMRealmConfiguration *config;

@end

@implementation RealmContext

+(NSString*)userFolder{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *folder = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"realm"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folder;
}

-(instancetype)initWith:(NSString*)name classes:(NSArray*)classes version:(int)version{
    self = [super init];
    if (self) {
        self.name = name;
        self.classes = classes;
        self.version = version;
        
        // Get the Realm
        NSString *customRealmPath = [[RealmContext userFolder] stringByAppendingPathComponent:self.name];
        LOG(@"Open Realm: %@", customRealmPath);
        
        _config = [RLMRealmConfiguration defaultConfiguration];
        if (self.classes) {
            _config.objectClasses = self.classes;
        }
        _config.path = customRealmPath;
        _config.readOnly = NO;
        _config.schemaVersion = self.version;
        _config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion){
            if (oldSchemaVersion < self.version) {
            }
        };
    }
    
    return self;
}

-(void)dealloc{
    
}

-(RLMRealm*)open{
    NSError* error;
    RLMRealm* rm = [RLMRealm realmWithConfiguration:_config error:&error];
    if (error) {
        LOG(@"ex:%@", error);
        [[NSFileManager defaultManager] removeItemAtPath:_config.path error:&error];
    }
    return rm;
}

-(void)erase{
    NSString *customRealmPath = [[RealmContext userFolder] stringByAppendingPathComponent:self.name];
    LOG(@"Erase Realm: %@", customRealmPath);
    [[NSFileManager defaultManager] removeItemAtPath:customRealmPath error:nil];
}

-(void)update:(void (^)(RLMRealm *))block{
    RLMRealm* realm = [self open];
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

-(void)query:(void (^)(RLMRealm *))block{
    RLMRealm* realm = [self open];
    block(realm);
}

@end
