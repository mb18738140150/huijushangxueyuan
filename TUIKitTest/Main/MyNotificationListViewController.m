//
//  MyNotificationListViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/16.
//

#import "MyNotificationListViewController.h"
#import "MyNotificationTableViewCell.h"
#define kMyNotificationTableViewCell @"MyNotificationTableViewCell"
#import "ScanSuccessJumpVC.h"
#import "MainVipCardListViewController.h"
#import "MyBuyCourseViewController.h"
#import "StoreViewController.h"
#import "ArticleDetailViewController.h"
#import "SecongListViewController.h"

@interface MyNotificationListViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_NotificationList>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, assign)int page;

@end

@implementation MyNotificationListViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self navigationViewSetup];

    [self loadData];
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"消息管理";
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
    if (self.refreshNewsNumBlock) {
        self.refreshNewsNumBlock(@{});
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MyNotificationTableViewCell class] forCellReuseIdentifier:kMyNotificationTableViewCell];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
}

- (void)loadData
{
    self.page = 1;
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestNotificationListWithInfo:@{kUrlName:@"api/home/message",@"page":@(self.page)} withNotifiedObject:self];
}

- (void)doNextPageQuestionRequest
{
    self.page++;
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestNotificationListWithInfo:@{kUrlName:@"api/home/message",@"page":@(self.page)} withNotifiedObject:self];
}

- (void)didRequestNotificationListSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    NSArray * list = [[UserManager sharedManager] getNotificationArray];
    if (list.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    for (NSDictionary * info in list) {
        [self.dataSource addObject:info];
    }
//    NSDictionary * info = @{@"content":@"sufbierubfeiufiunslknclsknlkslkskldnflkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk",
//                            @"time":@"2020-09-30 11:07:44",
//                            @"jump_type":@"outer",
//                            @"jump_url":@"http://www.baidu.com",
//                            @"send_name":@"测试"
//    };
//    [self.dataSource addObject:info];
    [self.tableView reloadData];
}

- (void)didRequestNotificationListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    MyNotificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMyNotificationTableViewCell forIndexPath:indexPath];
    [cell refreshUIWith:self.dataSource[indexPath.row]];
    cell.lookNotificationBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf pushNotificationDetail:info];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = self.dataSource[indexPath.row];
    NSString * titleStr = [info objectForKey:@"content"];
    CGFloat titleHeight = [titleStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 30 - 30 - 140, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    CGFloat contentHeight = [titleStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 30 - 30 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    
    return 5 + 10 + titleHeight + 10 + contentHeight + 10 + 40;
}

- (void)pushNotificationDetail:(NSDictionary *)info
{
    NSString * juge_type = [info objectForKey:@"jump_type"];
    NSString * juge_url = [info objectForKey:@"jump_url"];
    if ([juge_type isEqualToString:@"inner"]) {
        NSString * innerType = [UIUtility judgeStr:[info objectForKey:@"jump_url"]];
        /*
         index    首页
         center    个人中心
         yd_payred_index    图文音视频
         ask_expert    问答
         zb_topics    直播
         yx_activiy    优惠券
         zb_series    直播专栏
         yd_serialize    普通专栏
         saas_bargain    砍价
         vip_introduce    会员
         shop_index    商城
         mypay    我的已购
         yx_extension_recruit    推广中心
         yd_detail    图文音视频详情
         vip_center    会员中心
         zb_topic_info    直播详情页
         
         */
        if ([innerType isEqualToString:@"index"]) {
            NSLog(@"首页");
            [self.tabBarController setSelectedIndex:0];
        }else if ([innerType isEqualToString:@"center"])
        {
            NSLog(@"个人中心");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([innerType isEqualToString:@"vip_center"])
        {
            MainVipCardListViewController * vc = [[MainVipCardListViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([innerType isEqualToString:@"zb_topics"])
        {
            
            NSString * pid = @"";
            if (![[info objectForKey:@"need_redirect"] isKindOfClass:[NSNull class]]) {
                pid = [[info objectForKey:@"need_redirect"] objectForKey:@"tags"];
            }
            [self pushSecondVC:SecondListType_living andInfo:pid];
        }
        else if ([innerType isEqualToString:@"mypay"])
        {
            MyBuyCourseViewController * vc = [[MyBuyCourseViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([innerType isEqualToString:@"shop_index"])
        {
            StoreViewController * vc = [[StoreViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([innerType isEqualToString:@"yd_payred_index"])
        {
            NSString * pid = @"";
            if (![[info objectForKey:@"need_redirect"] isKindOfClass:[NSNull class]]) {
                pid = [[info objectForKey:@"need_redirect"] objectForKey:@"pid"];
            }
            [self pushSecondVC:SecondListType_artical andInfo:pid];
        }else if ([innerType isEqualToString:@"yd_detail"])
        {
            [self pushArticleDetailVC:[info objectForKey:@"need_redirect"]];
        }
        
    }else if ([juge_type isEqualToString:@"none"])
    {
        NSLog(@"不做跳转");
    }else
    {
        // 跳转外部链接
        ScanSuccessJumpVC * WebVC = [[ScanSuccessJumpVC alloc]init];
        WebVC.comeFromVC = ScanSuccessJumpComeFromWB;
        WebVC.jump_URL = juge_url;
        [self.navigationController pushViewController:WebVC animated:YES];
    }
}

- (void)pushArticleDetailVC:(NSDictionary *)info
{
    ArticleDetailViewController * vc = [[ArticleDetailViewController alloc]init];
    
    vc.infoDic = info;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSecondVC:(SecondListType)type andInfo:(NSString *)pid
{
    SecongListViewController * vc = [[SecongListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.secondType = type;
    vc.pid = pid.intValue;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
