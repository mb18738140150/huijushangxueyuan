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
#import "UserCenterViewController.h"
#import "MyNotificationListViewController.h"
#import "MyBuyCourseViewController.h"
#import "MyPresentRecordViewController.h"
#import "AddressListViewController.h"
#import "TeacherDetailViewController.h"
#import "MyIncomeViewController.h"
#import "MyPromotionViewController.h"
#import "ShoppingCarViewController.h"
#import "OrderListViewController.h"
#import "BuySuccessAndPresentViewController.h"


@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_GetUserInfo,UserModule_MockVIPBuy>

@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, assign)int news_num;

@property (nonatomic, assign)BOOL divide_open;
@property (nonatomic, assign)BOOL shop_open;
@property (nonatomic, strong)NSDictionary * promotionInfo;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self prepareUI];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderState:) name:kNotificationOfMainMyCategory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderState:) name:kNotificationOfMainMyOrderState object:nil];

}


- (void)category:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    NSLog(@"%@", infoDic);
}

- (void)didGetUserInfoSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [UserManager sharedManager].news_num = [[[[UserManager sharedManager] getUserInfo] objectForKey:@"news_num"] intValue];
    
    self.promotionInfo = [[[UserManager sharedManager] getUserInfo] objectForKey:@"promoter"];
    [self.tableView reloadData];
}

- (void)didGetUserInfolFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD dismiss];
    BOOL divide_open = [[[[UserManager sharedManager] getVIPBuyInfo] objectForKey:@"divide_open"] boolValue];
    self.divide_open = divide_open;
    self.shop_open = [[[[UserManager sharedManager] getVIPBuyInfo] objectForKey:@"shop_open"] boolValue];
    if (divide_open) {
        // 开启推广
        self.dataSource = @[@{@"image":@"main_我的收益",@"title":@"我的收益"},@{@"image":@"main_赠送记录",@"title":@"赠送记录"},@{@"image":@"main_推广中心",@"title":@"推广中心"},@{@"image":@"main_地址",@"title":@"地址管理"},@{@"image":@"main_清理缓存",@"title":@"清理缓存"}];
    }else
    {
        // 关闭推广
        self.dataSource = @[@{@"image":@"main_我的收益",@"title":@"我的收益"},@{@"image":@"main_赠送记录",@"title":@"赠送记录"},@{@"image":@"main_地址",@"title":@"地址管理"},@{@"image":@"main_清理缓存",@"title":@"清理缓存"}];
    }
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

- (void)orderState:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    int courseCategoryId = [[infoDic objectForKey:@"courseCategoryId"] intValue];
    __weak typeof(self)weakSelf = self;
    switch (courseCategoryId) {
        case CategoryType_myNotification:
        {
            MyNotificationListViewController * vc = [[MyNotificationListViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [UserManager sharedManager].news_num = 0;
            vc.refreshNewsNumBlock = ^(NSDictionary * _Nonnull info) {
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case CategoryType_myBuyCourse:
        {
            MyBuyCourseViewController * vc = [[MyBuyCourseViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case CategoryType_daiFuKuan:
        {
            [self pushOrderList:1];
        }
            break;
        case CategoryType_daiShouHuo:
        {
            [self pushOrderList:2];
        }
            break;
        case CategoryType_daiFaHuo:
        {
            [self pushOrderList:3];
        }
            break;
        case CategoryType_allOrder:
        {
            [self pushOrderList:0];
        }
            break;
        case CategoryType_ShoppingCar:
        {
            ShoppingCarViewController * vc = [[ShoppingCarViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
//    NSLog(@"%@", infoDic);
}

- (void)pushOrderList:(int )cateId
{
    OrderListViewController * vc = [[OrderListViewController alloc]init];
    vc.cateId = cateId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

}

- (void)loadData
{
    [[UserManager sharedManager] getUserInfoWith:@{kUrlName:@"api/home/user"} withNotifiedObject:self];

    [[UserManager sharedManager]didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/custom/setting",@"requestType":@"get"} withNotifiedObject:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.shop_open) {
            return 4;
        }
        return 3;
    }else
    {
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MainUserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMainUserInfoTableViewCell forIndexPath:indexPath];
            [cell resetUIWithInfo:[[UserManager sharedManager] getUserInfos]];
            cell.joinCourseBlock = ^(NSDictionary * _Nonnull info) {
                TeacherDetailViewController * vc = [[TeacherDetailViewController alloc]init];
                vc.info = info;
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
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
        }else if (indexPath.row == 0)
        {
            __weak typeof(self)weakSelf = self;
            UserCenterViewController * vc = [[UserCenterViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            vc.updateBaseInfoBlock = ^(BOOL update) {
                [weakSelf.tableView reloadData];
            };
        }
    }else
    {
        NSDictionary * info = self.dataSource[indexPath.row];
        NSString * title = [info objectForKey:@"title"];
        if ([title containsString:@"我的收益"]) {
            MyIncomeViewController * vc = [[MyIncomeViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([title containsString:@"赠送记录"])
        {
            
            MyPresentRecordViewController * vc = [[MyPresentRecordViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([title containsString:@"地址管理"])
        {
            AddressListViewController * setVC = [[AddressListViewController alloc]init];
            setVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVC animated:YES];
        }else if ([title containsString:@"推广中心"])
        {
            PromotionType promotionType;
            if (self.divide_open) {
                if (![self.promotionInfo isKindOfClass:[NSNull class]]) {
                    if ([[self.promotionInfo objectForKey:@"status"] intValue] == 1) {
                        promotionType = PromotionType_check;
                    }else if ([[self.promotionInfo objectForKey:@"status"] intValue] == 2)
                    {
                        promotionType = PromotionType_complate;
                    }else
                    {
                        promotionType = PromotionType_apply;
                    }
                }else
                {
                    promotionType  = PromotionType_apply;
                }
            }else
            {
                promotionType  = PromotionType_apply;
            }
            MyPromotionViewController * setVC = [[MyPromotionViewController alloc]init];
            setVC.hidesBottomBarWhenPushed = YES;
            setVC.promotionType = promotionType;
            [self.navigationController pushViewController:setVC animated:YES];
        }
        
    }
}

@end
