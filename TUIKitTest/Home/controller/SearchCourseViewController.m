//
//  SecongListViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "SearchCourseViewController.h"
#import "SecondListTableViewCell.h"
#define kSecondListTableViewCell @"SecondListTableViewCell"
#import "SearchAndCategoryView.h"
#import "ZWMSegmentView.h"
#define kDataArray @"dataArray"
#import "LivingCourseDetailViewController.h"
#import "ArticleDetailViewController.h"


@interface SearchCourseViewController()<UITableViewDelegate, UITableViewDataSource,UserModule_SecondCategoryProtocol,UserModule_CategoryCourseProtocol,UserModule_GiftList>
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

@property (nonatomic, strong)NSMutableArray * articleArray;
@property (nonatomic, strong)NSMutableArray * topicArray;


@end

@implementation SearchCourseViewController

- (NSMutableArray *)articleArray
{
    if (!_articleArray) {
        _articleArray = [NSMutableArray array];
    }
    return _articleArray;
}

- (NSMutableArray *)topicArray
{
    if (!_topicArray) {
        _topicArray = [NSMutableArray array];
    }
    return _topicArray;
}

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

    [self.itemArray addObject:self.articleArray];
    [self.itemArray addObject:self.topicArray];
    
    self.keyword = @"";
    [self navigationViewSetup];
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"搜索";
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
    self.topView = [[SearchAndCategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [self.view addSubview:self.topView];
    [_topView hideCategoryView];
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
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
}

- (void)doResetQuestionRequest
{
//    if (self.categoryArray.count == 0) {
//        [[UserManager sharedManager] getSecondCategoryeWith:@{kUrlName:self.categoryUrl} withNotifiedObject:self];
//        return;
//    }
//
//    NSUInteger index = self.courseSegment.index;
//    NSMutableDictionary * info = [self.pageIndexArray objectAtIndex:index];
//    [info setObject:@1 forKey:kPageNo];
//    [self.pageIndexArray replaceObjectAtIndex:index withObject:info];
//    self.page = [[info objectForKey:kPageNo] intValue];
    
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
//    self.itemArray = mArray;
    
    [self.articleArray removeAllObjects];
    [self.topicArray removeAllObjects];
    
    [SVProgressHUD show];
    if (self.keyword.length > 0) {
        [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:@"api/topic/lists",@"cid":@0,@"keyword":self.keyword,@"page":@1,@"requestType":@"get"} withNotifiedObject:self];
        
        [[UserManager sharedManager] didRequestGiftListWithInfo:@{kUrlName:@"api/article/lists",@"cid":@0,@"keyword":self.keyword,@"page":@1,@"requestType":@"get"} withNotifiedObject:self];
        
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"搜索内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.itemArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SecondListTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kSecondListTableViewCell forIndexPath:indexPath];
    
    [titleCell resetCellContent:[self.itemArray[indexPath.section] objectAtIndex:indexPath.row]];
    return titleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 50)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, tableView.hd_width - 20, 50)];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    [backView addSubview:headView];
    
//    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:headView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
//    layer.frame = headView.bounds;
//    layer.path = path.CGPath;
//    [headView.layer setMask:layer];
    
    UILabel * titleView = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 12, 120, 25)];
    titleView.font = kMainFont;
    titleView.textColor = UIColorFromRGB(0x333333);
    [headView addSubview:titleView];

    
    if (section == 0) {
        titleView.text = @"图文";
    }else if (section == 1)
    {
        titleView.text = @"直播";
    }
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, 49, headView.hd_width - 30, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [headView addSubview:seperateView];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        if (self.articleArray.count == 0) {
            return 0;;
        }else
        {
            return 50;
        }
    }
    if (self.topicArray.count == 0) {
        return 0;;
    }else
    {
        return 50;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = [[self.itemArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
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

- (void)didRequestGiftListSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:self.courseSegment.index];

    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    if(pageNo == 1)
    {
        [mArray removeAllObjects];
    }
    
    [self.articleArray removeAllObjects];
    
    for (NSDictionary * info in [[UserManager sharedManager] getGiftList]) {
        [self.articleArray addObject:info];
    }
    
    if ([[[UserManager sharedManager] getCategoryCourseArray] count] == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
//    self.itemArray = mArray;
    [self.tableView reloadData];
}

- (void)didRequestGiftListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
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

    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    if(pageNo == 1)
    {
        [mArray removeAllObjects];
    }
    for (NSDictionary * info in [[UserManager sharedManager] getCategoryCourseArray]) {
        [self.topicArray addObject:info];
    }
    
    if ([[[UserManager sharedManager] getCategoryCourseArray] count] == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
//    self.itemArray = mArray;
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
        [self.courseSegment setSelectedAtIndex:0];
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
