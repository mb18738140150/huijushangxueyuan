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
#import "ArticleDetailViewController.h"

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

@property (nonatomic, strong)NSString * categoryUrl;
@property (nonatomic, strong)NSString * courseListUrl;


@end

@implementation SecongListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.secondType == SecondListType_artical) {
        self.categoryUrl = @"api/article/categories";
        self.courseListUrl = @"api/article/lists";
    }else{
        self.categoryUrl = @"api/topic/categories";
        self.courseListUrl = @"api/topic/lists";
    }
    
    [self navigationViewSetup];
    
    [SVProgressHUD show];
    [[UserManager sharedManager] getSecondCategoryeWith:@{kUrlName:self.categoryUrl} withNotifiedObject:self];
    self.keyword = @"";
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = self.secondType == SecondListType_living ? @"直播列表" : @"图文音视频列表";
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
        [[UserManager sharedManager] getSecondCategoryeWith:@{kUrlName:self.categoryUrl} withNotifiedObject:self];
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
    
    [SVProgressHUD show];
    if (self.keyword.length > 0) {
        [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:self.courseListUrl,@"cid":[cateInfo objectForKey:@"id"],@"keyword":self.keyword,@"page":@(pageNo),@"requestType":@"get"} withNotifiedObject:self];
    }else
    {
        [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:self.courseListUrl,@"cid":[cateInfo objectForKey:@"id"],@"page":@(pageNo),@"requestType":@"get"} withNotifiedObject:self];
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
    if (self.secondType == SecondListType_artical) {
        ArticleDetailViewController * vc = [[ArticleDetailViewController alloc]init];
        vc.infoDic = info;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    LivingCourseDetailViewController * vc = [[LivingCourseDetailViewController alloc]init];
    vc.info = info;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request

- (void)didRequestNewsListSuccessed
{
    [SVProgressHUD dismiss];
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
    
    if ([[[UserManager sharedManager] getNewsListList] count] == 0) {
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
    
    int index = 1000;
    for (int i = 0; i < self.categoryArray.count ; i++) {
        NSDictionary * cateInfo = [self.categoryArray objectAtIndex:i];
        if ([[cateInfo objectForKey:@"id"] intValue] == self.pid) {
            [self requestDataWith:i];
            index = i;
            [self.courseSegment setSelectedAtIndex:i];
            break;
        }
    }
    if (index == 1000) {
        [self requestDataWith:0];
    }
    
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
