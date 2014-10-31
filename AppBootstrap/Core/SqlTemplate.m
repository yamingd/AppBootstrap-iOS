//
//  SqlTemplate.m
//  EnglishCafe
//
//  Created by yaming_deng on 18/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "SqlTemplate.h"

#define kSQL_VERSION @"select max(id) as maxid from version"

@implementation SqlTemplate{
    FMDatabaseQueue* conn;
}

+(NSString*)dbFilePath:(NSString*)name{
    NSString *documents_dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *db_path = [documents_dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db3", name]];
    return db_path;
}
-(id)initWith:(NSString*)dbname{
    [self doOpenDb:dbname];
    return self;
}
-(id)initWithLatest:(NSString *)dbname{
    [self doOpenDb:dbname];
    NSNumber* latest = [[AppSession current].config objectForKey:@"dbversion"];
    if (![self checkVersion:latest]) {
        [self close];
        [SqlTemplate remove:dbname];
        [self doOpenDb:dbname];
    }
    return self;
}
- (void)doOpenDb:(NSString*)dbname{
    NSFileManager *fm = [NSFileManager defaultManager];
    self.dbpath = [SqlTemplate dbFilePath:dbname];
    NSString *template_path = [[NSBundle mainBundle] pathForResource:dbname ofType:@"db3"];
    BOOL exists = NO;
    if (![fm fileExistsAtPath:self.dbpath]){
        [fm copyItemAtPath:template_path toPath:self.dbpath error:nil];
    }else{
        exists = YES;
    }
    LOG(@"open db: %@", self.dbpath);
    conn = [[FMDatabaseQueue alloc] initWithPath:self.dbpath];
}
- (Boolean)databaseHadError:(Boolean)flag fromDatabase:(FMDatabase *)db
{
    if (flag){
        NSLog(@"Database Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    return flag;
}

#pragma mark - Dealloc
-(void)close{
    if (conn) {
        [conn close];
    }
    conn = nil;
}
+(void)remove:(NSString*)dbname{
    NSString* path = [SqlTemplate dbFilePath:dbname];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
}
- (void)dealloc
{
    [self close];
}
-(NSInteger)count:(NSString*)sql{
    __block NSInteger record;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        [self databaseHadError:[db hadError] fromDatabase:db];
        while ([rs next]) {
            record = [rs intForColumnIndex:0];
            break;
        }
        [rs close];
    }];
    return record;
}
-(NSInteger)countWithArgs:(NSString*)sql args:(NSArray*)args{
    __block NSInteger record;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        [self databaseHadError:[db hadError] fromDatabase:db];
        while ([rs next]) {
            record = [rs intForColumnIndex:0];
            break;
        }
        [rs close];
    }];
    return record;
}

-(NSDictionary*)queryOne:(NSString*)sql{
    __block id record;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        [self databaseHadError:[db hadError] fromDatabase:db];
        while ([rs next]) {
            record = [rs resultDictionary];
            break;
        }
        [rs close];
    }];
    return record;
}
-(NSDictionary*)queryOneWithArgs:(NSString*)sql args:(NSArray*)args{
    __block id record;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        [self databaseHadError:[db hadError] fromDatabase:db];
        while ([rs next]) {
            record = [rs resultDictionary];
            break;
        }
        [rs close];
    }];
    return record;
}

-(NSArray*)queryList:(NSString*)sql{
    __block id record;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        [self databaseHadError:[db hadError] fromDatabase:db];
        record = [[NSMutableArray alloc] init];
        while ([rs next]) {
            [record addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return record;
}
-(NSArray*)queryListWithArgs:(NSString*)sql args:(NSArray*)args{
    __block id record;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        [self databaseHadError:[db hadError] fromDatabase:db];
        record = [[NSMutableArray alloc] init];
        while ([rs next]) {
            [record addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return record;
}

-(BOOL)queryObject:(id)obj sql:(NSString*)sql{
    __block BOOL flag = NO;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        [self databaseHadError:[db hadError] fromDatabase:db];
        while ([rs next]) {
            [rs kvcMagic:obj];
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}
-(BOOL)queryObjectWithArgs:(id)obj sql:(NSString*)sql args:(NSArray*)args{
    __block BOOL flag = NO;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        [self databaseHadError:[db hadError] fromDatabase:db];
        while ([rs next]) {
            [rs kvcMagic:obj];
            flag = YES;
            break;
        }
        [rs close];
    }];
    return flag;
}
-(NSArray*)queryObjectList:(Class)model sql:(NSString*)sql{
    __block id record;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        [self databaseHadError:[db hadError] fromDatabase:db];
        record = [[NSMutableArray alloc] init];
        while ([rs next]) {
            id obj = [[model alloc] init];
            [rs kvcMagic:obj];
            [record addObject:obj];
        }
        [rs close];
    }];
    return record;
}
-(NSArray*)queryObjectListWithArgs:(Class)model sql:(NSString*)sql args:(NSArray*)args{
    __block id record;
    [conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        [self databaseHadError:[db hadError] fromDatabase:db];
        record = [[NSMutableArray alloc] init];
        while ([rs next]) {
            id obj = [[model alloc] init];
            [rs kvcMagic:obj];
            [record addObject:obj];
        }
        [rs close];
    }];
    return record;
}
-(BOOL)update:(NSString*)sql args:(NSArray*)args{
    __block BOOL result = NO;
    [conn inDatabase:^(FMDatabase *db) {
        if (args) {
            result = [db executeUpdate:sql withArgumentsInArray:args];
        }else{
            result = [db executeUpdate:sql];
        }
        [self databaseHadError:[db hadError] fromDatabase:db];
    }];
    return result;
}
-(BOOL)checkVersion:(NSNumber*)latest{
    NSDictionary* dic = [self queryOne:kSQL_VERSION];
    if (dic) {
        NSNumber* maxid = [dic objectForKey:@"maxid"];
        if (maxid.integerValue == latest.integerValue) {
            return YES;
        }
        return NO;
    }
    return YES;
}
@end
