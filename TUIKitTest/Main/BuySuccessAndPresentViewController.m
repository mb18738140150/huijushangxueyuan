//
//  PresentDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "BuySuccessAndPresentViewController.h"
#import "MyPresentRecordViewController.h"

@interface BuySuccessAndPresentViewController()<UITableViewDelegate, UITableViewDataSource,UserModule_SecondCategoryProtocol,UserModule_CategoryCourseProtocol,UserModule_MockVIPBuy>

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;

@property (nonatomic, strong)UITextField * tf;

@end

@implementation BuySuccessAndPresentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSuccess:) name:kNotificationOfPresentSuccess object:nil];
//    [self promotionAction:self.info];
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
        
        UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backView.hd_width / 2 - 10, 40, 20, 20)];
        iconImageView.image = [UIImage imageNamed:@"promotionCheck"];
        [backView addSubview:iconImageView];
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(iconImageView.frame) + 20, backView.hd_width - 20, 25)];
        label1.text = @"支付成功";
        label1.textColor = kCommonMainBlueColor;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont boldSystemFontOfSize:20];
        [backView addSubview:label1];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(backView.hd_width / 2 - 30, CGRectGetMaxY(label1.frame) + 50, 60, 1)];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [backView addSubview:line];
        
        UILabel * maxLB = [[UILabel alloc]initWithFrame:CGRectMake(backView.hd_width / 2 - 50, CGRectGetMaxY(line.frame) + 30, 100, 15)];
        maxLB.text = @"已购课程";
        maxLB.textColor = UIColorFromRGB(0x333333);
        maxLB.font = kMainFont;
        maxLB.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:maxLB];
        
        return cell;
    }else if (indexPath.section == 2)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell.contentView removeAllSubviews];
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 15)];
        label1.text = @"赠送须知";
        label1.textColor = UIColorFromRGB(0x333333);
        label1.font = kMainFont;
        [cell.contentView addSubview:label1];
        [label1 sizeToFit];
        
        UILabel * maxLB = [[UILabel alloc]initWithFrame:CGRectMake(10 , 10 + CGRectGetMaxY(label1.frame), kScreenWidth -  20, 15)];
        maxLB.text = @"1、购买后进入个人中心-赠送记录，赠送课程给好友";
        maxLB.textColor = UIColorFromRGB(0x999999);
        maxLB.font = kMainFont_12;
        [cell.contentView addSubview:maxLB];
        [maxLB sizeToFit];
        
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
    [sendBtn setTitle:@"去赠送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    sendBtn.titleLabel.font = kMainFont;
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:sendBtn];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 240;
    }else if (indexPath.section == 2)
    {
        return 60;
    }
    return 40;
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
    MyPresentRecordViewController * vc = [[MyPresentRecordViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
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


@end
