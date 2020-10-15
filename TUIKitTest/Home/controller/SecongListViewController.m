//
//  SecongListViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "SecongListViewController.h"
#import "SecondListTableViewCell.h"
#define kSecondListTableViewCell @"SecondListTableViewCell"
#import "SearchAndCategoryView.h"
#import "ZWMSegmentView.h"
#define kDataArray @"dataArray"
#import "LivingCourseDetailViewController.h"

@interface SecongListViewController()<UITableViewDelegate, UITableViewDataSource,UserModule_SecondCategoryProtocol,UserModule_CategoryCourseProtocol>
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int pagesize;

@property (nonatomic, strong)ZWMSegmentView * courseSegment;

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *pageIndexArray;
@property (nonatomic, strong)SearchAndCategoryView * topView;
@property (nonatomic, strong)NSString * keyword;

@end

@implementation SecongListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationViewSetup];
    
    [[UserManager sharedManager] getSecondCategoryeWith:@{kUrlName:@"api/topic/categories"} withNotifiedObject:self];
    self.keyword = @"";
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"直播列表";
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
    [self.tableView registerClass:[SecondListTableViewCell class] forCellReuseIdentifier:kSecondListTableViewCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
        
}

- (void)doResetQuestionRequest
{
    if (self.categoryArray.count == 0) {
        [[UserManager sharedManager] getSecondCategoryeWith:@{kUrlName:@"api/topic/categories"} withNotifiedObject:self];
        return;
    }
    
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
    NSDictionary * cateInfo = [self.categoryArray objectAtIndex:index];
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    self.itemArray = mArray;
    
    if (self.keyword.length > 0) {
        [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:@"api/topic/lists",@"cid":[cateInfo objectForKey:@"id"],@"keyword":[self.keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"page":@(pageNo)} withNotifiedObject:self];
    }else
    {
        [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:@"api/topic/lists",@"cid":[cateInfo objectForKey:@"id"],@"page":@(pageNo)} withNotifiedObject:self];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SecondListTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kSecondListTableViewCell forIndexPath:indexPath];
    
    [titleCell resetCellContent:self.itemArray[indexPath.row]];
    return titleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = [self.itemArray objectAtIndex:indexPath.row];
    LivingCourseDetailViewController * vc = [[LivingCourseDetailViewController alloc]init];
    vc.info = info;
    vc.index = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request

- (void)didRequestNewsListSuccessed
{
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:self.courseSegment.index];
    NSDictionary * dataInfo = [[UserManager sharedManager] getNewsListInfo];
    [pageNoInfo setValue:[[dataInfo objectForKey:@"page"] objectForKey:@"recordCount"] forKey:@"recordCount"];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    if(pageNo == 1)
    {
        [mArray removeAllObjects];
    }
    for (NSDictionary * info in [[UserManager sharedManager] getNewsListList]) {
        [mArray addObject:info];
    }
    
    if (mArray.count >= [[pageNoInfo objectForKey:@"recordCount"] intValue]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    self.itemArray = mArray;
    [self.tableView reloadData];
}

- (void)didRequestNewsListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didCategoryCourseSuccessed
{
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
    
    if (mArray.count >= [[pageNoInfo objectForKey:@"recordCount"] intValue]) {
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

- (void)didSecondCategorySuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    self.categoryArray = [[UserManager sharedManager]getSecondCategoryeArray];
    self.pageIndexArray = [NSMutableArray array];
       for (int i = 0; i< self.categoryArray.count; i++) {
           NSMutableDictionary * info = [NSMutableDictionary dictionary];
           [info setObject:@"1" forKey:kPageNo];
           [info setObject:@"10" forKey:kPageSize];
           [info setObject:[NSMutableArray array] forKey:kDataArray];
           
           [self.pageIndexArray addObject:info];
       }
    [self.topView refreshWith:self.categoryArray];
    self.courseSegment = self.topView.zixunSegment;
    [self requestDataWith:0];
    __weak typeof(self)weakSelf = self;
    [self.courseSegment selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
        NSLog(@"%ld *** %@", index,button.titleLabel.text);
        
        NSDictionary * cateInfo = [weakSelf.categoryArray objectAtIndex:index];
           
           NSDictionary * pageNoInfo = [weakSelf.pageIndexArray objectAtIndex:index];
           int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
           NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
           weakSelf.itemArray = mArray;
           
           if (mArray.count == 0 || pageNo > 1) {
               [weakSelf requestDataWith:index];
           }else
           {
               if (mArray.count >= [[pageNoInfo objectForKey:@"recordCount"] intValue]) {
                   [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
               }else
               {
                   [weakSelf.tableView.mj_footer endRefreshing];
               }
               [weakSelf.tableView reloadData];
           }
        
    }];
}

- (void)didSecondCategoryFailed:(NSString *)failedInfo
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
