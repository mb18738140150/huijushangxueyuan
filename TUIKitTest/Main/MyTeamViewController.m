//
//  MyTeamViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import "MyTeamViewController.h"
#import "MyTeamInfoMemberTableViewCell.h"
#define kMyTeamInfoMemberTableViewCell @"MyTeamInfoMemberTableViewCell"


@interface MyTeamViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_MockVIPBuy>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSDictionary * teamInfo;

@end

@implementation MyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self prepareUI];
    [self loadData];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"我的下级";
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
    [self.tableView registerClass:[MyTeamInfoMemberTableViewCell class] forCellReuseIdentifier:kMyTeamInfoMemberTableViewCell];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)loadData
{
    [SVProgressHUD show];
    // getShareInfo
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/promotion/dashboard",kRequestType:@"get"} withNotifiedObject:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    MyTeamInfoMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMyTeamInfoMemberTableViewCell forIndexPath:indexPath];
    
    [cell refreshUIWith:self.teamInfo];
    cell.checkDetailBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf checkAction];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 610;
}


- (void)checkAction{
    
}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.teamInfo = [[UserManager sharedManager] getVIPBuyInfo];
    [self.tableView reloadData];
}

- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


@end
