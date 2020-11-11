//
//  PresentDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "BuyCourseSendViewController.h"
#import "BuySuccessAndPresentViewController.h"
#import "BuyCourseSendTableViewCell.h"
#define kBuyCourseSendTableViewCell @"BuyCourseSendTableViewCell"

@interface BuyCourseSendViewController()<UITableViewDelegate, UITableViewDataSource,UserModule_SecondCategoryProtocol,UserModule_CategoryCourseProtocol,UserModule_MockVIPBuy,UserModule_CreateOrderProtocol>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, assign)int count;
@property (nonatomic, assign)BOOL isWechat;
@property (nonatomic, strong)ShareAndPaySelectView * payView;
@end

@implementation BuyCourseSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.count = 1;
    [self navigationViewSetup];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"赠送好友";
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableView registerClass:[BuyCourseSendTableViewCell class] forCellReuseIdentifier:kBuyCourseSendTableViewCell];

    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView reloadData];
    
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(10, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenWidth - 20, 40);
    sendBtn.backgroundColor = kCommonMainBlueColor;
    sendBtn.layer.cornerRadius = 5;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    sendBtn.titleLabel.font = kMainFont;
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:sendBtn];
    
}


#pragma mark - request

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        BuyCourseSendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kBuyCourseSendTableViewCell forIndexPath:indexPath];
        [cell refreshUWithInfo:self.info];
        cell.countBlock = ^(int count) {
            weakSelf.count = count;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [cell.contentView removeAllSubviews];
    
    UIView * backView= [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, cell.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [cell.contentView addSubview:backView];
    
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, backView.hd_width - 20, 20)];
    label1.text = [NSString stringWithFormat:@"费用明细：使用原价：￥%.2fx%d=￥%.2f", [[self.info objectForKey:@"pay_money"] floatValue], self.count, [[self.info objectForKey:@"pay_money"] floatValue] * self.count];
    label1.textColor = UIColorFromRGB(0x666666);
    label1.font = kMainFont_12;
    [backView addSubview:label1];
    label1.adjustsFontSizeToFitWidth = YES;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, backView.hd_width, 1)];
    line.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:line];
    
    UILabel * maxLB = [[UILabel alloc]initWithFrame:CGRectMake(10 , 10 + CGRectGetMaxY(line.frame), backView.hd_width -  20, 20)];
    maxLB.text = [NSString stringWithFormat:@"应付：%.2f", [[self.info objectForKey:@"pay_money"] floatValue] * self.count];
    maxLB.textColor = UIColorFromRGB(0x333333);
    maxLB.font = kMainFont;
    maxLB.textAlignment = NSTextAlignmentRight;
    [backView addSubview:maxLB];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)sendAction
{
    [self shareAction];
}

#pragma mark - request

- (void)paySuccedsss:(NSNotification *)notification
{
    BuySuccessAndPresentViewController * vc = [[BuySuccessAndPresentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)shareAction
{
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:NO];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
    self.payView = payView;
}
- (void)payClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [self.payView removeFromSuperview];
    
    NSDictionary * addressInfo = [UserManager sharedManager].currentSelectAddressInfo;
    
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_wechatPay) {
        NSLog(@"微信支付");
        self.isWechat = YES;
        [SVProgressHUD show];
        if (self.isArticle) {
            [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{kUrlName:@"api/give/article",@"article_id":[self.info objectForKey:@"id"],@"number":@(self.count),@"pay_type":@"wechat"} withNotifiedObject:self];
        }else
        {
            [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{kUrlName:@"api/give/topic",@"topic_id":[self.info objectForKey:@"id"],@"number":@(self.count),@"pay_type":@"wechat"} withNotifiedObject:self];
        }
        
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_zhifubPay)
    {
        self.isWechat = NO;
        NSLog(@"支付宝支付");
        [SVProgressHUD show];
        
        if (self.isArticle) {
            [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{kUrlName:@"api/give/article",@"article_id":[self.info objectForKey:@"id"],@"number":@(self.count),@"pay_type":@"alipay"} withNotifiedObject:self];
        }else
        {
            [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{kUrlName:@"api/give/topic",@"topic_id":[self.info objectForKey:@"id"],@"number":@(self.count),@"pay_type":@"alipay"} withNotifiedObject:self];
        }
    }
}

- (void)didRequestCreateOrderSuccessed
{
    [SVProgressHUD dismiss];
    NSDictionary * info = [[UserManager sharedManager] getCreateOrderInfo];
    
    if (self.isWechat) {
        [self weichatPay:[info objectForKey:@"wechat"]];
    }else
    {
        [self alipay:[info objectForKey:@"alipay"]];
    }
    
}

- (void)didRequestCreateOrderFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestPayOrderSuccessed
{
    [SVProgressHUD dismiss];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfBuyCourseSuccess object:nil];
        switch (resultStatus.integerValue) {
            case 9000:// 成功
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
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


@end
