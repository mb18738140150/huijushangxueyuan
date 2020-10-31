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

@interface JoinAssociationViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_JoinAssociation>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;
@property (nonatomic, assign)int page;

@property (nonatomic, strong)NSDictionary * associationInfo;

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
    [self.tableView registerClass:[AssociationCommentTableViewCell class] forCellReuseIdentifier:kAssociationCommentTableViewCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenHeight, 50)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:bottomView];
    
    UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame = CGRectMake(40, 5, kScreenWidth - 80, 40);
    joinBtn.layer.cornerRadius = 5;
    joinBtn.layer.masksToBounds = YES;
    joinBtn.backgroundColor = kCommonMainBlueColor;
    [joinBtn setTitle:@"进入社群" forState:UIControlStateNormal];
    [joinBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    joinBtn.titleLabel.font = kMainFont;
    [bottomView addSubview:joinBtn];
    [joinBtn addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadData
{
    self.page = 1;
    [SVProgressHUD show];
    [[UserManager sharedManager] getJoinAssociationWith:@{kUrlName:@"api/community/communityinfoandJoin",@"c_id":[self.infoDic objectForKey:@"id"],kRequestType:@"get",@"include":@"share,dynamics"} withNotifiedObject:self];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.itemArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 1) {
        AssociationCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationCommentTableViewCell forIndexPath:indexPath];
        [cell refreshUIWith:self.itemArray[indexPath.row] andIsCanOperation:NO];
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

- (void)joinAction
{
    AssociationDetailViewController * vc = [[AssociationDetailViewController alloc]init];
    vc.infoDic = self.infoDic;
    [self.navigationController pushViewController:vc animated:YES];
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

@end
