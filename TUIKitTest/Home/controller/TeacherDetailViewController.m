//
//  TeacherDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import "TeacherDetailViewController.h"
#import "TeacherArticleTableViewCell.h"
#define kTeacherArticleTableViewCell @"TeacherArticleTableViewCell"
#import "TeacherListTableViewCell.h"
#define kTeacherListTableViewCell @"TeacherListTableViewCell"
#import "TeacherDescViewController.h"
#import "ArticleDetailViewController.h"
#import "LivingCourseDetailViewController.h"
#import "ShareAndPaySelectView.h"

@interface TeacherDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_TeacherDetailProtocol>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * articleSource;
@property (nonatomic, strong)NSMutableArray * topicSource;
@property (nonatomic, strong)NSDictionary * teacherInfo;

@property (nonatomic, strong)UIImageView * shareImageView;

@end

@implementation TeacherDetailViewController

- (NSMutableArray *)articleSource
{
    if (!_articleSource) {
        _articleSource = [NSMutableArray array];
    }
    return _articleSource;;
}

- (NSMutableArray *)topicSource
{
    if (!_topicSource) {
        _topicSource  = [NSMutableArray array];
    }
    return _topicSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self loadData];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];

}

- (void)payClick:(NSNotification *)notification
{
    
    NSDictionary *infoDic = notification.object;
     if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_shareFriend)
    {
        
        NSDictionary * shareInfo = [self.teacherInfo objectForKey:@"share"];
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
        NSDictionary * shareInfo = [self.teacherInfo objectForKey:@"share"];
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

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"导师主页";
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
    [SVProgressHUD show];
    [[UserManager sharedManager] getTeacherDetailWith:@{kUrlName:@"api/teacher/info",@"requestType":@"get",@"teacher_id":[self.info objectForKey:@"id"]} withNotifiedObject:self];
}

- (void)prepareUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TeacherListTableViewCell class] forCellReuseIdentifier:kTeacherListTableViewCell];
    [self.tableView registerClass:[TeacherArticleTableViewCell class] forCellReuseIdentifier:kTeacherArticleTableViewCell];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

#pragma mark - share
- (void)shareAction
{
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:YES];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return self.articleSource.count;
    }
    return self.topicSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        TeacherArticleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTeacherArticleTableViewCell forIndexPath:indexPath];
        
        NSArray * dataArray ;
        if (indexPath.section == 1) {
            dataArray = self.articleSource;
        }else
        {
            dataArray = self.topicSource;
        }
        
        CellCornerType cellType = CellCornerType_none;
        if (indexPath.row == dataArray.count - 1) {
            
            cellType = CellCornerType_bottom;
        }
        [cell refreshUIWith:dataArray[indexPath.row] andCornerType:cellType];
        
        return cell;
    }
    
    __weak typeof(self)weakSelf = self;
    TeacherListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTeacherListTableViewCell forIndexPath:indexPath];
    [cell refreshHeadUIWith:self.teacherInfo andCornerType:CellCornerType_none];
    
    cell.shareBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf shareAction];
    };
    cell.checkDetailBlock = ^(NSDictionary * _Nonnull info) {
        NSLog(@"detail");
        TeacherDescViewController * vc = [[TeacherDescViewController alloc]init];
        vc.info = weakSelf.teacherInfo;
        vc.titleStr = @"老师介绍";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString * htmlString = [UIUtility judgeStr:[self.teacherInfo objectForKey:@"desc"]];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ,NSFontAttributeName:kMainFont} documentAttributes:nil error:nil];
        if (attrStr.length > 0) {
            CGFloat height = [attrStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 45, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
            if (height > 35) {
                height = 35;
            }
            CGFloat space = height > 0 ? 15 : 0;
            
            return 100 + space + height;
        }
        return 100;
    }
    
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 50)];
    backView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, tableView.hd_width - 20, 50)];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    [backView addSubview:headView];
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:headView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = headView.bounds;
    layer.path = path.CGPath;
    [headView.layer setMask:layer];
    
    UILabel * titleView = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 12, 120, 25)];
    titleView.font = kMainFont;
    titleView.textColor = UIColorFromRGB(0x333333);
    [headView addSubview:titleView];
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(headView.hd_width - 60, 15, 50, 20);
    moreBtn.hd_centerY = titleView.hd_centerY;
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [moreBtn setTitleColor:UIColorFromRGB(0x3D3731) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];

//    [headView addSubview:moreBtn];
    
    if (section == 1) {
        titleView.text = @"图文";
        [moreBtn addTarget:self action:@selector(moreArticleAction) forControlEvents:UIControlEventTouchUpInside];
    }else if (section == 2)
    {
        titleView.text = @"直播";
        [moreBtn addTarget:self action:@selector(MoreTopicAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, 49, headView.hd_width - 30, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [headView addSubview:seperateView];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    if (section == 1) {
        if (self.articleSource.count == 0) {
            return 0;;
        }else
        {
            return 50;
        }
    }
    if (self.topicSource.count == 0) {
        return 0;;
    }else
    {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ArticleDetailViewController * vc = [[ArticleDetailViewController alloc]init];
        vc.infoDic = self.articleSource[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2)
    {
        LivingCourseDetailViewController * vc = [[LivingCourseDetailViewController alloc]init];
        vc.info = self.topicSource[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)moreArticleAction
{
    NSLog(@"更多图文");
}

- (void)MoreTopicAction
{
    NSLog(@"更多直播");
}

- (void)didTeacherDetailSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.teacherInfo = [[UserManager sharedManager] getTeacherDetailInfo];
    self.articleSource = [[self.teacherInfo objectForKey:@"article"] objectForKey:@"data"];
    self.topicSource = [[self.teacherInfo objectForKey:@"topic"] objectForKey:@"data"];
    [self.tableView reloadData];
    
    [self getShareInfo:self.teacherInfo];
}

- (void)didTeacherDetailFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
- (void)getShareInfo:(NSDictionary *)info
{
    NSDictionary * shareInfo = [info objectForKey:@"share"];
    self.shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:self.shareImageView];
    self.shareImageView.hidden = YES;
    
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[shareInfo objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
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
