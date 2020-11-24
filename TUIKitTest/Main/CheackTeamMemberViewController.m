//
//  SecongListViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "CheackTeamMemberViewController.h"
#import "MyTeamInfoTableViewCell.h"
#define kSecondListTableViewCell @"MyTeamInfoTableViewCell"
#import "SearchAndCategoryView.h"
#import "ZWMSegmentView.h"
#define kDataArray @"dataArray"

@interface CheackTeamMemberViewController()<UITableViewDelegate, UITableViewDataSource,UserModule_SecondCategoryProtocol,UserModule_CategoryCourseProtocol>
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int pagesize;

@property (nonatomic, strong)ZWMSegmentView * courseSegment;

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *pageIndexArray;
@property (nonatomic, strong)SearchAndCategoryView * topView;
@property (nonatomic, strong)NSString * keyword;

@property (nonatomic, strong)NSString * courseListUrl;
@property (nonatomic, strong)NSString * type;

@end

@implementation CheackTeamMemberViewController

- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.courseListUrl = @"api/promotion/teamRecord";
    self.type = @"all";
    [self loadCateGory];
    [self navigationViewSetup];
    
    [SVProgressHUD show];
    self.keyword = @"";
    [self prepareUI];
    [self requestDataWith:0];
}

- (void)loadCateGory
{
    self.categoryArray = @[@{@"name":@"全部",@"type":@"all"},@{@"name":@"普通合伙人",@"type":@"one"},@{@"name":@"金牌合伙人",@"type":@"two"},@{@"name":@"钻石合伙人",@"type":@"three"}];
    self.pageIndexArray = [NSMutableArray array];
    for (int i = 0; i< self.categoryArray.count; i++) {
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setObject:@"1" forKey:kPageNo];
        [info setObject:@"10" forKey:kPageSize];
        [info setObject:[NSMutableArray array] forKey:kDataArray];
        
        [self.pageIndexArray addObject:info];
    }
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"成员列表";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareUI
{
    self.topView = [[SearchAndCategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    [self.view addSubview:self.topView];
    __weak typeof(self)weakSelf = self;
    self.topView.searchBlock = ^(NSString * _Nonnull key) {
        weakSelf.keyword = key;
        [weakSelf requestDataWith:weakSelf.courseSegment.index];
        
    };
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 95) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView registerClass:[MyTeamInfoTableViewCell class] forCellReuseIdentifier:kSecondListTableViewCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
    
    
    
    [self.topView refreshWith:self.categoryArray];
    
    self.courseSegment = self.topView.zixunSegment;
    
    
    [self requestDataWith:0];
    
    [self.courseSegment selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
        NSLog(@"%ld *** %@", index,button.titleLabel.text);
        
        NSDictionary * cateInfo = [weakSelf.categoryArray objectAtIndex:index];
        weakSelf.type = [cateInfo objectForKey:@"type"];
        NSDictionary * pageNoInfo = [weakSelf.pageIndexArray objectAtIndex:index];
        int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
        NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
        weakSelf.itemArray = mArray;
        
        if (mArray.count == 0 || pageNo > 1) {
            [weakSelf requestDataWith:index];
        }else
        {
            [weakSelf.tableView reloadData];
        }
        
    }];
    
}

- (void)doResetQuestionRequest
{
    
    NSUInteger index = self.courseSegment.index;
    NSMutableDictionary * info = [self.pageIndexArray objectAtIndex:index];
    [info setObject:@1 forKey:kPageNo];
    [self.pageIndexArray replaceObjectAtIndex:index withObject:info];
    self.page = [[info objectForKey:kPageNo] intValue];
    
    [self requestDataWith:self.courseSegment.index];
}

- (void)doNextPageQuestionRequest
{
    NSUInteger index = self.courseSegment.index;
    NSMutableDictionary * info = [self.pageIndexArray objectAtIndex:index];
    int page = [[info objectForKey:kPageNo] intValue];
    page++;
    [info setObject:@(page) forKey:kPageNo];
    [self.pageIndexArray replaceObjectAtIndex:index withObject:info];
    self.page = [[info objectForKey:kPageNo] intValue];
   [self requestDataWith:self.courseSegment.index];
}

#pragma mark - request
- (void)requestDataWith:(NSUInteger )index
{
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    self.itemArray = mArray;
    
    [SVProgressHUD show];
    if (self.keyword.length > 0) {
        [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:self.courseListUrl,@"keyword":self.keyword,@"page":@(pageNo),@"type":self.type,@"requestType":@"get"} withNotifiedObject:self];
    }else
    {
        [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:self.courseListUrl,@"page":@(pageNo),@"type":self.type,@"requestType":@"get"} withNotifiedObject:self];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTeamInfoTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kSecondListTableViewCell forIndexPath:indexPath];
    
    [titleCell refreshUIWithInfo:self.itemArray[indexPath.row]];
    return titleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

#pragma mark - request

- (void)didCategoryCourseSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:self.courseSegment.index];
//    NSDictionary * dataInfo = [[UserManager sharedManager] getCategoryCourseArray];
//    [pageNoInfo setValue:[[dataInfo objectForKey:@"page"] objectForKey:@"recordCount"] forKey:@"recordCount"];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    if(pageNo == 1)
    {
        [mArray removeAllObjects];
    }
    for (NSDictionary * info in [[UserManager sharedManager] getCategoryCourseArray]) {
        [mArray addObject:info];
    }
    
    if ([[[UserManager sharedManager] getCategoryCourseArray] count] == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    self.itemArray = mArray;
    [self.tableView reloadData];
    
}

- (void)didCategoryCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}



@end
