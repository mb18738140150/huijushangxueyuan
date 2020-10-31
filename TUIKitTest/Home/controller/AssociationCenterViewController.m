//
//  AssociationCommentDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "AssociationCenterViewController.h"
#import "JoinAssociationHeadTableViewCell.h"
#define kJoinAssociationHeadTableViewCell @"JoinAssociationHeadTableViewCell"
#import "AssociationMemberListViewController.h"
#import "AssociationAdminInfoTableViewCell.h"
#define kAssociationAdminInfoTableViewCell @"AssociationAdminInfoTableViewCell"
#import "AssociationDetailViewController.h"

@interface AssociationCenterViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UserModule_CompleteUserInfoProtocol>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;
@property (nonatomic, strong)UITextField * nameTf;
@end

@implementation AssociationCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self navigationViewSetup];
    [self prepareUI];
    [self getShareInfo:self.infoDic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"社群中心";
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
    
}

- (void)prepareUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    [self.tableView registerClass:[JoinAssociationHeadTableViewCell class] forCellReuseIdentifier:kJoinAssociationHeadTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableView registerClass:[AssociationAdminInfoTableViewCell class] forCellReuseIdentifier:kAssociationAdminInfoTableViewCell];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = kMainFont;
        
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的群昵称";
            self.nameTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth - 200, 10, 155, 30)];
            [cell.contentView addSubview:self.nameTf];
            self.nameTf.delegate = self;
            self.nameTf.font = kMainFont;
            self.nameTf.returnKeyType = UIReturnKeyDone;
            self.nameTf.backgroundColor = [UIColor whiteColor];
            self.nameTf.textColor = UIColorFromRGB(0x333333);
            self.nameTf.textAlignment = NSTextAlignmentRight;
            self.nameTf.text = [UIUtility judgeStr:[self.infoDic objectForKey:@"c_name"]];
        }else
        {
            cell.textLabel.text = @"群成员列表";
            UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame = cell.contentView.bounds;
            [cell.contentView addSubview:selectBtn];
            [selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIImageView * goImage = [[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.hd_width - 30, cell.hd_height / 2 - 6, 12, 12)];
        goImage.image = [UIImage imageNamed:@"箭头"];
        [cell.contentView addSubview:goImage];
        
        UIView * sortView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.hd_height - 1, kScreenWidth, 1)];
        sortView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell.contentView addSubview:sortView];
        
        return cell;
    }
    if (indexPath.row == 0) {
        AssociationAdminInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationAdminInfoTableViewCell forIndexPath:indexPath];
        [cell refreshUIWith:[self.infoDic objectForKey:@"admin_info"]];
        cell.joinBlock = ^(NSDictionary * _Nonnull info) {
            AssociationDetailViewController * vc = [[AssociationDetailViewController alloc]init];
            vc.infoDic = weakSelf.infoDic;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    JoinAssociationHeadTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kJoinAssociationHeadTableViewCell forIndexPath:indexPath];
    [titleCell resetCellContent:self.infoDic];
    titleCell.activeBlock = ^{
        [weakSelf shareAction];
    };
    
    return titleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 50;
    }
    if (indexPath.row == 0) {
        return 40;
    }
    return 280;
}

#pragma mark - changename

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameTf resignFirstResponder];
    
    NSLog(@"changeName  %@", textField.text);
    [SVProgressHUD dismiss];
    [[UserManager sharedManager] completeUserInfoWithDic:@{kUrlName:@"api/community/changecname",@"c_name":textField.text,@"c_id":[self.infoDic objectForKey:@"id"]} withNotifiedObject:self];
    
    return YES;
}

- (void)selectAction
{
    AssociationMemberListViewController * vc = [[AssociationMemberListViewController alloc]init];
    vc.infoDic = self.infoDic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didCompleteUserSuccessed
{
    [SVProgressHUD dismiss];
    
    [self.infoDic setObject:self.nameTf.text forKey:@"c_name"];
    [self.tableView reloadData];
}

- (void)didCompleteUserFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self.tableView reloadData];
}

#pragma mark - share

- (void)getShareInfo:(NSDictionary *)info
{
    NSDictionary * shareInfo = [info objectForKey:@"share"];
    self.shareInfo = shareInfo;
    self.shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:self.shareImageView];
    self.shareImageView.hidden = YES;
    
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[shareInfo objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
