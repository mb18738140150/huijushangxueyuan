//
//  LoginViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/1.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LoginViewController.h"
#import "UIMacro.h"
#import "UserManager.h"
#import "SVProgressHUD.h"
#import "LoginBackgroundView.h"

#import "NSString+HTML.h"

#import "RegistViewController.h"
//#import "ForgetPasswordViewController.h"
//#import "VerifyAccountViewController.h"
#define kImageWidth 25

@interface LoginViewController ()<UITextFieldDelegate,UserModule_LoginProtocol,UserModule_BindJPushProtocol,UserModule_LevelDetailProtocol,UserModule_CommonProblem,UserModule_AssistantCenterProtocol,UserModule_LivingBackYearList, UIAlertViewDelegate>

@property (nonatomic,strong) UITextField                *account;
@property (nonatomic,strong) UITextField                *password;
@property (nonatomic,strong) UIButton                   *loginButton;
@property (nonatomic,strong) UIImageView                *closeImageView;
@property (nonatomic,strong) UILabel                    *titleLabel;
@property (nonatomic,strong) UIImageView                *logoImageView;
@property (nonatomic,strong) LoginBackgroundView        *background;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf) name:kNotificationOfLoginSuccess object:nil];
    [self viewInit];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOfLoginSuccess object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navBarBgAlpha = @"0.0";
    self.navigationController.navigationBar.tintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    // 设置导航栏标题和返回按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kCommonMainTextColor_50}];
}

- (void)navigationViewSetup
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setShadowImage:[UIImage imageNamed:@"tm"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tm"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)viewInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIControl *resignControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [resignControl addTarget:self action:@selector(resignTextFiled) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignControl];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = [UIImage imageNamed:@"loginImage"];
    [self.view addSubview:imageView];
    if (self.isAccount) {
        [self prepareUI];
        return;
    }
    UIButton * weichatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weichatBtn.frame = CGRectMake(20, kScreenHeight - 280, kScreenWidth - 40, 70);
    weichatBtn.backgroundColor = UIColorFromRGB(0xffffff);
    weichatBtn.layer.cornerRadius = weichatBtn.hd_height / 2;
    weichatBtn.layer.masksToBounds = YES;
    [weichatBtn setImage:[UIImage imageNamed:@"weixinlogin"] forState:UIControlStateNormal];
    [weichatBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    [weichatBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    weichatBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    [self.view addSubview:weichatBtn];
    [weichatBtn addTarget:self action:@selector(touristAction) forControlEvents:UIControlEventTouchUpInside];
    
//    [self prepareUI];
}

- (void)prepareUI
{
    
    _background=[[LoginBackgroundView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, kScreenHeight )];
    [_background setBackgroundColor:[UIColor clearColor]];
    _background.userInteractionEnabled = YES;
    [self.view addSubview:_background];
    
    UIView * accountView = [[UIView alloc]initWithFrame:CGRectMake(20, kScreenHeight - 350, kScreenWidth - 80, 40)];
    accountView.backgroundColor = [UIColor whiteColor];
    [_background addSubview:accountView];
    
    UIImageView * accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kImageWidth, kImageWidth)];
    accountImageView.image = [UIImage imageNamed:@"手机(1)"];
    [accountView addSubview:accountImageView];
    
    _account=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountImageView.frame) + 10, 0, accountView.hd_width - 35, 40)];
    [_account setBackgroundColor:[UIColor clearColor]];
    _account.placeholder=[NSString stringWithFormat:@"请输入账号"];
    _account.delegate = self;
    _account.font = kMainFont;
    _account.textColor = kCommonMainTextColor_50;
    [accountView addSubview:_account];
    
    UIView * accountBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, accountView.hd_height - 1, accountView.hd_width, 1)];
    accountBottomView.backgroundColor = kCommonMainTextColor_200;
    [accountView addSubview:accountBottomView];
    
    UIView * passwordView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(accountView.frame) + 20, kScreenWidth - 80, 40)];
    passwordView.backgroundColor = [UIColor whiteColor];
    [_background addSubview:passwordView];
    
    UIImageView * passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kImageWidth, kImageWidth)];
    passwordImageView.image = [UIImage imageNamed:@"密码"];
    [passwordView addSubview:passwordImageView];
    
    _password=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame) + 10, 0, kScreenWidth-40, 40)];
    [_password setBackgroundColor:[UIColor clearColor]];
    _password.secureTextEntry = YES;
    _password.placeholder=[NSString stringWithFormat:@"请输入密码"];
    _password.layer.cornerRadius=5.0;
    _password.delegate = self;
    _password.font = kMainFont;
    _password.textColor = kCommonMainTextColor_50;
    [passwordView addSubview:_password];
    
    UIView * passwordBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, passwordView.hd_height - 1, passwordView.hd_width, 1)];
    passwordBottomView.backgroundColor = kCommonMainTextColor_200;
    [passwordView addSubview:passwordBottomView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 50, 35, 35);
    [closeBtn setImage:[UIImage imageNamed:@"public-返回"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    
    UIButton * registPsdBTn = [UIButton buttonWithType:UIButtonTypeCustom];
    registPsdBTn.frame = CGRectMake(CGRectGetMaxX(passwordView.frame) -70, CGRectGetMaxY(passwordView.frame) + 40, 70, 20);
    registPsdBTn.titleLabel.font = kMainFont;
    [registPsdBTn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registPsdBTn setTitleColor:kCommonMainTextColor_100 forState:UIControlStateNormal];
    [registPsdBTn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:registPsdBTn];
    
    _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(20, CGRectGetMaxY(passwordView.frame) + 70, kScreenWidth - 80, 40)];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = _loginButton.hd_height / 2;
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.borderColor = kCommonMainTextColor_150.CGColor;
    _loginButton.layer.borderWidth = 0.5;
    [_loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setBackgroundColor:kCommonMainBlueColor];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_background addSubview:_loginButton];
    
    
    UIButton * touristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touristBtn.frame = CGRectMake(0, _background.hd_height - 40, _background.hd_width, 20);
    [touristBtn setTitle:@"游客模式>>>" forState:UIControlStateNormal];
    touristBtn.titleLabel.font = kMainFont;
    [touristBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    [touristBtn setBackgroundColor:[UIColor clearColor]];
    [_background addSubview:touristBtn];
    [touristBtn addTarget:self action:@selector(touristAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)resignTextFiled
{
    [_account resignFirstResponder];
    [_password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignTextFiled];
    return YES;
}

- (void)dismissSelf
{
    NSLog(@"************");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doLogin
{
    
    [self.account resignFirstResponder];
    [self.password resignFirstResponder];
    
    NSString *userName = _account.text;
    NSString *password = _password.text;
    [[UserManager sharedManager] loginWithUserName:userName andPassword:password withNotifiedObject:self];
    [SVProgressHUD show];
}


- (void)registerAction
{
    NSLog(@"注册");
    RegistViewController * registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)touristAction
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        NSLog(@"随便看看 &&& 微信登录");
        
        [self sendAuthRequest];
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"游客最好注册账户，否则会账号信息存在风险" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)sendAuthRequest
{
    
    [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo" State:@"123" OpenID:@"wx7989d2f3f7dbdd02" InViewController:self];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UserManager sharedManager] loginWithUserName:@"18736087590" andPassword:@"111111" withNotifiedObject:self];
}

#pragma mark - login protocol func
- (void)didUserLoginSuccessed
{
    [SVProgressHUD dismiss];
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_account.text forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:@"password"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dismissSelf];
        
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginSuccess object:nil];
    
}

- (void)didUserLoginFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)getMemberLevelDetail
{
    [[UserManager sharedManager] didRequestLevelDetailWithNotifiedObject:self];
}

- (void)getCommonProblemList
{
    [[UserManager sharedManager] didRequestCommonProblemWithInfo:@{} withNotifiedObject:self];
}

- (void)getAssistantLiat
{
    [[UserManager sharedManager] didRequestAssistantWithInfo:@{kUrlName:@"Feedback/QueryCustomerService"} withNotifiedObject:self];
}

- (void)getLivingBackYearList
{
    [[UserManager sharedManager]didRequestLivingBackYearListWithInfo:@{} withNotifiedObject:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}

- (void)didRequestLevelDetailSuccessed
{
    
}

- (void)didRequestLevelDetailFailed:(NSString *)failedInfo
{
    
}

- (void)didRequestBindJPushSuccessed
{
    
}

- (void)didRequestBindJPushFailed:(NSString *)failedInfo
{
    
}

- (void)didRequestCommonProblemSuccessed
{
    
}

- (void)didRequestCommonProblemFailed:(NSString *)failedInfo
{
    
}

- (void)didRequestAssistantCenterSuccessed
{
    
}

- (void)didRequestAssistantCenterFailed:(NSString *)failedInfo
{
    
}

- (void)didRequestLivingBackYearListSuccessed
{
    
}

- (void)didRequestLivingBackYearListFailed:(NSString *)failedInfo
{
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setTopGradientLayer
{
    CGPoint startP = CGPointMake(kScreenWidth / 2, 0);
    CGPoint endP = CGPointMake(kScreenWidth / 2, self.view.frame.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = self.view.bounds;
    layer.lineWidth = kScreenWidth;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    // 渐变进度条
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.view.bounds;
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.view.bounds;
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIRGBColor(28, 144, 247) CGColor],(id)[UIRGBColor(9, 68, 255) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0, @0.5, @1]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer1];
    
    CAShapeLayer * processLayer = [[CAShapeLayer alloc] init];
    processLayer.frame = self.view.bounds;
    processLayer.fillColor = [UIColor clearColor].CGColor;
    processLayer.strokeColor = [UIColor whiteColor].CGColor;
    processLayer.lineWidth = kScreenWidth;
    processLayer.path = path.CGPath;
    processLayer.strokeEnd = 0.5;
    
    [gradientLayer setMask:processLayer];
    
    [self.view.layer addSublayer:gradientLayer];
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
