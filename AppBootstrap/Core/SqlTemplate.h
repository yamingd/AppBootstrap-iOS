//
//  SqlTemplate.h
//  EnglishCafe
//
//  Created by yaming_deng on 18/5/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqlTemplate : NSObject

@property (strong, nonatomic)NSString* dbpath;

-(id)initWith:(NSString*)dbname;
-(id)initWithLatest:(NSString*)dbname;

-(void)close;
+(void)remove:(NSString*)dbname;

-(NSInteger)count:(NSString*)sql;
-(NSInteger)countWithArgs:(NSString*)sql args:(NSArray*)args;

-(NSDictionary*)queryOne:(NSString*)sql;
-(NSDictionary*)queryOneWithArgs:(NSString*)sql args:(NSArray*)args;

-(NSArray*)queryList:(NSString*)sql;
-(NSArray*)queryListWithArgs:(NSString*)sql args:(NSArray*)args;

-(BOOL)queryObject:(id)obj sql:(NSString*)sql;
-(BOOL)queryObjectWithArgs:(id)obj sql:(NSString*)sql args:(NSArray*)args;

-(NSArray*)queryObjectList:(Class)model sql:(NSString*)sql;

-(NSArray*)queryObjectListWithArgs:(Class)model sql:(NSString*)sql args:(NSArray*)args;

-(BOOL)update:(NSString*)sql args:(NSArray*)args;

-(BOOL)checkVersion:(NSNumber*)latest;

+(NSString*)dbFilePath:(NSString*)name;

@end
