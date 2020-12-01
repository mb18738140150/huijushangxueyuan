//
//  MyIncomeViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/26.
//

#import "MyIncomeViewController.h"
#import "TiXianViewController.h"
#import "MyIncomeHeaderTableViewCell.h"
#define kMyIncomeHeaderTableViewCell @"MyIncomeHeaderTableViewCell"
#import "DailingquViewController.h"

@interface MyIncomeViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_IncomeInfo,UserModule_GiftList>
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int pagesize;
@property (nonatomic, strong) NSMutableArray *pageIndexArray;
@property (nonatomic, strong)ZWMSegmentView * courseSegment;

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, assign)BOOL isTeacher;
@property (nonatomic, strong)NSString * sort;// desc:倒序 asc:正序

@end

@implementation MyIncomeViewController

- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSMutableArray *)pageIndexArray
{
    if (!_pageIndexArray) {
        _pageIndexArray = [NSMutableArray array];
    }
    return _pageIndexArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sort = @"desc";
    [self resetcategoryArray];
    [self requestContentData];
    [self requestDataWith:0];
    [self navigationViewSetup];
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"收益";
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MyIncomeHeaderTableViewCell class] forCellReuseIdentifier:kMyIncomeHeaderTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];

    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
    
    
}

- (void)resetcategoryArray
{
    // 重置数据信息
    [self.pageIndexArray removeAllObjects];
    for (int i = 0; i< 2; i++) {
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setObject:@"1" forKey:kPageNo];
        [info setObject:@"10" forKey:kPageSize];
        [info setObject:[NSMutableArray array] forKey:kDataArray];
        
        [self.pageIndexArray addObject:info];
    }
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
    NSDictionary * cateInfo = [self.categoryArray objectAtIndex:index];
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    self.itemArray = mArray;
    
    NSString * urlName = @"";
    NSString * contentUrl = @"";
    
    if (self.isTeacher) { // 老师
        contentUrl = @"api/teacher/promotionIncome";
        
        if (index == 1) {
            urlName = @"api/teacher/cashRecord";// 提现记录
        }else
        {
            urlName = @"api/teacher/rewardRecord";// 奖励记录
        }
    }else
    {
        contentUrl = @"api/user/promotionIncome";
        if (index == 1) {
            urlName = @"api/user/cashRecord";// 提现记录
        }else
        {
            urlName = @"api/user/rewardRecord";// 奖励记录
        }
    }
    
    [SVProgressHUD show];
    
    [[UserManager sharedManager] didRequestGiftListWithInfo:@{kUrlName:urlName,@"page":@(pageNo),@"sort":self.sort,@"requestType":@"get"} withNotifiedObject:self];
    
}

- (void)requestContentData
{
    NSString * contentUrl = @"";
    
    if (self.isTeacher) { // 老师
        contentUrl = @"api/teacher/promotionIncome";
    }else
    {
        contentUrl = @"api/user/promotionIncome";
    }
    [[UserManager sharedManager] getIncomeInfoWith:@{kUrlName:contentUrl,@"requestType":@"get"} withNotifiedObject:self];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        MyIncomeHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMyIncomeHeaderTableViewCell forIndexPath:indexPath];
        [cell refreshUIWithInfo:[[UserManager sharedManager] getMyIncomeInfo]];
        self.courseSegment = cell.zixunSegment;
        [cell resetIsTeacher:self.isTeacher];
        [cell resetSort:self.sort];
        
        [self.courseSegment  selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
            [weakSelf resetcategoryArray];
            [weakSelf requestDataWith:index];
        }];
        
        cell.dailingquBlock = ^(BOOL isAsc) {
            DailingquViewController * vc = [[DailingquViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        cell.sortBlock = ^(BOOL isAsc) {
            if (isAsc) {
                weakSelf.sort = @"asc";
            }else
            {
                weakSelf.sort = @"desc";
            }
            [weakSelf resetcategoryArray];
            [weakSelf requestDataWith:weakSelf.courseSegment.index];
        };
        
        cell.tixianBlock = ^(NSDictionary * _Nonnull info) {
            NSLog(@" 去提现");
            TiXianViewController * vc = [[TiXianViewController alloc]init];
            vc.isTeacher = weakSelf.isTeacher;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.promisionBlock = ^(NSDictionary * _Nonnull info) {
            weakSelf.sort = @"desc";
            weakSelf.isTeacher = NO;
            [weakSelf resetcategoryArray];
            [weakSelf requestContentData];
            [weakSelf requestDataWith:weakSelf.courseSegment.index];
            
        };
        cell.teacherBlock = ^(NSDictionary * _Nonnull info) {
            weakSelf.sort = @"desc";
            weakSelf.isTeacher = YES;
            [weakSelf resetcategoryArray];
            [weakSelf requestContentData];
            [weakSelf requestDataWith:weakSelf.courseSegment.index];
        };
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    
    NSDictionary * info = self.itemArray[indexPath.row];
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth - 40 - 50, 15)];
    titleLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"title"]];
    titleLB.font = kMainFont;
    titleLB.textColor = UIColorFromRGB(0x333333);
    [cell.contentView addSubview:titleLB];
    
    UILabel * timeLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLB.frame) + 5, kScreenWidth - 40 - 50, 15)];
    timeLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"time"]];
    timeLB.font = kMainFont_10;
    timeLB.textColor = UIColorFromRGB(0x999999);
    [cell.contentView addSubview:timeLB];
    
    UILabel * moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 120, 0, 105, cell.hd_height - 1)];
    moneyLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"money"]];
    moneyLB.font = kMainFont_16;
    moneyLB.textColor = UIColorFromRGB(0x333333);
    moneyLB.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:moneyLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(20, cell.hd_height - 1, kScreenWidth - 40, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [cell.contentView addSubview:separateView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 290;
    }
    return 50;
}

#pragma mark - request

- (void)didIncomeInfoSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    [self.tableView reloadData];
}

- (void)didIncomeInfoFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestGiftListSuccessed
{
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD dismiss];
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:self.courseSegment.index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    if(pageNo == 1)
    {
        [mArray removeAllObjects];
    }
    for (NSDictionary * info in [[UserManager sharedManager] getGiftList]) {
        [mArray addObject:info];
    }
    
    if ([[[UserManager sharedManager] getGiftList] count] == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    self.itemArray = mArray;
    
    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didRequestGiftListFailed:(NSString *)failedInfo
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
