//
//  JoinAssociationViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "JoinAssociationViewController.h"
#import "JoinAssociationHeadTableViewCell.h"
#define kJoinAssociationHeadTableViewCell @"JoinAssociationHeadTableViewCell"
#import "AssociationCommentTableViewCell.h"
#define kAssociationCommentTableViewCell @"AssociationCommentTableViewCell"
#import "AssociationDetailViewController.h"
#import "ShareAndPaySelectView.h"
#import "AssociationRelevanceCourseView.h"
#import "LivingCourseDetailViewController.h"
#import "ArticleDetailViewController.h"

@interface JoinAssociationViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_JoinAssociation,UserModule_PayOrderProtocol,CourseModule_LearningCourseProtocol,UserModule_PayOrderByCoinProtocol>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;
@property (nonatomic, assign)int page;

@property (nonatomic, strong)NSDictionary * associationInfo;
@property (nonatomic, strong)UIView * bottomView;

@property (nonatomic, assign)BOOL isWechat;

@property (nonatomic, strong)NSArray * relevanceCourse;

@end

@implementation JoinAssociationViewController
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
    [self loadData];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self navigationViewSetup];
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];

}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = [self.infoDic objectForKey:@"title"];
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView registerClass:[JoinAssociationHeadTableViewCell class] forCellReuseIdentifier:kJoinAssociationHeadTableViewCell];
    [self.tableView registerClass:[LoadFailedTableViewCell class] forCellReuseIdentifier:kFailedCellID];
    [self.tableView registerClass:[AssociationCommentTableViewCell class] forCellReuseIdentifier:kAssociationCommentTableViewCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenHeight, 50)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [self addBottomOperationBtn];
}

- (void)addBottomOperationBtn
{
    [_bottomView removeAllSubviews];
    
    if ([[self.associationInfo objectForKey:@"is_relation"] intValue] == 2) {
        
        if ([[self.associationInfo objectForKey:@"is_join"] intValue] == 1) {
            UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            joinBtn.frame = CGRectMake(0, 0, kScreenWidth/2, 50);
            joinBtn.backgroundColor = UIRGBColor(68, 194, 67);
            [joinBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            joinBtn.titleLabel.font = kMainFont;
            [_bottomView addSubview:joinBtn];
            [joinBtn setTitle:@"进入社群" forState:UIControlStateNormal];
            
            UIButton * courseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            courseBtn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 50);
            courseBtn.backgroundColor = UIRGBColor(252, 146, 49);
            [courseBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            courseBtn.titleLabel.font = kMainFont;
            [_bottomView addSubview:courseBtn];
            [courseBtn setTitle:@"购买" forState:UIControlStateNormal];
            
            [joinBtn addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
            [courseBtn addTarget:self action:@selector(burCourseAction) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([[self.associationInfo objectForKey:@"is_join"] intValue] == 0 && [[self.associationInfo objectForKey:@"is_pay"] intValue] == 1)
        {
            UIButton * courseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            courseBtn.frame = CGRectMake(0, 0, kScreenWidth, 50);
            courseBtn.backgroundColor = UIRGBColor(252, 146, 49);
            [courseBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            courseBtn.titleLabel.font = kMainFont;
            [_bottomView addSubview:courseBtn];
            [courseBtn setTitle:@"购买" forState:UIControlStateNormal];
            [courseBtn addTarget:self action:@selector(burCourseAction) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else
        {
            UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            joinBtn.frame = CGRectMake(0, 0, kScreenWidth/2, 50);
            joinBtn.backgroundColor = UIRGBColor(68, 194, 67);
            [joinBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            joinBtn.titleLabel.font = kMainFont;
            [_bottomView addSubview:joinBtn];
            [joinBtn setTitle:[NSString stringWithFormat:@"付费%@元进入社群", [self.associationInfo objectForKey:@"pay_money"]] forState:UIControlStateNormal];
            
            UIButton * courseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            courseBtn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 50);
            courseBtn.backgroundColor = UIRGBColor(252, 146, 49);
            [courseBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            courseBtn.titleLabel.font = kMainFont;
            [_bottomView addSubview:courseBtn];
             [courseBtn setTitle:@"购买" forState:UIControlStateNormal];
            
            [joinBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
            [courseBtn addTarget:self action:@selector(burCourseAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else
    {
        UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        joinBtn.frame = CGRectMake(40, 5, kScreenWidth - 80, 40);
        joinBtn.layer.cornerRadius = 5;
        joinBtn.layer.masksToBounds = YES;
        joinBtn.backgroundColor = kCommonMainBlueColor;
        [joinBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        joinBtn.titleLabel.font = kMainFont;
        [_bottomView addSubview:joinBtn];
        
        
        if ([[self.associationInfo objectForKey:@"is_join"] intValue] == 1) {
            [joinBtn setTitle:@"进入社群" forState:UIControlStateNormal];
            [joinBtn addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            [joinBtn setTitle:[NSString stringWithFormat:@"付费%@元进入社群", [self.associationInfo objectForKey:@"pay_money"]] forState:UIControlStateNormal];
            [joinBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
}

- (void)loadData
{
    self.page = 1;
    [SVProgressHUD show];
    [[UserManager sharedManager] getJoinAssociationWith:@{kUrlName:@"api/community/communityinfoandJoin",@"c_id":[self.infoDic objectForKey:@"id"],kRequestType:@"get",@"include":@"share,dynamics"} withNotifiedObject:self];

    [[CourseraManager sharedManager] didRequestLearningCourseWithInfoDic:@{kUrlName:@"api/community/relationshop",@"c_id":[self.infoDic objectForKey:@"id"],kRequestType:@"get"} NotifiedObject:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.itemArray.count == 0 ? 1 : self.itemArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 1) {
        
        if (self.itemArray.count == 0) {
            LoadFailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFailedCellID forIndexPath:indexPath];
            [cell refreshUIWith:@{}];
            
            return cell;
        }
        
        AssociationCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationCommentTableViewCell forIndexPath:indexPath];
        [cell refreshUIWith:self.itemArray[indexPath.row] andIsCanOperation:NO];
        
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect = [cell convertRect:cell.bounds toView:window];
        cell.imageClickBlock = ^(NSArray * _Nonnull urlArray, int index) {
            TestImageView *showView = [[TestImageView alloc] initWithFrame:weakSelf.view.frame andImageList:urlArray andCurrentIndex:index];
            showView.outsideFrame = rect;
            showView.insideFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [showView show];
        };
        return cell;
    }
    
    JoinAssociationHeadTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kJoinAssociationHeadTableViewCell forIndexPath:indexPath];
    [titleCell resetCellContent:self.associationInfo];
    titleCell.activeBlock = ^{
        [weakSelf shareAction];
    };
    return titleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (self.itemArray.count == 0) {
            return tableView.hd_height - 280;
        }
        
        NSDictionary * info = self.itemArray[indexPath.row];
        NSString * contentStr = [info objectForKey:@"content"];
        CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
//        NSString * htmlString = [UIUtility judgeStr:[info objectForKey:@"content"]];
//        htmlString = [htmlString gtm_stringByUnescapingFromHTML];
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        CGFloat height = [attrStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        
        
        int imageCount = [[info objectForKey:@"c_imgs"] count] % 3 == 0 ? [[info objectForKey:@"c_imgs"] count] / 3 : [[info objectForKey:@"c_imgs"] count] / 3 + 1;
        CGFloat imageHeight = (kCellHeightOfCategoryView + 5) * imageCount;
        
        
        return 15 + 30 + 10 + height + 5 + imageHeight + 15;
    }
    
    return 280;
}

- (void)shareAction
{
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:YES];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
    self.payView = payView;
}

- (void)payClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [self.payView removeFromSuperview];
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_wechatPay) {
        NSLog(@"微信支付");
        self.isWechat = YES;
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/community",@"c_id":[NSString stringWithFormat:@"%@", [self.associationInfo objectForKey:@"id"]],@"pay_type":@"wechat"} withNotifiedObject:self];
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_zhifubPay)
    {
        self.isWechat = NO;
        NSLog(@"支付宝支付");
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/community",@"c_id":[NSString stringWithFormat:@"%@", [self.associationInfo objectForKey:@"id"]],@"pay_type":@"alipay"} withNotifiedObject:self];
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_shareFriend)
    {
        
        NSDictionary * shareInfo = self.shareInfo;
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
        NSDictionary * shareInfo = self.shareInfo;
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


#pragma mark - 购买关联课程
- (void)burCourseAction
{
    
    AssociationRelevanceCourseView * view = [[AssociationRelevanceCourseView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andCourseArray:self.relevanceCourse];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:view];
    __weak typeof(self)weakSelf = self;
    view.courseBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf pushCourseDetail:info];
    };
    
}

- (void)pushCourseDetail:(NSDictionary *)info
{
    
    NSMutableDictionary * mInfp = [[NSMutableDictionary alloc]initWithDictionary:info];
    [mInfp setValue:[info objectForKey:@"shop_id"] forKey:@"id"];
    
    if ([[info objectForKey:@"type"] intValue] == 1) {
        ArticleDetailViewController * vc = [[ArticleDetailViewController alloc]init];
        vc.infoDic = mInfp;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([[info objectForKey:@"type"] intValue] == 3)
    {
        LivingCourseDetailViewController * vc = [[LivingCourseDetailViewController alloc]init];
        vc.info = mInfp;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)didRequestLearningCourseSuccessed
{
    [SVProgressHUD dismiss];
    self.relevanceCourse = [[CourseraManager sharedManager] getLearningCourseInfoArray];
}

- (void)didRequestLearningCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - 直接入群
- (void)joinAction
{
    AssociationDetailViewController * vc = [[AssociationDetailViewController alloc]init];
    vc.infoDic = self.infoDic;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 支付入群费用

#pragma mark - pay

- (void)coinBuyAction
{
    [SVProgressHUD show];
    [[UserManager sharedManager]payOrderByCoinWith:@{kUrlName:@"api/applePay/community",@"c_id":[NSString stringWithFormat:@"%@", [self.associationInfo objectForKey:@"id"]]} withNotifiedObject:self];
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

- (void)payAction
{
    if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue]) {
        ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:NO];
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:payView];
        self.payView = payView;
    }else
    {
        [SVProgressHUD show];
        [self coinBuyAction];
    }
}

- (void)paySuccedsss:(NSNotification *)notification
{
    NSLog(@"paySuccedsss");
    [self loadData];
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



#pragma mark - associationDetail


- (void)getShareInfo:(NSDictionary *)info
{
    NSDictionary * shareInfo = [info objectForKey:@"share"];
    self.shareInfo = shareInfo;
    self.shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:self.shareImageView];
    self.shareImageView.hidden = YES;
    
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[shareInfo objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
}

- (void)didJoinAssociationSuccessed{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.associationInfo = [[UserManager sharedManager] getJoinAssociationInfo];
    self.itemArray = [[self.associationInfo objectForKey:@"dynamics"] objectForKey:@"data"];
    
    [self addBottomOperationBtn];
    [self getShareInfo:self.associationInfo];
    [self.tableView reloadData];
}

- (void)didJoinAssociationFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)kkk
{
    
    if ([[self.associationInfo objectForKey:@"is_relation"] intValue] == 2) { //################### 有关联课程
        
        if ([[self.associationInfo objectForKey:@"is_join"] boolValue] == true) { //********** is_join= true
            // 左边进入社群    右边购买课程
        }else if ([[self.associationInfo objectForKey:@"is_join"] boolValue] == false && [[self.associationInfo objectForKey:@"is_pay"] intValue] == 1) //********** is_join = false   && is_pay = 1
        {
             // 购买课程
        }else //********** is_join = false   && is_pay = 2
        {
            // 左边付费***元进入社群    右边购买课程
        }
        
    }else
    { //  ################### 未关联课程
        UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[self.associationInfo objectForKey:@"is_join"] intValue] == 1  ) { // ********** is_join = true
            // 进入社群
        }else
        {
            // 付费***元进入社群
        }
        
    }
}

@end
