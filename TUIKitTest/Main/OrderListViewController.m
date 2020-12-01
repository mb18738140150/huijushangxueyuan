//
//  OrderListViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/4.
//

#import "OrderListViewController.h"
#import "SearchAndCategoryView.h"
#import "ShoppingCarListTableViewCell.h"
#define kShoppingCarListTableViewCellID @"ShoppingCarListTableViewCellID"
#import "OrderBottomTableViewCell.h"
#define kOrderBottomTableViewCell @"OrderBottomTableViewCell"
#import "ShareAndPaySelectView.h"
#import "CommodityDetailViewController.h"
#import "OrderDetailViewController.h"

@interface OrderListViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_OrderListProtocol,UserModule_PayOrderProtocol,UserModule_DeleteShoppingCarProtocol>
@property (nonatomic, strong)ZWMSegmentView * courseSegment;
@property (nonatomic, strong)SearchAndCategoryView * topView;

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *pageIndexArray;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, assign)int page;

@property (nonatomic, strong)NSMutableArray * allOrderArray;
@property (nonatomic, strong)NSMutableArray * noPayOrderArray;
@property (nonatomic, strong)NSMutableArray * noReviceOrderArray;
@property (nonatomic, strong)NSMutableArray * complateOrderArray;

@property (nonatomic, strong)NSMutableArray * itemArray;
@property (nonatomic, assign)BOOL isWechat;
@property (nonatomic, strong)NSDictionary * curtrentSelectOrderInfo;
@property (nonatomic, strong)ShareAndPaySelectView * payView;


@end

@implementation OrderListViewController

- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadCateGory];
    [self navigationViewSetup];
    self.page = 1;
    [SVProgressHUD show];
    [self prepareUI];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];
}

- (void)loadCateGory
{
    self.categoryArray = @[@{@"name":@"全部",@"type":@"all",@"id":@0},@{@"name":@"待付款",@"type":@"one",@"id":@1},@{@"name":@"待收货",@"type":@"two",@"id":@2},@{@"name":@"已完成",@"type":@"three",@"id":@3}];
    self.pageIndexArray = [NSMutableArray array];
    for (int i = 0; i< self.categoryArray.count; i++) {
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setObject:@"1" forKey:kPageNo];
        [info setObject:@"10" forKey:kPageSize];
        [info setObject:[NSMutableArray array] forKey:kDataArray];
        
        [self.pageIndexArray addObject:info];
    }
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"订单列表";
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareUI
{
    self.topView = [[SearchAndCategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    [self.view addSubview:self.topView];
    __weak typeof(self)weakSelf = self;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView registerClass:[ShoppingCarListTableViewCell class] forCellReuseIdentifier:kShoppingCarListTableViewCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableView registerClass:[OrderBottomTableViewCell class] forCellReuseIdentifier:kOrderBottomTableViewCell];
    [self.tableView registerClass:[LoadFailedTableViewCell class] forCellReuseIdentifier:kFailedCellID];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
    
    [self.topView refreshWith:self.categoryArray];
    [self.topView hideSearchView];
    self.courseSegment = self.topView.zixunSegment;
    
    [self.courseSegment selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
        NSLog(@"%ld *** %@", index,button.titleLabel.text);
        weakSelf.cateId = index;
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
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    }];
    
    int index = 0;
    for (NSDictionary * info in self.categoryArray) {
        if (self.cateId == [[info objectForKey:@"id"] intValue]) {
            index = [self.categoryArray indexOfObject:info];
            break;
        }
    }
    
    [self.courseSegment setSelectedAtIndex:index];
    [self requestDataWith:self.courseSegment.index];
    
        
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

- (void)requestDataWith:(NSUInteger )index
{
    NSDictionary * cateInfo = [self.categoryArray objectAtIndex:index];
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    self.itemArray = mArray;
//completed:已完成 wait-payment:待付款 wait-take-over:待收获 all:所有 默认是 all
    [SVProgressHUD show];
    NSString * type = @"";
    switch (index) {
        case 0:
        {
            type = @"all";
        }
            break;
        case 1:
        {
            type = @"wait-payment";
        }
            break;
        case 2:
        {
            type = @"wait-take-over";
        }
            break;
        case 3:
        {
            type = @"completed";
        }
            break;
            
        default:
            break;
    }
    [[UserManager sharedManager] didRequestOrderListWithCourseInfo:@{kUrlName:@"api/shop/order/lists",kRequestType:@"get",@"page":@(pageNo),@"type":type} withNotifiedObject:self];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemArray.count == 0 ? 1 : self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.itemArray.count == 0) {
        return 1;
    }
    NSDictionary * orderInfo = [self.itemArray objectAtIndex:section];
    NSArray * commodityArray = [[orderInfo objectForKey:@"commodities"] objectForKey:@"data"];
    return commodityArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemArray.count == 0) {
        LoadFailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFailedCellID forIndexPath:indexPath];
        [cell refreshUIWith:@{}];
        
        return cell;
    }
    
    NSDictionary * orderInfo = [self.itemArray objectAtIndex:indexPath.section];
    NSArray * commodityArray = [[orderInfo objectForKey:@"commodities"] objectForKey:@"data"];
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        cell.backgroundColor = UIColorFromRGB(0xf5f5f5);
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 40)];
        backView.backgroundColor = UIColorFromRGB(0xffffff);
        [cell.contentView addSubview:backView];
        
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer * layer = [[CAShapeLayer alloc]init];
        layer.frame = backView.bounds;
        layer.path = path.CGPath;
        [backView.layer setMask:layer];
        
        UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, backView.hd_width - 20, backView.hd_height)];
        titleLB.text = [NSString stringWithFormat:@"%@", [orderInfo objectForKey:@"pay_time"]];
        titleLB.font = kMainFont_12;
        titleLB.textColor = UIColorFromRGB(333333);
        [backView addSubview:titleLB];
        
        UILabel * stateLB = [[UILabel alloc]initWithFrame:titleLB.frame];
        [backView addSubview:stateLB];
        stateLB.text = [self getOrderStateStr:orderInfo];
        stateLB.font = kMainFont;
        stateLB.textAlignment = NSTextAlignmentRight;
        stateLB.textColor = kCommonMainBlueColor;
        
        return cell;
    }
    if (indexPath.row == commodityArray.count + 1) {
        OrderBottomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kOrderBottomTableViewCell forIndexPath:indexPath];
        [cell refreshUIWith:orderInfo];
        cell.deleteBlock = ^(NSDictionary * _Nonnull info) {
            weakSelf.curtrentSelectOrderInfo = info;
            [weakSelf deleteOrder:info];
        };
        cell.buyBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf pushOrderDetailVC:info];
        };
        cell.detailBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf pushOrderDetailVC:info];
        };
        
        return cell;
    }
    
    ShoppingCarListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kShoppingCarListTableViewCellID forIndexPath:indexPath];
    [cell refreshOrderCellWith:commodityArray[indexPath.row - 1]];
    return cell;
}

- (void)pushOrderDetailVC:(NSDictionary *)info
{
    __weak typeof(self)weakSelf = self;
    OrderDetailViewController * vc = [[OrderDetailViewController alloc]init];
    vc.info = info;
    vc.backBlock = ^(BOOL isRefresh) {
        [weakSelf requestDataWith:weakSelf.courseSegment.index];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemArray.count == 0) {
        return tableView.hd_height;
    }
    
    NSDictionary * orderInfo = [self.itemArray objectAtIndex:indexPath.section];
    NSArray * commodityArray = [[orderInfo objectForKey:@"commodities"] objectForKey:@"data"];
    
    if (indexPath.row == 0) {
        return 40;
    }
    if (indexPath.row == commodityArray.count + 1) {
        return 110;
    }
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemArray.count == 0) {
        return;
    }
    NSDictionary * orderInfo = [self.itemArray objectAtIndex:indexPath.section];
    NSArray * commodityArray = [[orderInfo objectForKey:@"commodities"] objectForKey:@"data"];
    if (indexPath.row == 0) {
        return ;
    }
    if (indexPath.row == commodityArray.count + 1) {
        return ;
    }
    CommodityDetailViewController * vc = [[CommodityDetailViewController alloc]init];
    vc.info = commodityArray[indexPath.row - 1];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - delete
- (void)deleteOrder:(NSDictionary *)info
{
    [SVProgressHUD dismiss];
    [[UserManager sharedManager] didRequestDeleteShoppingCarWith:@{kUrlName:@"api/shop/order/delete",@"order_id":[NSString stringWithFormat:@"%@", [self.curtrentSelectOrderInfo objectForKey:@"id"]]} withNotifiedObject:self];
}

- (void)didRequestDeleteShoppingCarSuccessed
{
    self.curtrentSelectOrderInfo = nil;
    [SVProgressHUD dismiss];
    [self requestDataWith:self.courseSegment.index];
}

- (void)didRequestDeleteShoppingCarFailed:(NSString *)failedInfo
{
    self.curtrentSelectOrderInfo = nil;
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
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
    [self requestDataWith:self.courseSegment.index];
}

- (void)payClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [self.payView removeFromSuperview];
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_wechatPay) {
        NSLog(@"微信支付");
        self.isWechat = YES;
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/shop/order/wechat",@"order_id":[NSString stringWithFormat:@"%@", [self.curtrentSelectOrderInfo objectForKey:@"id"]]} withNotifiedObject:self];
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_zhifubPay)
    {
        self.isWechat = NO;
        NSLog(@"支付宝支付");
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/shop/order/alipay",@"order_id":[NSString stringWithFormat:@"%@", [self.curtrentSelectOrderInfo objectForKey:@"id"]]} withNotifiedObject:self];
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


- (NSString *)getOrderStateStr:(NSDictionary *)info
{
    // 支付状态 0:待支付 1:支付成功
    // 订单状态 0:待发货 1:已发货 2:已到货 3:退货
    
    /*
     wait-payment    待付款
     completed    已完成
     refund    已退款
     wait-deliver-goods    待发货
     wait-take-over    待收货
     wait-pick-up    待取货
     shipped    已发货
     return-good    退货
     */
    
    if ([[info objectForKey:@"status"] isEqualToString:@"wait-payment"]) {
        return @"待支付";
    }else if([[info objectForKey:@"status"] isEqualToString:@"completed"])
    {
        return @"已完成";
    }else if([[info objectForKey:@"status"] isEqualToString:@"refund"])
    {
        return @"已退款";
    }else if([[info objectForKey:@"status"] isEqualToString:@"return-good"])
    {
        return @"退货";
    }else if([[info objectForKey:@"status"] isEqualToString:@"wait-deliver-goods"])
    {
        return @"待发货";
    }else if([[info objectForKey:@"status"] isEqualToString:@"wait-take-over"])
    {
        return @"待收货";
    }else if([[info objectForKey:@"status"] isEqualToString:@"shipped"])
    {
        return @"已发货";
    }
    else if([[info objectForKey:@"status"] isEqualToString:@"wait-pick-up"])
    {
        return @"待取货";
    }
    
    return @"";
}

- (void)didRequestOrderListSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:self.courseSegment.index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    if(pageNo == 1)
    {
        [mArray removeAllObjects];
    }
    for (NSDictionary * info in [[UserManager sharedManager] getMyOrderList]) {
        [mArray addObject:info];
    }
    
    if ([[[UserManager sharedManager] getMyOrderList] count] == 0) {
        
        if (pageNo > 1) {
            pageNo--;
            [pageNoInfo setObject:@(pageNo) forKey:kPageNo];
        }
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    self.itemArray = mArray;
    [self.tableView reloadData];
}

- (void)didRequestOrderListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


@end
