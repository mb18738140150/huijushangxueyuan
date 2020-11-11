//
//  TiXianViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/9.
//

#import "TiXianViewController.h"

@interface TiXianViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,UserModule_MockVIPBuy>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UITextField * tf;

@property (nonatomic, assign)BOOL submitSuccess;


@end

@implementation TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"提现";
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
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tdAction)];
    [self.tableView addGestureRecognizer:tap];
    
}

- (void)tdAction{
    [_tf resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.submitSuccess) {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, cell.hd_height - 10)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [cell.contentView addSubview:backView];
    
    if (self.submitSuccess) {
        backView.frame = CGRectMake(0, 0, kScreenWidth, 220);
        UIImageView * time = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 10, 30, 20, 20)];
        time.image = [UIImage imageNamed:@"tixianSubmit"];
        [backView addSubview:time];
        
        UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + CGRectGetMaxY(time.frame),kScreenWidth - 30 , 20)];
        tipLB.text = @"提现申请已提交";
        tipLB.textColor = UIColorFromRGB(0x999999);
        tipLB.font = kMainFont_12;
        tipLB.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:tipLB];
        
        UILabel * stateLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + CGRectGetMaxY(tipLB.frame),kScreenWidth - 30 , 20)];
        stateLB.text = @"后台处理中，请耐心等待";
        stateLB.textColor = UIColorFromRGB(0x333333);
        stateLB.font = kMainFont;
        stateLB.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:stateLB];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(stateLB.frame) + 30, kScreenWidth - 30, 1)];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [backView addSubview:line];
        
        UILabel * countLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame) + 10,100 , 20)];
        countLB.text = @"提现金额";
        countLB.textColor = UIColorFromRGB(0x666666);
        countLB.font = kMainFont_12;
        [backView addSubview:countLB];
        
        NSDictionary * infoDic = [[UserManager sharedManager] getMyIncomeInfo];
        UILabel * countLB1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 115, CGRectGetMaxY(line.frame) + 10,100 , 20)];
        countLB1.text = [NSString stringWithFormat:@"￥%.2f", [[infoDic objectForKey:@"balance"] floatValue]];
        countLB1.textColor = UIColorFromRGB(0x333333);
        countLB1.font = kMainFont_12;
        countLB1.textAlignment = NSTextAlignmentRight;
        [backView addSubview:countLB1];
        
        
        UILabel * accountLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(countLB.frame) + 20,100 , 20)];
        accountLB.text = @"提现账户";
        accountLB.textColor = UIColorFromRGB(0x333333);
        accountLB.font = kMainFont_12;
        [accountLB sizeToFit];
        [backView addSubview:accountLB];
        
        UILabel * accountLB1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(accountLB.frame) + 15, CGRectGetMaxY(countLB.frame) + 20,kScreenWidth - 30 - CGRectGetMaxX(accountLB.frame)  , 20)];
        accountLB1.text = [[[UserManager sharedManager] getUserInfos] objectForKey:kUserName];;
        accountLB1.textColor = UIColorFromRGB(0x666666);
        accountLB1.font = kMainFont_12;
        accountLB1.textAlignment = NSTextAlignmentRight;
        [backView addSubview:accountLB1];
        
        UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(10, 30 + CGRectGetMaxY(backView.frame), kScreenWidth - 20, 40);
        submitBtn.layer.cornerRadius = 5;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.backgroundColor = kCommonMainBlueColor;
        [submitBtn setTitle:@"返回我的收益" forState:UIControlStateNormal];
        [submitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        submitBtn.titleLabel.font = kMainFont;
        [submitBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:submitBtn];
        return cell;
    }
    
    if (indexPath.row == 0) {
        UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 10,100 , 30)];
        tipLB.text = @"提现账户";
        tipLB.textColor = UIColorFromRGB(0x333333);
        tipLB.font = kMainFont;
        [tipLB sizeToFit];
        [backView addSubview:tipLB];
        
        UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(15 + CGRectGetMaxX(tipLB.frame), 10,100 , 30)];
        nameLB.text = [[[UserManager sharedManager] getUserInfos] objectForKey:kUserName];
        nameLB.textColor = UIColorFromRGB(0x000000);
        nameLB.font = kMainFont_16;
        [nameLB sizeToFit];
        [backView addSubview:nameLB];
        
        return cell;
    }else if (indexPath.row == 2)
    {
        backView.hidden = YES;
        
        UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(10, 30, kScreenWidth - 20, 40);
        submitBtn.layer.cornerRadius = 5;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.backgroundColor = kCommonMainBlueColor;
        
        [submitBtn setTitle:@"确认提现" forState:UIControlStateNormal];
        [submitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        submitBtn.titleLabel.font = kMainFont;
        [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:submitBtn];
        return cell;
    }
    
    UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 10,100 , 15)];
    tipLB.text = @"提现账户";
    tipLB.textColor = UIColorFromRGB(0x333333);
    tipLB.font = kMainFont;
    [backView addSubview:tipLB];
    
    UILabel * ￥LB = [[UILabel alloc]initWithFrame:CGRectMake(15, 20 + CGRectGetMaxY(tipLB.frame),100 , 20)];
    ￥LB.text = @"￥";
    ￥LB.textColor = UIColorFromRGB(0x333333);
    ￥LB.font = kMainFont_16;
    [￥LB sizeToFit];
    [backView addSubview:￥LB];
    
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(￥LB.frame) + 10, CGRectGetMaxY(tipLB.frame) + 15, kScreenWidth - 100, 30)];
    _tf.font = [UIFont systemFontOfSize:24];
    _tf.textColor = UIColorFromRGB(0x000000);
    _tf.placeholder = @"0";
    _tf.returnKeyType = UIReturnKeyDone;
    _tf.keyboardType = UIKeyboardTypeNumberPad;
    _tf.delegate = self;
    [backView addSubview:_tf];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_tf.frame) + 5, kScreenWidth - 30, 1)];
    line.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:line];
    
    NSDictionary * infoDic = [[UserManager sharedManager] getMyIncomeInfo];
    UILabel * countLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + CGRectGetMaxY(line.frame),100 , 20)];
    countLB.text = [NSString stringWithFormat:@"可用余额%.2f元", [[infoDic objectForKey:@"balance"] floatValue]];
    countLB.textColor = UIColorFromRGB(0x999999);
    countLB.font = kMainFont_16;
    [countLB sizeToFit];
    [backView addSubview:countLB];
    
    UIButton * allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(10 + CGRectGetMaxX(countLB.frame), CGRectGetMaxY(line.frame) + 10, 80, 20);
    
    [allBtn setTitle:@"全部提现" forState:UIControlStateNormal];
    [allBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    allBtn.titleLabel.font = kMainFont;
    [allBtn addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:allBtn];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.submitSuccess) {
        return 300;
    }
    
    if (indexPath.row == 0) {
        return 60;
    }else if (indexPath.row == 2)
    {
        return 70;
    }
    return 130;
}

- (void)submitAction
{
    if (_tf.text.floatValue < 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最小提现金额为2元" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSString * url = @"api/promotion/cash";
    if (self.isTeacher) {
        url = @"api/teacher/cash";
    }
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:url,@"money":_tf.text} withNotifiedObject:self];
    
}

- (void)allAction
{
    NSDictionary * infoDic = [[UserManager sharedManager] getMyIncomeInfo];
    _tf.text = [NSString stringWithFormat:@"%.2f", [[infoDic objectForKey:@"balance"] floatValue]];
}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD dismiss];
    self.submitSuccess = YES;
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

@end
