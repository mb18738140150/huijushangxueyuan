//
//  LivingShareListView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import "LivingShareListView.h"
#import "LivingShareListTableViewCell.h"
#define kLivingShareListTableViewCell @"LivingShareListTableViewCell"

@interface LivingShareListView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataSource;

@end

@implementation LivingShareListView

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LivingShareListTableViewCell class] forCellReuseIdentifier:kLivingShareListTableViewCell];
    [self addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
}

- (void)loadData
{
    if (self.moreShareListBlock) {
        self.moreShareListBlock(YES);
    }
}

- (void)doNextPageQuestionRequest
{
    if (self.moreShareListBlock) {
        self.moreShareListBlock(NO);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LivingShareListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kLivingShareListTableViewCell forIndexPath:indexPath];
    [cell resetUIWithInfo:self.dataSource[indexPath.row]];
    [cell setSort:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)addDataSource:(NSArray *)newDataSource withFirstPage:(BOOL)firstPage
{
    [self.tableView.mj_header endRefreshing];
    if (newDataSource.count < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    if (firstPage) {
        [self.dataSource removeAllObjects];
    }
    
    for (NSDictionary * info in newDataSource) {
        [self.dataSource addObject:info];
    }
    [self.tableView reloadData];
}

@end
