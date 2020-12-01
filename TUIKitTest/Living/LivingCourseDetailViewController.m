//
//  LivingCourseDetailViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "LivingCourseDetailViewController.h"
#import "CustomChatViewController.h"
#import "LivingCourseDetailTableViewCell.h"
#define kLivingCourseDetailTableViewCell @"LivingCourseDetailTableViewCell"
#import "LivingTeacherIntroTableViewCell.h"
#define kLivingTeacherIntroTableViewCell @"LivingTeacherIntroTableViewCell"
#import "MainOpenVIPCardTableViewCell.h"
#define kMainOpenVIPCardTableViewCell @"MainOpenVIPCardTableViewCell"
#import "MainVipCardListViewController.h"
#import "TeacherDetailViewController.h"
#import "ShareAndPaySelectView.h"
#import "MainVipCardListViewController.h"
#import "ShareClickView.h"
#import "LivingSecretViewController.h"
#import "AssociationListTableViewCell.h"
#define kAssociationListTableViewCell @"AssociationListTableViewCell"
#import "JoinAssociationViewController.h"
#import "BuyCourseSendViewController.h"

typedef enum : NSUInteger {
    topic_type_free = 1,
    topic_type_buy,
    topic_type_secret,
} Topic_type;

typedef enum : NSUInteger {
    Topic_style_audio = 1,
    Topic_style_living,
    Topic_style_video,
    Topic_style_sanfang,
} Topic_style;

@interface LivingCourseDetailViewController ()<UserModule_CourseDetailProtocol,UITableViewDelegate, UITableViewDataSource,UserModule_PayOrderProtocol,WKUIDelegate,WKNavigationDelegate,UserModule_MockVIPBuy,UserModule_MockPartnerBuy,UserModule_PayOrderByCoinProtocol>

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)NSDictionary * courseDetailInfo;
@property (nonatomic, strong)CategoryView * storeView;
@property (nonatomic, strong)UIButton *playBackBtn;
@property (nonatomic, assign)Topic_type topic_type; // 收费类型 1.免费 2.收费 3.加密
@property (nonatomic, assign)Topic_style topic_style;// 课程类型 1.音频直播 2.直播 3.录播 4.三方直播

@property (nonatomic, assign)PayStateType payStateType; // 支付类型

@property (nonatomic, strong)ShareClickView * shareView;
@property (nonatomic, assign)BOOL isWechat;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSString * psd; //直播间验证密码

@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, assign)CGFloat webViewHeight;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong)NSMutableArray * urlDictsArray;
@property (nonatomic, strong)NSString * detailHtml;

@property (nonatomic, strong)NSDictionary * subscribInfo;// 预约信息

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)NSMutableArray * communities;
@end

@implementation LivingCourseDetailViewController

- (NSMutableArray *)communities
{
    if (!_communities) {
        _communities = [NSMutableArray array];
    }
    return _communities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self navigationViewSetup];
    [self prepareUI];
    
    self.psd = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giveAction) name:kNotificationOfSendCourse object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giveAction) name:kNotificationOfSendCourse object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];
}

#pragma mark - pay

- (void)coinBuyAction
{
    [SVProgressHUD show];
    [[UserManager sharedManager]payOrderByCoinWith:@{kUrlName:@"api/applePay/topic",@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]} withNotifiedObject:self];
}

- (void)didRequestPayOrderByCoinSuccessed
{
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfBuyCourseSuccess object:nil];
}

- (void)didRequestPayOrderByCoinFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
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
        [SVProgressHUD show];
        self.isWechat = YES;
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/topic",@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]],@"pay_type":@"wechat"} withNotifiedObject:self];
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_zhifubPay)
    {
        self.isWechat = NO;
        NSLog(@"支付宝支付");
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/topic",@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]],@"pay_type":@"alipay"} withNotifiedObject:self];
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_shareFriend)
    {
        
        NSDictionary * shareInfo = [self.courseDetailInfo objectForKey:@"share"];
        UIImage *thumbImage = self.shareImageView.image;
        NSString * urlStr = [UIUtility judgeStr:[shareInfo objectForKey:@"link"]];
        [WXApiRequestHandler sendLinkURL:urlStr
                                 TagName:@""
                                   Title:[UIUtility judgeStr:[shareInfo objectForKey:@"title"]]
                             Description:[UIUtility judgeStr:[shareInfo objectForKey:@"desc"]]
                              ThumbImage:thumbImage
                                 InScene:WXSceneSession];
    }else if (([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_shareCircle))
    {
        NSDictionary * shareInfo = [self.courseDetailInfo objectForKey:@"share"];
        UIImage *thumbImage = self.shareImageView.image;
        NSString * urlStr = [UIUtility judgeStr:[shareInfo objectForKey:@"link"]];
        [WXApiRequestHandler sendLinkURL:urlStr
                                 TagName:@""
                                   Title:[UIUtility judgeStr:[shareInfo objectForKey:@"title"]]
                             Description:[UIUtility judgeStr:[shareInfo objectForKey:@"desc"]]
                              ThumbImage:thumbImage
                                 InScene:WXSceneTimeline];
    }
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
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.info objectForKey:@"title"]];
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

- (void)loadData
{
    [[UserManager sharedManager] getCourseDetailWith:@{@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]],kUrlName:@"api/topic/info",@"include":@"author",@"requestType":@"get"} withNotifiedObject:self];//
    
    [[UserManager sharedManager] didRequestMyVIPCardWithInfo:@{kUrlName:@"api/home/vip"} withNotifiedObject:nil];
    
    // 获取预约状态
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]],kUrlName:@"api/topic/reserveStatus",@"requestType":@"get"} withNotifiedObject:self];
    
    [SVProgressHUD show];
}

- (void)prepareUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LivingCourseDetailTableViewCell class] forCellReuseIdentifier:kLivingCourseDetailTableViewCell];
    [self.tableView registerClass:[LivingTeacherIntroTableViewCell class] forCellReuseIdentifier:kLivingTeacherIntroTableViewCell];
    [self.tableView registerClass:[MainOpenVIPCardTableViewCell class] forCellReuseIdentifier:kMainOpenVIPCardTableViewCell];
    [self.tableView registerClass:[AssociationListTableViewCell class] forCellReuseIdentifier:kAssociationListTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    _playBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBackBtn.frame = CGRectMake(15, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenWidth - 30, 40);
    [_playBackBtn setTitle:@"进入观看" forState:UIControlStateNormal];
    _playBackBtn.backgroundColor = UIColorFromRGB(0x2A75ED);
    _playBackBtn.layer.cornerRadius = _playBackBtn.hd_height / 2;
    _playBackBtn.layer.masksToBounds = YES;
    [_playBackBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_playBackBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBackBtn];
    
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(0, _playBackBtn.hd_y, 60, 40)];
    cateView.pageType = Page_sendCourse;
    cateView.info = @{@"id":@(1)};
    cateView.categoryName = @"赠送好友";
    cateView.categoryCoverUrl = @"main_赠送记录";
    [cateView setupSmallContent];
    [self.view addSubview:cateView];
    self.storeView = cateView;
    self.storeView.hidden = YES;
    
    __weak typeof(self)weakSelf = self;
    self.shareView = [[ShareClickView alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 40, 60, 30)];
    [self.view addSubview:self.shareView];
    self.shareView.shareBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf shareAction];
    };
    
    self.webViewHeight = 0;
    // webview
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - 需要判断加密直播
- (void)resetPayBtn
{
    _topic_type = [[self.courseDetailInfo objectForKey:@"topic_type"] intValue];
    if(_topic_type == topic_type_secret)
    {
        [_playBackBtn setTitle:@"进入观看" forState:UIControlStateNormal];
        self.payStateType = PayStateType_Secret;
        return;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.courseDetailInfo objectForKey:@"title"]];
    
    if ([[self.courseDetailInfo objectForKey:@"give"] boolValue]) {
        self.storeView.hidden = NO;
        self.playBackBtn.frame = CGRectMake(CGRectGetMaxX(_storeView.frame), kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 45, kScreenWidth - 15 - 60, 40);
    }
    
    if ([self.courseDetailInfo objectForKey:@"purchase"]) {
        
        NSDictionary * purchase = [self.courseDetailInfo objectForKey:@"purchase"];
        NSString * type = [purchase objectForKey:@"type"];
        if ([type isEqualToString:@"free"]) {
            [_playBackBtn setTitle:@"进入观看" forState:UIControlStateNormal];
            self.payStateType = PayStateType_free;
        }else if ([type isEqualToString:@"purchased"])
        {
            [_playBackBtn setTitle:@"已购买" forState:UIControlStateNormal];
            self.payStateType = PayStateType_free;
        }else if ([type isEqualToString:@"vip-free"])
        {
            [_playBackBtn setTitle:@"会员免费观看" forState:UIControlStateNormal];
            self.payStateType = PayStateType_free;
        }else if ([type isEqualToString:@"plain"])
        {
            NSDictionary * info = [purchase objectForKey:@"info"];
            [_playBackBtn setTitle:[NSString stringWithFormat:@"%@%@", [SoftManager shareSoftManager].coinName, [info objectForKey:@"money"]] forState:UIControlStateNormal];
            self.payStateType = PayStateType_buy;
        }
        else if ([type isEqualToString:@"vip-discount"])
        {
            NSDictionary * info = [purchase objectForKey:@"info"];
            float price = [[info objectForKey:@"money"] floatValue] * [[info objectForKey:@"discount"] floatValue];
            [_playBackBtn setTitle:[NSString stringWithFormat:@"%@%.2f", [SoftManager shareSoftManager].coinName, price] forState:UIControlStateNormal];
            self.payStateType = PayStateType_buy;
        }
        else if ([type isEqualToString:@"need_vip"])
        {
            [_playBackBtn setTitle:@"开通会员免费观看" forState:UIControlStateNormal];
            self.payStateType = PayStateType_Vip;
        }else
        {
            [_playBackBtn setTitle:@"进入观看" forState:UIControlStateNormal];
            self.payStateType = PayStateType_free;
        }
        
        return;
    }
    _topic_style = [[self.courseDetailInfo objectForKey:@"topic_style"] intValue];
    
    _payStateType = _topic_type;
    
    if (_topic_type != 1) {
        [_playBackBtn setTitle:[NSString stringWithFormat:@"%@%@购买",[SoftManager shareSoftManager].coinName, [self.courseDetailInfo objectForKey:@"pay_paymoney"]] forState:UIControlStateNormal];
    }else
    {
        [_playBackBtn setTitle:@"进入观看" forState:UIControlStateNormal];
    }
    
}

- (void)giveAction
{
    BuyCourseSendViewController * vc = [[BuyCourseSendViewController alloc]init];
    vc.info = self.courseDetailInfo;
    vc.isArticle = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playAction
{
    __weak typeof(self)weakSelf = self;
    switch (_payStateType) {
        case PayStateType_free:
        {
            [self getChatRoomInfo];
        }
            break;
        case PayStateType_buy:
        {
            NSLog(@"购买");
            
            
            if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue]) {
                ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:NO];
                UIWindow * window = [UIApplication sharedApplication].delegate.window;
                [window addSubview:payView];
                self.payView = payView;
            }else
            {
                [self coinBuyAction];
            }
        }
            break;
        case PayStateType_Vip:
        {
            if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue]) {
                
                MainVipCardListViewController * vc = [[MainVipCardListViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                
            }
        }
            break;
        case PayStateType_Secret:
        {
            // 判断输入密码时间间隔是否在4h以内
            if ([self verifyLivingPsdExpire]) {
                [weakSelf getChatRoomInfo];
                return;
            }
            
            LivingSecretViewController * vc = [[LivingSecretViewController alloc]init];
            vc.info = self.courseDetailInfo;
            vc.verifyPsdSuccessBlock = ^(NSDictionary * _Nonnull info) {
                weakSelf.psd = [info objectForKey:@"psd"];
                [weakSelf getChatRoomInfo];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)verifyLivingPsdExpire
{
    return NO;
    long  oldStr = [[[NSUserDefaults standardUserDefaults] objectForKey:kVerifyLivingPsdTime] longLongValue];
    long  newStr = [[UIUtility getCurrentTimestamp] longLongValue];
    
    NSTimeInterval balance = newStr - oldStr ;
    if (balance <  4 * 60 * 60) {
        return YES;
    }
    
    return NO;
}


#pragma mark - share
- (void)shareAction
{
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:YES];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
    self.payView = payView;
}


#pragma mark - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        if ([[[self.courseDetailInfo objectForKey:@"author"] allKeys] count] > 0)
        {
            return 1;
        }
        return 0;
    }else if (section == 2)
    {
        return 1;
    }else if (section == 3)
    {
        return self.communities.count;
    }
    
    
    
    if (self.courseDetailInfo) {
        if ([[self.courseDetailInfo objectForKey:@"topic_type"] intValue] == 1) {
            return 1;
        }
    }
    if([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue])
    {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == 0 && indexPath.section == 0) {
        LivingCourseDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kLivingCourseDetailTableViewCell forIndexPath:indexPath];
        [cell refreshUIWithInfo:self.courseDetailInfo];
        cell.subscribBlock = ^(BOOL isSubscrib) {
            [SVProgressHUD show];
            if (isSubscrib) {
                [[UserManager sharedManager] didRequestMockPartnerBuyWithInfo:@{kUrlName:@"api/topic/unreserve",@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]} withNotifiedObject:weakSelf];
            }else
            {
                [[UserManager sharedManager] didRequestMockPartnerBuyWithInfo:@{kUrlName:@"api/topic/reserve",@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]} withNotifiedObject:weakSelf];
            }
        };
        return cell;
    }else if (indexPath.row == 1 && indexPath.section == 0)
    {
        MainOpenVIPCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMainOpenVIPCardTableViewCell forIndexPath:indexPath];
        [cell resetUIWithInfo:@{}];
        return cell;
    }
    if (indexPath.section == 1) {
        LivingTeacherIntroTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kLivingTeacherIntroTableViewCell forIndexPath:indexPath];
        if (self.courseDetailInfo) {
            [cell refreshUIWithInfo:[self.courseDetailInfo objectForKey:@"author"]];
        }
        return cell;
    }
    if (indexPath.section == 3) {
        AssociationListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationListTableViewCell forIndexPath:indexPath];
        [cell resetCellContent:self.communities[indexPath.row]];
        [cell resetTitle];
        cell.cancelOrderLivingCourseBlock = ^(NSDictionary * _Nonnull info) {
            JoinAssociationViewController * vc = [[JoinAssociationViewController alloc]init];
            vc.infoDic = weakSelf.communities[indexPath.row];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    [cell.contentView addSubview:self.webView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0){
        if (self.courseDetailInfo) {
            NSString * titleStr = [self.courseDetailInfo objectForKey:@"title"];
            CGFloat height = [titleStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_18} context:nil].size.height;
            
            return tableView.hd_width / 2 + 10 + height + 10 + 15 + 10 + 1 + 45 ;
        }
    }else if (indexPath.row == 1 && indexPath.section == 0)
    {
        return 60;
    }else if (indexPath.section == 3)
    {
        return 80;
    }
    
    if (indexPath.section == 1) {
        return 74;
    }
    
    return _webViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
        return 0;
    }
    if (section == 1) {
        if ([[[self.courseDetailInfo objectForKey:@"author"] allKeys] count] == 0)
        {
            return 0;
        }
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3)
    {
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        headView.backgroundColor = UIColorFromRGB(0xffffff);
        
        UILabel * titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 50)];
        titleLb.text = @"相关社群";
        titleLb.textColor = UIColorFromRGB(0x111111);
        titleLb.font = [UIFont boldSystemFontOfSize:16];
        [headView addSubview:titleLb];
        
        return headView;
    }
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 40)];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 15)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x333333);
    label.text = @"课程详情";
    [headView addSubview:label];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 40;
    }
    else if (section == 3)
    {
        if (self.communities.count > 0) {
            return 50;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        MainVipCardListViewController * vc = [[MainVipCardListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        NSDictionary * teacherInfo = [self.courseDetailInfo objectForKey:@"author"];
        TeacherDetailViewController * vc = [[TeacherDetailViewController alloc]init];
        vc.info = teacherInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didCourseDetailSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.courseDetailInfo = [[UserManager sharedManager] getCourseDetailInfo];
    self.communities = [[self.courseDetailInfo objectForKey:@"communities"] objectForKey:@"data"];
    [self resetPayBtn];
    
    [self getShareInfo:self.courseDetailInfo];
    
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    
    NSString * htmlStr = [UIUtility judgeStr:[self.courseDetailInfo objectForKey:@"topic_desc"]];
    
    [self testLoadHtmlImage:[headerString stringByAppendingString:[htmlStr stringByDecodingHTMLEntities]]];
    
    [self.tableView reloadData];
    NSLog(@"self.courseDetailInfo = %@", self.courseDetailInfo);
}

- (void)getShareInfo:(NSDictionary *)info
{
    NSDictionary * shareInfo = [info objectForKey:@"share"];
    self.shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:self.shareImageView];
    self.shareImageView.hidden = YES;
    
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[shareInfo objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
}

- (void)didCourseDetailFailed:(NSString *)failedInfo
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
    self.subscribInfo = [[UserManager sharedManager] getVIPBuyInfo];
    [self.tableView reloadData];
}

- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestMockPartnerBuySuccessed
{
    [SVProgressHUD dismiss];
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]],kUrlName:@"api/topic/reserveStatus",@"requestType":@"get"} withNotifiedObject:self];
}

- (void)didRequestMockPartnerBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)getChatRoomInfo
{
    __block NSDictionary * roomDetailInfo;
    __block NSDictionary * roomIdInfo;
    
    
    [SVProgressHUD show];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    // 请求用户基本信息
    dispatch_group_async(group, dispatch_queue_create("ChatRoomInfo", DISPATCH_QUEUE_CONCURRENT), ^{
        // 第一个请求；
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        NSString * sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
        
        NSDictionary * paramete = @{@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]};
        NSString * aesStr = [UIUtility getAES_Str:paramete];
        NSString * propertyStr = [UIUtility getGetRequest_Str:paramete];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",kRootUrl,@"api/topicLive/imSetting"];
        
        NSDictionary * headDic = @{@"token":[NSString stringWithFormat:@"%@", aesStr]};
        if (sessionId) {
            if (sessionId.length > 0) {
                sessionId = [NSString stringWithFormat:@"PHPSESSID=%@", sessionId];
                
                headDic = @{@"token":[NSString stringWithFormat:@"%@", aesStr],@"Cookie":sessionId};
            }
        }
        urlString = [urlString stringByAppendingFormat:@"?%@", propertyStr];
        [session GET:urlString parameters:nil headers:headDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"responseObject = %@", responseObject);
            int result = [[responseObject objectForKey:@"code"] intValue];
                if (result == 0) {
                    // 请求成功
                    roomIdInfo = [responseObject objectForKey:@"data"];
                }else if (result == 1401)
                {
                    // 登陆失效，从新登陆
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
                }
                else{
                    // 请求错误
                    [SVProgressHUD showErrorWithStatus:[UIUtility judgeStr:[responseObject objectForKey:@"msg"]]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    
    // 请求直播室信息
    dispatch_group_async(group, dispatch_queue_create("ChatRoomInfo", DISPATCH_QUEUE_CONCURRENT), ^{
        // 第二个请求;
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        NSString * sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
        
        NSMutableDictionary * paramete = [[NSMutableDictionary alloc]initWithDictionary:@{@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]],@"pass":@""}];
        
        // 加密类型的直播课需要添加 pass 参数
        if (self.payStateType == PayStateType_Secret) {
            NSString * psd = [[NSUserDefaults standardUserDefaults] objectForKey:kVerifyLivingPsd];
            if (psd.length > 0) {
                [paramete setObject:self.psd forKey:@"pass"];
            }
        }
        
        NSString * aesStr = [UIUtility getAES_Str:paramete];
        NSString * propertyStr = [UIUtility getGetRequest_Str:paramete];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",kRootUrl,@"api/topiclive/home"];
        
        NSDictionary * headDic = @{@"token":[NSString stringWithFormat:@"%@", aesStr]};
        if (sessionId) {
            if (sessionId.length > 0) {
                sessionId = [NSString stringWithFormat:@"PHPSESSID=%@", sessionId];
                
                headDic = @{@"token":[NSString stringWithFormat:@"%@", aesStr],@"Cookie":sessionId};
            }
        }
        urlString = [urlString stringByAppendingFormat:@"?%@", propertyStr];
        [session GET:urlString parameters:nil headers:headDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"responseObject = %@", responseObject);
            int result = [[responseObject objectForKey:@"code"] intValue];
                if (result == 0) {
                    // 请求成功
                    roomDetailInfo = [responseObject objectForKey:@"data"];
                }else if (result == 1401)
                {
                    // 登陆失效，从新登陆
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
                }
                else{
                    // 请求错误
                    [SVProgressHUD showErrorWithStatus:[UIUtility judgeStr:[responseObject objectForKey:@"msg"]]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 请求完毕
        if (roomDetailInfo && roomIdInfo) {
//            NSLog(@"roomDetailInfo = %@", roomDetailInfo);
//            NSLog(@"roomIdInfo = %@", roomIdInfo);
            V2TIMUserFullInfo * profile = [[V2TIMUserFullInfo alloc]init];
            profile.selfSignature = [roomIdInfo objectForKey:@"user_sig"];
            profile.nickName = [roomIdInfo objectForKey:@"identifier_nickname"];
            profile.faceURL = [[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl];
            
            [[TUIKit sharedInstance] login:[UIUtility judgeStr:[roomIdInfo objectForKey:@"identifier"]] userSig:[UIUtility judgeStr:[roomIdInfo objectForKey:@"user_sig"]] succ:^{
                
                // 登录成功,设置个人信息
                [[V2TIMManager sharedInstance] setSelfInfo:profile succ:^{
                    
                    // 加入群组
                    [[V2TIMManager sharedInstance] joinGroup:[roomIdInfo objectForKey:@"room_id"] msg:@"" succ:^{
                        
                        [SVProgressHUD dismiss];
                        
                        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
                        data.groupID = [roomIdInfo objectForKey:@"room_id"];  // 如果是群会话，传入对应的群 ID
    //                    data.userID = [roomIdInfo objectForKey:@"room_id"];
                        CustomChatViewController *chatRoomVC = [[CustomChatViewController alloc]init];
                        chatRoomVC.conversationData = data;
                        chatRoomVC.videoInfo = roomDetailInfo;
                        
                        NSDictionary * videoInfo = [[roomDetailInfo objectForKey:@"video"] objectForKey:@"data"];
                        NSDictionary * playBackInfo = [roomDetailInfo objectForKey:@"play_back"];
                        NSDictionary * chatInfo = [[roomDetailInfo objectForKey:@"setting"] objectForKey:@"chat"];
                        if ([UserManager sharedManager].tencentID.length == 0) {
                            [UserManager sharedManager].tencentID = [NSString stringWithFormat:@"%@", [chatInfo objectForKey:@"app_id"]];
                        }
                        
                        if ([[roomDetailInfo objectForKey:@"status"] intValue] == 1) {
                            chatRoomVC.playUrl = [NSString stringWithFormat:@"%@", [videoInfo objectForKey:@"url_flv"]];
                        }else if ([[roomDetailInfo objectForKey:@"status"] intValue] == 3)
                        {
                            chatRoomVC.isPlayBack = [[roomDetailInfo objectForKey:@"is_play_back"] boolValue];
                            
                            if (playBackInfo == nil || [playBackInfo isKindOfClass:[NSNull class]]) {
                                chatRoomVC.playUrl = @"";
                            }else
                            {
                                if ([[playBackInfo objectForKey:@"file_type"] isEqualToString:@"url"]) {
                                    chatRoomVC.playUrl = [NSString stringWithFormat:@"%@", [playBackInfo objectForKey:@"file_id"]];
                                }else
                                {
                                    chatRoomVC.tencentPlayID = [NSString stringWithFormat:@"%@", [playBackInfo objectForKey:@"file_id"]];
                                }
                            }
                        }
                        NSLog(@"******** jiazaizhong ****** 2");
                        chatRoomVC.groupId = [roomIdInfo objectForKey:@"room_id"];
                        chatRoomVC.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self presentViewController:chatRoomVC animated:YES completion:nil];
                        
                    } fail:^(int code, NSString *desc) {
                        [SVProgressHUD dismiss];
                        NSLog(@"joinchatroom setSelfInfo fail %d  %@", code, desc);
                    }];
                    
                } fail:^(int code, NSString *desc) {
                    [SVProgressHUD dismiss];
                    NSLog(@"V2TIMManager setSelfInfo fail %d  %@", code, desc);
                }];
            } fail:^(int code, NSString *msg) {
                [SVProgressHUD dismiss];
                NSLog(@"imlogin fail %d  %@", code, msg);
            }];
            
        }else
        {
            return;
        }
        
    });
    
    
    NSLog(@"******** jiazaizhong ****** 1");
    
}



#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (_webView.scrollView.contentSize.height > self.webViewHeight || _webView.scrollView.contentSize.height == 0) {
            _webViewHeight = _webView.scrollView.contentSize.height;
            _webView.frame = CGRectMake(0, 0, kScreenWidth, _webViewHeight);
            [_tableView reloadData];
        }
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
//    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable Result, NSError * _Nullable error) {
//        NSString * heightStr = [NSString stringWithFormat:@"%@", Result];
//        CGFloat height = heightStr.floatValue + 15;
//        self.webView.frame = CGRectMake(0, 0, kScreenWidth, height);
//        _webViewHeight = height;
//        [self.tableView reloadData];
//    }];
//
//    for(UIView * view in webView.subviews)
//    {
//        NSLog(@"%@", [view class]);
//        if ([view isKindOfClass:[NSClassFromString(@"WKScrollView") class]]) {
//            UIScrollView * scrollView = (UIScrollView *)view;
//            CGFloat height = scrollView.contentSize.height;
//            _webViewHeight = height;
//            self.webView.frame = CGRectMake(0, 0, kScreenWidth, height);
//            [self.tableView reloadData];
//        }
//
//    }
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //    decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    
//    NSMutableURLRequest *mutableRequest = [navigationAction.request mutableCopy];
//
//    NSDictionary *requestHeaders = navigationAction.request.allHTTPHeaderFields;
//
//    //我们项目使用的token同步的，cookie的话类似
//        if (requestHeaders[@"Referer"]) {
//            decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
//        } else {
//             //这里添加请求头，把需要的都添加进来
//            [mutableRequest setValue:@"https://h5.luezhi.com" forHTTPHeaderField:@"Referer"];
//                [webView loadRequest:mutableRequest];
//
//                decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
//            }
//
//    return;
    if([navigationAction.request.URL.absoluteString containsString:@"http"])
    {
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }else
    {
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

- (void)testLoadHtmlImage:(NSString *)html
{
    [self.urlDictsArray removeAllObjects];
    self.detailHtml = html;
    
    // @"<img.*src[^>]*/>"
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img.*?src[^>]*/>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
    
  //  NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
      NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"badge"];
  BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
      
      
    for (NSTextCheckingResult *item in result) {
      NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
      
      NSArray *tmpArray = nil;
      if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
        tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
      } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
        tmpArray = [imgHtml componentsSeparatedByString:@"src="];
      }
      
      if (tmpArray.count >= 2) {
        NSString *src = tmpArray[1];
        
        NSUInteger loc = [src rangeOfString:@"\""].location;
        if (loc != NSNotFound) {
          src = [src substringToIndex:loc];
          
          NSLog(@"正确解析出来的SRC为：%@", src);
          if (src.length > 0) {
            NSString *localPath = [docPath stringByAppendingPathComponent:[src MD5]];
  //            BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:nil];
            // 先将链接取个本地名字，且获取完整路径
            [urlDicts setObject:localPath forKey:src];
              
              [self.urlDictsArray addObject:urlDicts];
          }
        }
      }
    }
    
    // 遍历所有的URL，替换成本地的URL，并异步获取图片
    for (NSString *src in urlDicts.allKeys) {
      NSString *localPath = [urlDicts objectForKey:src];
        
      //根据本地路径获取图片
      UIImage *_image = [UIImage imageWithContentsOfFile:localPath];
      
      //把图片进行base64
      NSString * jpg = [self htmlForJPGImage:_image];
      //然后在替换scr
      html = [html stringByReplacingOccurrencesOfString:src withString:jpg];
        
      // 如果已经缓存过，就不需要重复加载了。
      if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        [self downloadImageWithUrl:src];
      }
    }
    
//    NSLog(@"%@", html);
    
    [self.webView loadHTMLString:html baseURL:nil];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)downloadImageWithUrl:(NSString *)src {
  // 注意：这里并没有写专门下载图片的代码，就直接使用了AFN的扩展，只是为了省麻烦而已。
  UIImageView *imgView = [[UIImageView alloc] init];
    imgView.hidden = YES;
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:imgView];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSData *data = UIImagePNGRepresentation(image);
            NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"badge"];
            BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSString *localPath = [docPath stringByAppendingPathComponent:[src MD5]];
            
            if (![data writeToFile:localPath atomically:NO]) {
                NSLog(@"写入本地失败：%@", src);
            }else
            {
                for (NSDictionary * urlDic in self.urlDictsArray) {
                    if ([urlDic.allKeys containsObject:src]) {
                        NSString * jpg = [self htmlForJPGImage:image];
                        //然后在替换scr
                        self.detailHtml = [self.detailHtml stringByReplacingOccurrencesOfString:src withString:jpg];
                        [self.webView loadHTMLString:self.detailHtml baseURL:nil];
                    }
                }
            }
        }
    }];
  
  if (self.imageViews == nil) {
    self.imageViews = [[NSMutableArray alloc] init];
  }
  [self.imageViews addObject:imgView];
}


- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return imageSource;

}



- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"界面销毁");
}

@end
