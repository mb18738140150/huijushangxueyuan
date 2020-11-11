//
//  OrderDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "OrderDetailViewController.h"
#import "OrderHeaderStateTableViewCell.h"
#define kOrderHeaderStateTableViewCell @"OrderHeaderStateTableViewCell"
#import "OrderCommoditysTableViewCell.h"
#define kOrderCommoditysTableViewCell @"OrderCommoditysTableViewCell"
#import "OrderSendInfoTableViewCell.h"
#define kOrderSendInfoTableViewCell @"OrderSendInfoTableViewCell"
#import "OrderPayInfoTableViewCell.h"
#define kOrderPayInfoTableViewCell @"OrderPayInfoTableViewCell"
#import "ShoppingCarListTableViewCell.h"
#define kShoppingCarListTableViewCellID @"ShoppingCarListTableViewCellID"
#import "CommodityDetailViewController.h"
#import "ShareAndPaySelectView.h"

@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_MockVIPBuy,UserModule_PayOrderProtocol,UserModule_MockPartnerBuy>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSDictionary * orderInfo;

@property (nonatomic, assign)BOOL isWechat;
@property (nonatomic, strong)NSDictionary * curtrentSelectOrderInfo;
@property (nonatomic, strong)ShareAndPaySelectView * payView;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    
    [self refreshUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];
}

- (void)loadData
{
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/shop/order/detail",kRequestType:@"get",@"order_id":[self.info objectForKey:@"id"]} withNotifiedObject:self];
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"订单详情";
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
    if (self.backBlock) {
        self.backBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[OrderHeaderStateTableViewCell class] forCellReuseIdentifier:kOrderHeaderStateTableViewCell];
    [self.tableView registerClass:[OrderCommoditysTableViewCell class] forCellReuseIdentifier:kOrderCommoditysTableViewCell];
    [self.tableView registerClass:[OrderSendInfoTableViewCell class] forCellReuseIdentifier:kOrderSendInfoTableViewCell];
    [self.tableView registerClass:[OrderPayInfoTableViewCell class] forCellReuseIdentifier:kOrderPayInfoTableViewCell];
    [self.tableView registerClass:[ShoppingCarListTableViewCell class] forCellReuseIdentifier:kShoppingCarListTableViewCellID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[self.orderInfo objectForKey:@"status"] isEqualToString:@"wait-payment"]) {
        return 3;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        NSArray * commoditys = [[self.orderInfo objectForKey:@"commodities"] objectForKey:@"data"];
        return commoditys.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        OrderHeaderStateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kOrderHeaderStateTableViewCell forIndexPath:indexPath];
        [cell refreshUIWithInfo:self.orderInfo andOrderState:OrderState_noRecive];
        cell.buyBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf payAction];
        };
        cell.complateBlock = ^(NSDictionary * _Nonnull info) {
            [[UserManager sharedManager] didRequestMockPartnerBuyWithInfo:@{kUrlName:@"api/shop/order/takeOver",@"order_id":[self.info objectForKey:@"id"]} withNotifiedObject:weakSelf];
        };
        
        return cell;
    }else if(indexPath.section == 1)
    {
        NSArray * commoditys = [[self.orderInfo objectForKey:@"commodities"] objectForKey:@"data"];
        if (indexPath.row == commoditys.count) {
            OrderCommoditysTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kOrderCommoditysTableViewCell forIndexPath:indexPath];
            [cell refreshUIWithInfo:self.orderInfo];
            return cell;
        }
        ShoppingCarListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kShoppingCarListTableViewCellID forIndexPath:indexPath];
        [cell refreshOrderDetailCellWith:commoditys[indexPath.row]];
        
        return cell;
    }else if (indexPath.section == 3)
    {
        OrderPayInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kOrderPayInfoTableViewCell forIndexPath:indexPath];
        [cell refreshUIWithInfo:self.orderInfo];
        return cell;
    }
    OrderSendInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kOrderSendInfoTableViewCell forIndexPath:indexPath];
    cell.connectBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf telephoneAction:[NSString stringWithFormat:@"%@", [UIUtility judgeStr:[weakSelf.orderInfo objectForKey:@"shop_mobile"]]]];
    };
    [cell refreshUIWithInfo:self.orderInfo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = self.orderInfo;
    if (indexPath.section == 0) {
        if ([[info objectForKey:@"status"] isEqualToString:@"wait-payment"] || [[info objectForKey:@"status"] isEqualToString:@"shipped"]) {
            return 90;
        }else if ( [[info objectForKey:@"status"] isEqualToString:@"wait-pick-up"])
        {
            /*
             待取货和已发货的时候显示 【确认收货】
                待取货的时候显示【 核销码】
             */
            
            return 140;
        }else
        {
            return 50;
        }
    }else if (indexPath.section == 1)
    {
        NSArray * commoditys = [[self.orderInfo objectForKey:@"commodities"] objectForKey:@"data"];
        if (indexPath.row == commoditys.count) {
            if ([[self.orderInfo objectForKey:@"buy_type"] intValue] == 1) {
                return 90;
            }else
            {
                return 50;
            }
        }else
        {
            return 80;
        }
    }else if (indexPath.section == 3)
    {
        return 120;
    }
    
    if ([[info objectForKey:@"status"] isEqualToString:@"shipped"] && [[info objectForKey:@"buy_type"] intValue] == 1) {
        return 210;
    }
    
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSArray * commoditys = [[self.orderInfo objectForKey:@"commodities"] objectForKey:@"data"];
        if (indexPath.row < commoditys.count) {
            CommodityDetailViewController * vc = [[CommodityDetailViewController alloc]init];
            vc.info = commoditys[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0;
}


#pragma mark - 拨打电话
- (void)telephoneAction:(NSString *)telStr
{
    NSString *callPhone = [NSString stringWithFormat:@"telprompt:%@", telStr];

    /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];

    });
}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.orderInfo = [[UserManager sharedManager] getVIPBuyInfo];
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

- (void)didRequestMockPartnerBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestMockPartnerBuySuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self loadData];
}

#pragma mark - pay

- (void)payAction
{
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:NO];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
    self.payView = payView;
}


- (void)paySuccedsss:(NSNotification *)notification
{
    NSLog(@"paySuccedsss");
    [self loadData];
}

- (void)payClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [self.payView removeFromSuperview];
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_wechatPay) {
        NSLog(@"微信支付");
        self.isWechat = YES;
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/shop/order/wechat",@"order_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]} withNotifiedObject:self];
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_zhifubPay)
    {
        self.isWechat = NO;
        NSLog(@"支付宝支付");
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/shop/order/alipay",@"order_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]} withNotifiedObject:self];
    }
}

- (void)didRequestPayOrderSuccessed
{
    [SVProgressHUD dismiss];
    self.curtrentSelectOrderInfo = nil;
    NSDictionary * info = [[UserManager sharedManager]getPayOrderInfo];
    if (_isWechat) {
        [self weichatPay:[info objectForKey:@"wechat"]];
    }else
    {
        [self alipay:[info objectForKey:@"alipay"]];
    }
}

- (void)weichatPay:(NSDictionary *)info
{
    NSDictionary * dict = info;
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req completion:nil];
    
}

- (void)alipay:(NSString *)url
{
    [[AlipaySDK defaultService] payOrder:url fromScheme:@"huijushangxueyuan" callback:^(NSDictionary *resultDic) {
        NSLog(@"%@",resultDic);
        NSString *str = resultDic[@"memo"];
        [SVProgressHUD showErrorWithStatus:str];
        
        NSString *resultStatus = resultDic[@"resultStatus"];
        switch (resultStatus.integerValue) {
            case 9000:// 成功
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfBuyCourseSuccess object:nil];
                NSLog(@"支付成功");
                break;
            case 6001:// 取消
                NSLog(@"用户中途取消");
                break;
            default:
                NSLog(@"支付失败");
                break;
        }
        
    }];
    
}

- (void)didRequestPayOrderFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    self.curtrentSelectOrderInfo = nil;
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
