//
//  AddressListViewController.m
//  lanhailieren
//
//  Created by aaa on 2020/3/6.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressListTableViewCell.h"

#define kAddressListTableViewCellID @"AddressListTableViewCellID"
#import "AddressEditViewController.h"


@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource,UserModule_AddressListProtocol>

@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)NSMutableArray * dataSource;

@property (nonatomic, strong)UIButton * addAddressBtn;
@end

@implementation AddressListViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self loadData];
    [self refreshUI_iPhone];
}
- (void)loadData
{
    [self doResetQuestionRequest];
}


- (void)navigationViewSetup
{
    self.navigationItem.title = @"我的地址";
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

- (void)refreshUI_iPhone
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[AddressListTableViewCell class] forCellReuseIdentifier:kAddressListTableViewCellID];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.tableview];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50- kNavigationBarHeight - kStatusBarHeight, kScreenWidth , 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView * seperateVLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    seperateVLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [bottomView addSubview:seperateVLine];
    
    self.addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addAddressBtn.frame = CGRectMake(20, 5, kScreenWidth - 40, 40);
    self.addAddressBtn.layer.cornerRadius = 3;
    self.addAddressBtn.layer.masksToBounds = YES;
    [self.addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addAddressBtn setTitle:@"新建地址" forState:UIControlStateNormal];
    self.addAddressBtn.backgroundColor = kCommonMainBlueColor;
    [bottomView addSubview:self.addAddressBtn];
    
    [self.addAddressBtn addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getAddressList
- (void)doResetQuestionRequest
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getAddressListWithDic:@{kUrlName:@"api/shop/address/lists"} withNotifiedObject:self];
}

- (void)didAddressListFailed:(NSString *)failedInfo
{
    [self.tableview.mj_header endRefreshing];
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didAddressListSuccessed
{
    [self.tableview.mj_header endRefreshing];
    [SVProgressHUD dismiss];
    self.dataSource = [[[UserManager sharedManager] getAddressList] mutableCopy];
    [self.tableview reloadData];
}

#pragma mark - tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAddressListTableViewCellID forIndexPath:indexPath];
    [cell refreshUIWithInfo:[self.dataSource objectAtIndex:indexPath.row]];
    
    __weak typeof(self)weakSelf = self;
    cell.EditAddressBlock = ^(NSDictionary *info) {
        [weakSelf editAddress:info];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFromOrderVC) {
        if(self.addressChooseBlock){
            self.addressChooseBlock([self.dataSource objectAtIndex:indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - add Address

- (void)addAddressAction
{
    AddressEditViewController * setVC = [[AddressEditViewController alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    
    __weak typeof(self)weakSelf = self;
    setVC.editAddressSuccessBlock = ^(NSDictionary *info) {
        [weakSelf doResetQuestionRequest];
    };
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)editAddress:(NSDictionary *)infoDic
{
    
    AddressEditViewController * setVC = [[AddressEditViewController alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    setVC.infoDic = infoDic;
    
    __weak typeof(self)weakSelf = self;
    setVC.editAddressSuccessBlock = ^(NSDictionary *info) {
        [weakSelf doResetQuestionRequest];
    };
    setVC.deleteAddressSuccessBlock = ^(NSDictionary *info) {
        [weakSelf doResetQuestionRequest];
    };
    
    [self.navigationController pushViewController:setVC animated:YES];
}

@end
