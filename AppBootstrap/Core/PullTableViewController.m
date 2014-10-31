//
//  PullTableViewController.m
//  AppBootstrap
//
//  Created by yaming_deng on 1/6/14.
//  Copyright (c) 2014 whosbean. All rights reserved.
//

#import "PullTableViewController.h"
#import "SVPullToRefresh.h"

@interface PullTableViewController (){
    
}

@end

@implementation PullTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.limit = 20;
    self.start = 65535;
    self.pageIndex = 1;
    
    self.dataSource = [NSMutableArray array];
    self.tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    __weak PullTableViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableview addPullToRefreshWithActionHandler:^{
        [weakSelf loadData:0];
    }];
    
    // setup infinite scrolling
    [self.tableview addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadData:1];
    }];
    
    NSDictionary *dict = @{@"name": NSStringFromClass([self class])};
    [self logClickEvent:@"browse-page" data:dict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
    [self.tableview triggerPullToRefresh];
    LOG(@"viewWillAppear.");
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view from its nib.
    LOG(@"viewDidAppear.");
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark these must be overridden by subclass

- (NSArray*)loadlatestItems{
    self.start = 0;
    LOG(@"Please implement this method First. loadlatestItems, start=0");
    return nil;
}
- (NSArray*)loadMoreItems{
    self.start = 65535;
    LOG(@"Please implement this method First. loadMoreItems, start=65535");
    return nil;
}

- (void)loadData:(int)type{
    __weak PullTableViewController *weakSelf = self;
    if (type == 0) {
        self.itemList = [self loadlatestItems];
        [weakSelf insertRowAtTop];
    }else if(type == 1){
        self.itemList = [self loadMoreItems];
        [weakSelf insertRowAtBottom];
    }else if(type == 2){
        self.itemList = [self loadlatestItems];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:self.itemList];
        [weakSelf.tableview reloadData];
    }
}

- (void)insertRowAtTop {
    __weak PullTableViewController *weakSelf = self;
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableview beginUpdates];
        for (int i=0; i<weakSelf.itemList.count; i++) {
            id item = [weakSelf.itemList objectAtIndex:i];
            [weakSelf.dataSource insertObject:item atIndex:i];
        }
        for (int i=0; i<weakSelf.itemList.count; i++) {
            [weakSelf.tableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
        [weakSelf.tableview endUpdates];
        [weakSelf.tableview.pullToRefreshView stopAnimating];
        LOG(@"Feed.insertRowAtTop, total=%lu", (unsigned long)weakSelf.dataSource.count);
    });
}

- (void)insertRowAtBottom {
    __weak PullTableViewController *weakSelf = self;
    int64_t delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableview beginUpdates];
        int pos = (int)weakSelf.dataSource.count;
        for (int i=0; i<weakSelf.itemList.count; i++) {
            id item = [weakSelf.itemList objectAtIndex:i];
            [weakSelf.dataSource insertObject:item atIndex:pos + i];
        }
        for (int i=0; i<weakSelf.itemList.count; i++) {
            [weakSelf.tableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:pos + i inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        [weakSelf.tableview endUpdates];
        [weakSelf.tableview.infiniteScrollingView stopAnimating];
        LOG(@"insertRowAtBottom, total=%lu", (unsigned long)weakSelf.dataSource.count);
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LOG(@"Please implement this method First. cellForRowAtIndexPath");
    return nil;
}

@end
