//
//  MyPromotionViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import "MyPromotionViewController.h"
#import "PromotionApplyTableViewCell.h"
#define kPromotionApplyTableViewCell @"PromotionApplyTableViewCell"
#import "ChooseCountryPhoneNum.h"
#import "TeacherDescViewController.h"
#import "PromotionComplateTableViewCell.h"
#define kPromotionComplateTableViewCell @"PromotionComplateTableViewCell"
#import "MyIncomeViewController.h"
#import "ShareAndPaySelectView.h"
#import "PromotionCourseViewController.h"
#import "MyTeamViewController.h"

@interface MyPromotionViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_MockVIPBuy,UserModule_MockPartnerBuy,UserModule_Promotion,UserModule_VerifyCodeProtocol,UserModule_AddCourseStudyRecord>

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)UITextField * nameTF;
@property (nonatomic, strong)UITextField * phoneTF;
@property (nonatomic, strong)UITextField *verifyTF;
@property (nonatomic, strong)UIButton * checkBtn;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;

@property (nonatomic, strong)NSDictionary * promotionInfo;

@end

@implementation MyPromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];

    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/promotion/rule",kRequestType:@"get"} withNotifiedObject:self];
    
    if (self.promotionType == PromotionType_complate) {
        [self loadData];
    }
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"推广中心";
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
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[PromotionApplyTableViewCell class] forCellReuseIdentifier:kPromotionApplyTableViewCell];
    [self.tableView registerClass:[PromotionComplateTableViewCell class] forCellReuseIdentifier:kPromotionComplateTableViewCell];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(kScreenWidth  - 100, 40, 100, 30);
    checkBtn.backgroundColor = UIColorFromRGB(0xffffff);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:checkBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = checkBtn.bounds;
    layer.path = path.CGPath;
    [checkBtn.layer setMask:layer];
    [self.view addSubview:checkBtn];
    [checkBtn addTarget:self action:@selector(checkRulerAction) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setTitle:@"查看推广规则" forState:UIControlStateNormal];
    [checkBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    checkBtn.titleLabel.font = kMainFont_12;
    [self.view addSubview:checkBtn];
    self.checkBtn = checkBtn;
    self.checkBtn.hidden = YES;
    if (self.promotionType == PromotionType_complate) {
        self.checkBtn.hidden = NO;
    }
    
}

- (void)loadData
{
    [SVProgressHUD show];
    // getShareInfo
    [[UserManager sharedManager] didRequestMockPartnerBuyWithInfo:@{kUrlName:@"api/index/share",kRequestType:@"get"} withNotifiedObject:self];
    
    [[UserManager sharedManager] getPromotionWith:@{kUrlName:@"api/promotion/index",kRequestType:@"get"} withNotifiedObject:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (self.promotionType == PromotionType_complate) {
        PromotionComplateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kPromotionComplateTableViewCell forIndexPath:indexPath];
        [cell refreshUIWithInfo:self.promotionInfo];
        
        cell.YueBlock = ^(NSDictionary * _Nonnull info) {
            MyIncomeViewController * vc = [[MyIncomeViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.teamBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf pushTeamVC];
        };
        cell.reciveBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf shareAction];
        };
        cell.courseBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf pushPromotionCourseVc];
        };
        
        return cell;
    }
    
    PromotionApplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kPromotionApplyTableViewCell forIndexPath:indexPath];
    if (self.promotionType == PromotionType_apply) {
        [cell refreshApplyUIWithInfo:@{}];
    }else
    {
        [cell refreshCheckUIWithInfo:@{}];
    }
    
    self.nameTF = cell.nameTF;
    self.verifyTF = cell.verifyTF;
    self.phoneTF = cell.phoneTF;
    
    cell.promotionApplyBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf promotionApply:info];
    };
    
    cell.getVerifyACodeBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf getVerifyCOde:info];
    };
    
    cell.CheckRulerBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf checkRulerAction];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.promotionType == PromotionType_complate) {
        return kScreenHeight - kNavigationBarHeight - kStatusBarHeight;
    }
    UIImage * backImage = [UIImage imageNamed:@"底图"];
    float imageHeight = backImage.size.height * 1.0 / backImage.size.width * kScreenWidth;
    return kScreenHeight - kStatusBarHeight - kNavigationBarHeight;
}

- (void)shareAction
{
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:YES];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
    self.payView = payView;
}

#pragma mark - Apply
- (void)promotionApply:(NSDictionary *)info
{
    NSLog(@"info = %@", info);
    NSString * name = [info objectForKey:@"name"];
    NSString * phone = [info objectForKey:@"phone"];
    NSString * code = [info objectForKey:@"code"];
    
    NSString * code_sin = [[UserManager sharedManager] getVerifyCode];
    if (code_sin == nil) {
        code_sin = @"";
    }
    
    [SVProgressHUD show];
    [[UserManager sharedManager] getApplyPromotionWith:@{kUrlName:@"api/promotion/apply",@"username":name,@"mobile":phone,@"sms_code":code,@"sms_code_sn":code_sin} withNotifiedObject:self];
    
}

- (void)didRequestAddCourseStudyRecordSuccessed
{
    NSDictionary * info = [[UserManager sharedManager] getApplyPromotionInfo];
    int applyState = [[info objectForKey:@"status"] intValue];
    if (applyState == 1) {
        self.promotionType = PromotionType_check;
    }else if (applyState == 1)
    {
        self.promotionType = PromotionType_complate;
        [self loadData];
    }
    [self.tableView reloadData];
}

- (void)didRequestAddCourseStudyRecordFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}



#pragma mark - getVerifyCode
- (void)getVerifyCOde:(NSDictionary *)info
{
    NSLog(@"info = %@", info);
    NSString * phone = [info objectForKey:@"phone"];
    [SVProgressHUD show];
    [[UserManager sharedManager] getVerifyCodeWithPhoneNumber:@{kUrlName:@"api/sms/promotionApply",@"mobile":phone} withNotifiedObject:self];
}

- (void)didVerifyCodeSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"已发送"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didVerifyCodeFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)checkRulerAction
{
    TeacherDescViewController * vc = [[TeacherDescViewController alloc]init];
    vc.info = [[UserManager sharedManager] getVIPBuyInfo];
    vc.titleStr = @"推广规则";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)keyboardChangeFrame:(NSNotification*)noti;
{
    CGRect rect= [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSLog(@"%@", noti.userInfo);
    CGFloat keyboardheight = rect.origin.y;
    CGFloat duration=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGFloat curve=[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey]doubleValue];
    
    [UIView setAnimationCurve:curve];
    [UIView animateWithDuration:duration animations:^{
        self.tableView.hd_height = keyboardheight;
        [self.tableView setContentOffset:CGPointMake(0, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - keyboardheight) animated:NO];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyboardHide:(NSNotification *)noti
{
    self.tableView.hd_height = kScreenHeight - kNavigationBarHeight - kStatusBarHeight;

}

#pragma mark - promotion course
- (void)pushPromotionCourseVc
{
    PromotionCourseViewController * vc = [[PromotionCourseViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushTeamVC{
    MyTeamViewController * vc = [[MyTeamViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

// ruler
- (void)didRequestMockVIPBuySuccessed
{
    
}

- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    
}

// promotion info
- (void)didPromotionSuccessed
{
    [SVProgressHUD dismiss];
    self.promotionInfo = [[UserManager sharedManager] getMyPromotionInfo];
    [self.tableView reloadData];
}

- (void)didPromotionFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

// share
- (void)didRequestMockPartnerBuySuccessed
{
    [SVProgressHUD dismiss];
    self.shareInfo = [[UserManager sharedManager] getPartnerBuyInfo];
    [self getShareInfo:[[UserManager sharedManager] getPartnerBuyInfo]];
}

- (void)getShareInfo:(NSDictionary *)info
{
    NSDictionary * shareInfo = info;
    self.shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 1000, 100, 100)];
    [self.view addSubview:self.shareImageView];
    self.shareImageView.hidden = YES;
    
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[shareInfo objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"图片下载成功");
    }];
    
}

- (void)didRequestMockPartnerBuyFailed:(NSString *)failedInfo
{
   
}

- (void)payClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [self.payView removeFromSuperview];
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_shareFriend)
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
