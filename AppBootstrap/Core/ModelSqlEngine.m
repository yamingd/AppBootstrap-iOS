//
//  ModelSqlEngine.m
//  EnglishCafe
//
//  Created by yaming_deng on 3/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "ModelSqlEngine.h"

@implementation ModelSqlEngine

+ (instancetype)shared
{
    static ModelSqlEngine *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ModelSqlEngine alloc] init];
        [_sharedClient connect];
    });
    return _sharedClient;
}

- (void)connect{
    // Database path
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    NSString *path                  = [documentsDirectory stringByAppendingPathComponent:@"elscafe2.db"];
    self.dbm = [Utility arrayFromPlist:@"dbm"];
    // Allocate the queue
    _conn                          = [[FMDatabaseQueue alloc] initWithPath:path];
    [self.conn inDatabase:^(FMDatabase *db) {
        for (NSDictionary* table in self.dbm) {
            NSString* tblName = [table objectForKey:@"model"];
            NSMutableString* sql = [[NSMutableString alloc] init];
            [sql appendString:@"CREATE TABLE IF NOT EXISTS "];
            [sql appendString:tblName];
            [sql appendString:@"("];
            int count = [table count] - 1;
            int i = 0;
            for (id key in table) {
                if ([key isEqualToString:@"model"]) {
                    continue;
                }
                i += 1;
                [sql appendFormat:@"%@ %@", key, [table objectForKey:key]];
                if (i<count) {
                    [sql appendString:@","];
                }
            }
            [sql appendString:@")"];
            //LOG(@"sql: %@", sql);
            [db executeUpdate: sql];
        }
        [self databaseHadError:[db hadError] fromDatabase:db];
    }];
}

- (Boolean)databaseHadError:(Boolean)flag fromDatabase:(FMDatabase *)db
{
    if (flag){
        NSLog(@"ELS Database Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    return flag;
}

#pragma mark - Dealloc

- (void)dealloc
{
    if (_conn) {
        [_conn close];
    }
    _conn = nil;
}
-(id)toModel:(Class)model rs:(FMResultSet *)rs{
    NSString* utf8JSON = [rs stringForColumn:@"json_data"];
    NSDictionary* dic = [Utility asObject:utf8JSON];
    return [Model createWith:model data:dic];
}
-(void)test{
    
}
-(id)findById:(Class)model iid:(NSNumber*)iid{
    __block id record;
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"select json_data from %@ where id = ? limit 1 ", NSStringFromClass(model)];
    [self.conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql, iid];
        [self databaseHadError:[db hadError] fromDatabase:db];
        while ([rs next]) {
            record = [self toModel:model rs:rs];
        }
        [rs close];
    }];
    return record;
}
-(NSInteger)count:(Class)model where:(NSDictionary*)where{
    __block NSInteger record;
    NSMutableArray* args = nil;
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"select count(1) as total from %@ ", NSStringFromClass(model)];
    if (where) {
        int i = 0, ns = [where count];
        args = [[NSMutableArray alloc] init];
        [sql appendString:@" where "];
        for (id key in where) {
            i += 1;
            [sql appendFormat:@"%@=?", key];
            [args addObject:[where objectForKey:key]];
            if (i < ns) {
                [sql appendString:@" and "];
            }
        }
    }
    LOG(@"count sql: %@", sql);
    [self.conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            record = [rs intForColumnIndex:0];
        }
        [rs close];
    }];
    return record;
}
-(id)query:(Class)model where:(NSDictionary*)where order:(NSString*)order{
    __block NSMutableArray* record = [[NSMutableArray alloc] init];
    NSMutableArray* args = nil;
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"select json_data from %@ ", NSStringFromClass(model)];
    if (where) {
        int i = 0, ns = [where count];
        args = [[NSMutableArray alloc] init];
        [sql appendString:@" where "];
        for (id key in where) {
            i += 1;
            [sql appendFormat:@"%@=?", key];
            [args addObject:[where objectForKey:key]];
            if (i < ns) {
                [sql appendString:@" and "];
            }
        }
    }
    if (order) {
        [sql appendFormat:@" order by %@", order];
    }
    LOG(@"count sql: %@", sql);
    [self.conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            [record addObject:[self toModel:model rs:rs]];
        }
        [rs close];
    }];
    return record;
}
-(id)queryPage:(Class)model where:(NSDictionary*)where order:(NSString*)order page:(NSInteger)page limit:(NSInteger)limit{
    __block NSMutableArray* record = [[NSMutableArray alloc] init];
    NSMutableArray* args = [[NSMutableArray alloc] init];
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"select json_data from %@ ", NSStringFromClass(model)];
    if (where) {
        int i = 0, ns = [where count];
        [sql appendString:@" where "];
        for (id key in where) {
            i += 1;
            [sql appendFormat:@"%@=?", key];
            [args addObject:[where objectForKey:key]];
            if (i < ns) {
                [sql appendString:@" and "];
            }
        }
    }
    if (order) {
        [sql appendFormat:@" order by %@", order];
    }
    NSInteger offset = (page-1) * limit;
    [sql appendFormat:@" limit ? offset ? "];
    [args addObject:[NSNumber numberWithInt:limit]];
    [args addObject:[NSNumber numberWithInt:offset]];
    LOG(@"count sql: %@", sql);
    [self.conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            [record addObject:[self toModel:model rs:rs]];
        }
        [rs close];
    }];
    return record;
}
-(BOOL)update:(id)item iid:(NSNumber*)iid params:(NSDictionary*)values on_client:(BOOL)on_client{
    __block BOOL record;
    NSMutableArray* args = [[NSMutableArray alloc] init];
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"update %@ set ", NSStringFromClass([item class])];
    
    NSString* json_data = [Utility asJson:item];
    [sql appendString:@"json_data=? "];
    [args addObject:json_data];
    
    if (values) {
        for (id key in values) {
            [sql appendFormat:@", %@=?", key];
            [args addObject:[values objectForKey:key]];
        }
    }
    
    if (on_client) {
        [sql appendString:@", update_at=?, sync_status=0 "];
        NSNumber *ts = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [args addObject:ts];
    }
    
    [sql appendFormat:@" where id = %@", iid];
    [args addObject:iid];
    LOG(@"update sql: %@", sql);
    [self.conn inDatabase:^(FMDatabase *db) {
        record = [db executeUpdate:sql withArgumentsInArray:args];
    }];
    return record;
}
-(BOOL)incr:(Class)model iid:(NSNumber*)iid params:(NSDictionary*)values{
    __block BOOL record;
    NSMutableArray* args = [[NSMutableArray alloc] init];
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"update %@ set ", NSStringFromClass(model)];
    for (id key in values) {
        [sql appendFormat:@"%@=%@ + ?, ", key, key];
        [args addObject:[values objectForKey:key]];
    }
    [sql appendFormat:@"update_at=?, sync_status=0 where id = %@", iid];
    NSNumber *ts = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    [args addObject:ts];
    [args addObject:iid];
    
    LOG(@"incr sql: %@", sql);
    [self.conn inDatabase:^(FMDatabase *db) {
        record = [db executeUpdate:sql withArgumentsInArray:args];
    }];
    return record;

}
-(BOOL)erase:(Class)model iid:(NSNumber*)iid{
    __block BOOL record;
    NSMutableArray* args = [[NSMutableArray alloc] init];
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"delete from %@ ", NSStringFromClass(model)];
    [sql appendFormat:@" where id = %@", iid];
    [args addObject:iid];
    LOG(@"erase sql: %@", sql);
    [self.conn inDatabase:^(FMDatabase *db) {
        record = [db executeUpdate:sql withArgumentsInArray:args];
    }];
    return record;
}
-(BOOL)exists:(Class)model iid:(NSNumber*)iid{
    __block BOOL result = NO;
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"select id from %@ where id = ?", NSStringFromClass(model)];
    [self.conn inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql, iid];
        [self databaseHadError:[db hadError] fromDatabase:db];
        while ([rs next]) {
            result = YES;
        }
        [rs close];
    }];
    return result;
}
-(BOOL)remove:(Class)model iid:(NSNumber*)iid{
    __block BOOL record;
    NSMutableArray* args = [[NSMutableArray alloc] init];
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@" update %@ set hide = 1", NSStringFromClass(model)];
    [sql appendFormat:@" where id = %@", iid];
    [args addObject:iid];
    LOG(@"remove sql: %@", sql);
    [self.conn inDatabase:^(FMDatabase *db) {
        record = [db executeUpdate:sql withArgumentsInArray:args];
    }];
    return record;
}
-(BOOL)insert:(id)record params:(NSDictionary*)values{
    __block BOOL result;
    NSMutableArray* args = [[NSMutableArray alloc] init];
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"insert into %@(", NSStringFromClass([record class])];
    
    NSString* json_data = [Utility asJson:record];
    [sql appendString:@"json_data"];
    [args addObject:json_data];
    
    if (values) {
        for (id key in values) {
            [sql appendFormat:@",%@", key];
            [args addObject:[values objectForKey:key]];
        }
    }
    [sql appendString:@",version_no, create_at, sync_status, hide)"];
    [args addObject:@1];
    NSNumber *ts = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    [args addObject:ts];
    [args addObject:@1];
    [args addObject:@0];
    
    [sql appendString:@"values("];
    for (int i=0; i<args.count-1; i++) {
        [sql appendString:@"?,"];
    }
    [sql appendString:@"?"];
    [sql appendString:@")"];
    
    LOG(@"insert sql: %@", sql);
    [self.conn inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql withArgumentsInArray:args];
    }];
    return result;
}

@end
