//
//  ModelSqlEngine.h
//  EnglishCafe
//
//  Created by yaming_deng on 3/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "Model.h"

@interface ModelSqlEngine : NSObject

@property(nonatomic, strong) FMDatabaseQueue* conn;
@property(nonatomic, strong) NSArray* dbm;

+ (instancetype)shared;
-(void)connect;
-(void)test;

-(id)findById:(Class)model  iid:(NSNumber*)iid;
-(NSInteger)count:(Class)model where:(NSDictionary*)where;
-(id)query:(Class)model where:(NSDictionary*)where order:(NSString*)order;
-(id)queryPage:(Class)model where:(NSDictionary*)where order:(NSString*)order page:(NSInteger)page limit:(NSInteger)limit;

-(BOOL)update:(id)item iid:(NSNumber*)iid params:(NSDictionary*)values on_client:(BOOL)on_client;
-(BOOL)incr:(id)item iid:(NSNumber*)iid params:(NSDictionary*)values;

-(BOOL)remove:(Class)model iid:(NSNumber*)iid;
-(BOOL)erase:(Class)model iid:(NSNumber*)iid;
-(BOOL)exists:(Class)model iid:(NSNumber*)iid;

-(BOOL)insert:(id)record params:(NSDictionary*)values;

@end
