//
//  PresentDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "PresentDetailViewController.h"

@interface PresentDetailViewController()<UITableViewDelegate, UITableViewDataSource,UserModule_SecondCategoryProtocol,UserModule_CategoryCourseProtocol,UITextFieldDelegate,UserModule_MockVIPBuy>

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;

@property (nonatomic, strong)UITextField * tf;

@end

@implementation PresentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSuccess:) name:kNotificationOfPresentSuccess object:nil];
    [self promotionAction:self.info];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"赠送记录";
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
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView reloadData];
}


#pragma mark - request

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell.contentView removeAllSubviews];
        
        UIView * backView= [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, cell.hd_height)];
        backView.backgroundColor = UIColorFromRGB(0xffffff);
        backView.layer.cornerRadius = 5;
        backView.layer.masksToBounds = YES;
        [cell.contentView addSubview:backView];
        
        UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, backView.hd_width, backView.hd_width * 0.5)];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[self.info objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
        [backView addSubview:iconImageView];
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(iconImageView.frame), 100, 15)];
        label1.text = [NSString stringWithFormat:@"%@", [self.info objectForKey:@"title"]];
        label1.textColor = UIColorFromRGB(0x333333);
        label1.font = kMainFont;
        [backView addSubview:label1];
        [label1 sizeToFit];
        
        UILabel * maxLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame) + 10, 100, 15)];
        maxLB.text = [NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, [self.info objectForKey:@"price"]];
        maxLB.textColor = kCommonMainOringeColor;
        maxLB.font = kMainFont;
        [backView addSubview:maxLB];
        
        return cell;
    }else if (indexPath.section == 1)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell.contentView removeAllSubviews];
        
        UIView * backView= [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, cell.hd_height)];
        backView.backgroundColor = UIColorFromRGB(0xffffff);
        backView.layer.cornerRadius = 5;
        backView.layer.masksToBounds = YES;
        [cell.contentView addSubview:backView];
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 15)];
        label1.text = @"赠送留言";
        label1.textColor = UIColorFromRGB(0x333333);
        label1.font = kMainFont;
        [backView addSubview:label1];
        [label1 sizeToFit];
        
        UILabel * maxLB = [[UILabel alloc]initWithFrame:CGRectMake(10 + CGRectGetMaxX(label1.frame), 12, 100, 13)];
        maxLB.text = @"(最多可以输入20个字)";
        maxLB.textColor = UIColorFromRGB(0x999999);
        maxLB.font = kMainFont_12;
        [backView addSubview:maxLB];
        [maxLB sizeToFit];
        
        self.tf = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame) + 15, backView.hd_width - 20, 20)];
        self.tf.placeholder = @"如：送你一份新课程~快来跟我一起学习吧";
        self.tf.textColor = UIColorFromRGB(0x333333);
        self.tf.font = kMainFont;
        self.tf.returnKeyType = UIReturnKeyDone;
        self.tf.delegate = self;
        [backView addSubview:self.tf];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tf.frame) + 5, backView.hd_width - 20, 1)];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [backView addSubview:line];
        
        return cell;
    }
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [cell.contentView removeAllSubviews];
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(10, 0, kScreenWidth - 20, 40);
    sendBtn.backgroundColor = kCommonMainBlueColor;
    sendBtn.layer.cornerRadius = 5;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn setTitle:@"赠送好友" forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    sendBtn.titleLabel.font = kMainFont;
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:sendBtn];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (kScreenWidth - 20) * 0.5 + 60;
    }else if (indexPath.section == 1)
    {
        return 76;
    }
    return 40;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = textField.text.length > 20 ? [textField.text substringToIndex:20] : textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
//    if (self.tf.text.length == 0) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"留言不能为空" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }]];
//        [self.navigationController presentViewController:alert animated:YES completion:nil];
//        return;
//    }
    [self shareAction];
}

#pragma mark - request


- (void)promotionAction:(NSDictionary *)info
{
    self.shareInfo = [info objectForKey:@"share"];
    [self getShareInfo:self.shareInfo];
}

- (void)getShareInfo:(NSDictionary *)info
{
    __weak typeof(self)weakSelf = self;
    NSDictionary * shareInfo = info;
    self.shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 1000, 100, 100)];
    [self.view addSubview:self.shareImageView];
    self.shareImageView.hidden = YES;
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[shareInfo objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"图片下载成功");
    }];
    
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

-(void)presentSuccess:(NSNotification *)notification
{
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/give/message",@"record_id":[self.info objectForKey:@"id"],@"message":[UIUtility judgeStr:self.tf.text]} withNotifiedObject:self];
}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD showSuccessWithStatus:@"赠送成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self backAction:nil];
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
