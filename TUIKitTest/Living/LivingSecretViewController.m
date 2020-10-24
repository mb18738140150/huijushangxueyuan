//
//  LivingSecretViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/24.
//

#import "LivingSecretViewController.h"

@interface LivingSecretViewController ()<UITextFieldDelegate,UserModule_VerifyCodeProtocol>

@property (nonatomic, strong)UITextField * tf;
@property (nonatomic, strong)UIButton * cancelBtn;
@property (nonatomic, strong)UIButton * payBtn;

@end

@implementation LivingSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"验证密码";
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
    UIImageView * iconImagheView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 30, 40 , 60, 60)];
    iconImagheView.layer.cornerRadius = 30;
    iconImagheView.layer.masksToBounds = YES;
    [iconImagheView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.info objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    [self.view addSubview:iconImagheView];
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(iconImagheView.frame) + 10, kScreenWidth - 30, 20)];
    titleLB.text = [_info objectForKey:@"title"];
    titleLB.textColor = UIColorFromRGB(0x666666);
    titleLB.font = kMainFont_16;
    titleLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLB];
    
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLB.frame) + 10, kScreenWidth - 30, 40)];
    _tf.backgroundColor = UIColorFromRGB(0xffffff);
    _tf.textColor = UIColorFromRGB(0x333333);
    _tf.font = kMainFont;
    _tf.returnKeyType = UIReturnKeyDone;
    _tf.placeholder = @"输入密码";
    _tf.layer.cornerRadius = 5;
    _tf.delegate = self;
    _tf.layer.shadowColor = UIColorFromRGB(0xaaaaaa).CGColor;
    _tf.layer.shadowOpacity = 1;
    _tf.layer.shadowOffset = CGSizeMake(0, -3);
    _tf.layer.shadowRadius = 3;
    [self.view addSubview:_tf];
    
    UILabel * tipeLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_tf.frame) + 10, kScreenWidth - 30, 15)];
    tipeLB.text = @"密码提示：无回放";
    tipeLB.textColor = UIColorFromRGB(0x666666);
    tipeLB.font = kMainFont_12;
    [self.view addSubview:tipeLB];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(15, CGRectGetMaxY(tipeLB.frame) + 10, kScreenWidth / 2 - 15, 40);
    self.cancelBtn.backgroundColor = UIColorFromRGB(0x515151);
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = kMainFont;
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.frame = CGRectMake(kScreenWidth / 2 + 5, _cancelBtn.hd_y, kScreenWidth / 2 - 15, 40);
    self.payBtn.backgroundColor = kCommonMainBlueColor;
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.masksToBounds = YES;
    [self.payBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = kMainFont;
    [self.view addSubview:self.payBtn];
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)payAction
{
    if (self.tf.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"验证码不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    [SVProgressHUD show];
    [[UserManager sharedManager] getVerifyCodeWithPhoneNumber:@{kUrlName:@"api/topicLive/verifyPass",@"pass":self.tf.text,@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]} withNotifiedObject:self];
}

- (void)didVerifyCodeSuccessed
{
    [[NSUserDefaults standardUserDefaults] setObject:[UIUtility getCurrentTimestamp] forKey:kVerifyLivingPsdTime];
    if (self.verifyPsdSuccessBlock) {
        self.verifyPsdSuccessBlock(@{@"psd":self.tf.text});
    }
}



- (void)didVerifyCodeFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
