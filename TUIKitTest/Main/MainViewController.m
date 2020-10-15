//
//  MainViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import "MainViewController.h"
#import "MainUserInfoTableViewCell.h"
#define kMainUserInfoTableViewCell @"MainUserInfoTableViewCell"
#import "MainOpenVIPCardTableViewCell.h"
#define kMainOpenVIPCardTableViewCell @"MainOpenVIPCardTableViewCell"
#import "MyCategoryTableViewCell.h"
#define kMyCategoryTableViewCell @"MyCategoryTableViewCell"
#import "MyOrderStateTableViewCell.h"
#define kMyOrderStateTableViewCell @"MyOrderStateTableViewCell"
#import "MainOperationListTableViewCell.h"
#define kMainOperationListTableViewCell @"MainOperationListTableViewCell"
 
#import "MainVipCardListViewController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic, strong)UITableView * tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(category:) name:kNotificationOfMainMyCategory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderState:) name:kNotificationOfMainMyOrderState object:nil];
}

- (void)category:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    NSLog(@"%@", infoDic);
    
}

- (void)orderState:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    NSLog(@"%@", infoDic);
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"个人中心";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
}

- (void)prepareUI
{
    self.dataSource = @[@{@"image":@"main_我的收益",@"title":@"我的收益"},@{@"image":@"main_赠送记录",@"title":@"赠送记录"},@{@"image":@"main_推广中心",@"title":@"推广中心"},@{@"image":@"main_地址",@"title":@"地址管理"},@{@"image":@"main_清理缓存",@"title":@"清理缓存"}];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MainUserInfoTableViewCell class] forCellReuseIdentifier:kMainUserInfoTableViewCell];
    [self.tableView registerClass:[MyCategoryTableViewCell class] forCellReuseIdentifier:kMyCategoryTableViewCell];
    [self.tableView registerClass:[MyOrderStateTableViewCell class] forCellReuseIdentifier:kMyOrderStateTableViewCell];
    [self.tableView registerClass:[MainOperationListTableViewCell class] forCellReuseIdentifier:kMainOperationListTableViewCell];
    [self.tableView registerClass:[MainOpenVIPCardTableViewCell class] forCellReuseIdentifier:kMainOpenVIPCardTableViewCell];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else
    {
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MainUserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMainUserInfoTableViewCell forIndexPath:indexPath];
            [cell resetUIWithInfo:[[UserManager sharedManager] getUserInfos]];
            return cell;
        }else if (indexPath.row == 1)
        {
            MainOpenVIPCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMainOpenVIPCardTableViewCell forIndexPath:indexPath];
            [cell resetUIWithInfo:@{}];
            return cell;
        }else if (indexPath.row == 2)
        {
            MyCategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMyCategoryTableViewCell forIndexPath:indexPath];
            [cell resetUI];
            return cell;
        }
        else
        {
            MyOrderStateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMyOrderStateTableViewCell forIndexPath:indexPath];
            [cell resetUI];
            return cell;
        }
    }else
    {
        MainOperationListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMainOperationListTableViewCell forIndexPath:indexPath];
        [cell refreshUIWithInfo:self.dataSource[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 60;
    }else
    {
        if (indexPath.row == 0) {
            
            return 100;
        }else if (indexPath.row == 1)
        {
            
            return 60;
        }else if (indexPath.row == 2)
        {
           
            return 96;
        }
        else
        {
            
            return 96;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        if (indexPath.row == 1) {
            MainVipCardListViewController * vc = [[MainVipCardListViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
