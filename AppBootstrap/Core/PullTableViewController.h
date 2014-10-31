//
//  PullTableViewController.h
//  AppBootstrap
//
//  Created by yaming_deng on 1/6/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface PullTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray* itemList;

@property int pageIndex;
@property int start;
@property int limit;

- (void)loadData:(int)type;

- (NSArray*)loadlatestItems;
- (NSArray*)loadMoreItems;

@end
