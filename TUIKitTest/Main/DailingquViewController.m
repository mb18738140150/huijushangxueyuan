//
//  DailingquViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/12/1.
//

#import "DailingquViewController.h"
#import "DailingquTableViewCell.h"
#define kDailingquTableViewCell @"DailingquTableViewCellID"
#import "VIPCardDetailViewController.h"

@interface DailingquViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_OrderListProtocol,UserModule_MockVIPBuy>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSDictionary * currentSelectInfo;

@end

@implementation DailingquViewController

- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self navigationViewSetup];
    [self prepareUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needVipCard:) name:kNotificationOfneedVipCard object:nil];

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
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[DailingquTableViewCell class] forCellReuseIdentifier:kDailingquTableViewCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];

    
}

-(void)loadData
{
    self.page = 1;
    [self request];
}

- (void)doNextPageQuestionRequest
{
    self.page++;
    [self request];
}


- (void)request
{
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestOrderListWithCourseInfo:@{kUrlName:@"api/promotion/unclaimedDivide",@"page":@(self.page),@"requestType":@"get"} withNotifiedObject:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    DailingquTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kDailingquTableViewCell forIndexPath:indexPath];
    
    [cell refreshUIWith:self.itemArray[indexPath.row]];
    cell.applyBlock = ^(NSDictionary * _Nonnull info) {
        weakSelf.currentSelectInfo = info;
        [weakSelf lingquAction:info];
    };
    
    cell.livingCourseStartBlock = ^(NSDictionary * _Nonnull info) {
        NSLog(@"****** 倒计时完毕");
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111;
}

- (void)lingquAction:(NSDictionary *)info
{
    [SVProgressHUD show];
    
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/promotion/receiveUnclaimed",@"divide_id":[info objectForKey:@"id"]} withNotifiedObject:self];
}

- (void)didRequestMockVIPBuySuccessed
{
    [self request];
}

- (void)needVipCard:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    __weak typeof(self)weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"msg"]] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf pushVIPCardVC:infoDic];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)pushVIPCardVC:(NSDictionary *)info
{
    NSDictionary * data = [info objectForKey:@"data"];
    VIPCardDetailViewController * vc = [[VIPCardDetailViewController alloc]init];
    vc.info = @{@"id":[data objectForKey:@"card_id"]};
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    if ([failedInfo isEqualToString:@"需要购买vip"]) {
        return;
    }
    
    self.currentSelectInfo = nil;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestOrderListSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    NSArray * list = [[UserManager sharedManager] getMyOrderList];
    
    if (self.currentSelectInfo) {
        NSDictionary * newInfo ;
        for (NSDictionary * info in list) {
            if ([[self.currentSelectInfo objectForKey:@"id"] isEqual:[info objectForKey:@"id"]]) {
                newInfo = info;
                break;
            }
        }
        NSInteger index = [self.itemArray indexOfObject:self.currentSelectInfo];
        [self.itemArray replaceObjectAtIndex:index withObject:newInfo];
        [self.tableView reloadData];
        self.currentSelectInfo = nil;
        return;
    }
    if (self.page == 1) {
        [self.itemArray removeAllObjects];
    }
    if (list.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.page--;
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    for (NSDictionary * info in list) {
        [self.itemArray addObject:info];
    }
    [self.tableView reloadData];
}

- (void)didRequestOrderListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    self.currentSelectInfo = nil;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


@end
