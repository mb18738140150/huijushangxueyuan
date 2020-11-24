//
//  ArticleDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/20.
//

#import "ArticleDetailViewController.h"
#import "ArticleHeadTableViewCell.h"
#define kArticleHeadTableViewCell @"ArticleHeadTableViewCell"
#import "ArticleAudioTableViewCell.h"
#define kArticleAudioTableViewCell @"ArticleAudioTableViewCell"
#import "ArticleVideoTableViewCell.h"
#define kArticleVideoTableViewCell @"ArticleVideoTableViewCell"
#import "ZXVideo.h"
#import "SecondListTableViewCell.h"
#define kSecondListTableViewCell @"SecondListTableViewCell"
#import "ArticleCommentTableViewCell.h"
#define kArticleCommentTableViewCell @"ArticleCommentTableViewCell"
#import "AddCommentView.h"
#import "BTVoicePlayer.h"
#import "MainVipCardListViewController.h"
#import "ArticleImageTableViewCell.h"
#define kArticleImageTableViewCell @"ArticleImageTableViewCell"
#import "ArticleCategoryTableViewCell.h"
#define kArticleCategoryTableViewCell @"ArticleCategoryTableViewCell"
#import "SecongListViewController.h"

#import "ShareClickView.h"
#import "ShareAndPaySelectView.h"
#import "AssociationListTableViewCell.h"
#define kAssociationListTableViewCell @"AssociationListTableViewCell"
#import "JoinAssociationViewController.h"
#import "BuyCourseSendViewController.h"

typedef enum : NSUInteger {
    ArticleType_article,
    ArticleType_image,
    ArticleType_audio,
    ArticleType_video,
} ArticleType;

@interface ArticleDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_CourseDetailProtocol,UserModule_CommentZanProtocol, UserModule_AddCommentProtocol,ChangeMusicProtocol,WKUIDelegate,WKNavigationDelegate,UserModule_PayOrderProtocol,UserModule_PayOrderByCoinProtocol>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic, strong)NSDictionary * courseDetailInfo;

@property(nonatomic,strong)LXAVPlayView *playerview;
@property(nonatomic,strong)UIView *playFatherView;
@property (nonatomic,strong) ZXVideo                            *playingVideo;

@property (nonatomic, strong)ZWMSegmentView * courseSegmrnt;

@property (nonatomic, strong)UILabel * currentLB;
@property (nonatomic, strong)UILabel * durationLB;
@property (nonatomic, strong)UISlider *progressSlider;
@property (nonatomic, strong)UIButton * payStateBtn;
@property (nonatomic, strong)CategoryView * storeView;

@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, assign)CGFloat webViewHeight;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong)NSMutableArray * urlDictsArray;
@property (nonatomic, strong)NSString * detailHtml;

@property (nonatomic, assign) BOOL isShowAllContent; // 是否展示全部内容
@property (nonatomic, assign)PayStateType payStateType; // 支付类型
@property (nonatomic, assign)ArticleType articleType; // 文章类型
@property (nonatomic, assign)int free_Num;// 试看 时长或者免费展示图片张数
@property (nonatomic, strong)NSString * desc;// 描述(购买前)
@property (nonatomic, strong)NSString * content;// 内容(购买后)
@property (nonatomic, strong)NSMutableArray * images;// 内容(购买后)

@property (nonatomic, strong)UIImageView * shareImageView;

@property (nonatomic, strong)ShareClickView * shareView;
@property (nonatomic, assign)BOOL isWechat;

@property (nonatomic, strong)ShareAndPaySelectView * payView;

@property (nonatomic, strong)NSMutableArray * communities;

@end

@implementation ArticleDetailViewController

- (NSMutableArray *)communities
{
    if (!_communities) {
        _communities = [NSMutableArray array];
    }
    return _communities;
}

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)urlDictsArray
{
    if (!_urlDictsArray) {
        _urlDictsArray = [NSMutableArray array];
    }
    return _urlDictsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationViewSetup];
    self.webViewHeight = 0;
    [self doResetQuestionRequest];
    [self prepareUI];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giveAction) name:kNotificationOfSendCourse object:nil];

}

#pragma mark - pay

- (void)coinBuyAction
{
    [SVProgressHUD show];
    [[UserManager sharedManager]payOrderByCoinWith:@{kUrlName:@"api/applePay/article",@"article_id":[NSString stringWithFormat:@"%@", [self.infoDic objectForKey:@"id"]]} withNotifiedObject:self];
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

- (void)paySuccedsss:(NSNotification *)notification
{
    NSLog(@"paySuccedsss");
    [self doResetQuestionRequest];
}

- (void)payClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [self.payView removeFromSuperview];
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_wechatPay) {
        NSLog(@"微信支付");
        self.isWechat = YES;
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/article",@"article_id":[NSString stringWithFormat:@"%@", [self.infoDic objectForKey:@"id"]],@"pay_type":@"wechat"} withNotifiedObject:self];
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_zhifubPay)
    {
        self.isWechat = NO;
        NSLog(@"支付宝支付");
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/article",@"article_id":[NSString stringWithFormat:@"%@", [self.infoDic objectForKey:@"id"]],@"pay_type":@"alipay"} withNotifiedObject:self];
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_shareFriend)
    {
        
        NSDictionary * shareInfo = [self.courseDetailInfo objectForKey:@"share"];
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
        NSDictionary * shareInfo = [self.courseDetailInfo objectForKey:@"share"];
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


// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"";
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
    [self.tableView registerClass:[ArticleHeadTableViewCell class] forCellReuseIdentifier:kArticleHeadTableViewCell];
    [self.tableView registerClass:[ArticleVideoTableViewCell class] forCellReuseIdentifier:kArticleVideoTableViewCell];
    [self.tableView registerClass:[ArticleAudioTableViewCell class] forCellReuseIdentifier:kArticleAudioTableViewCell];
    [self.tableView registerClass:[SecondListTableViewCell class] forCellReuseIdentifier:kSecondListTableViewCell];
    [self.tableView registerClass:[ArticleCommentTableViewCell class] forCellReuseIdentifier:kArticleCommentTableViewCell];
    [self.tableView registerClass:[ArticleCategoryTableViewCell class] forCellReuseIdentifier:kArticleCategoryTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableView registerClass:[ArticleImageTableViewCell class] forCellReuseIdentifier:kArticleImageTableViewCell];
    [self.tableView registerClass:[AssociationListTableViewCell class] forCellReuseIdentifier:kAssociationListTableViewCell];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
        
    __weak typeof(self)weakSelf = self;
    self.shareView = [[ShareClickView alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 40, 60, 30)];
    [self.view addSubview:self.shareView];
    self.shareView.shareBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf shareAction];
    };
    
    
    self.playingVideo = [[ZXVideo alloc] init];
    // 视频 player
    self.playerview =[[LXAVPlayView alloc]init];
   self.playerview.isLandScape = YES;
    self.playerview.isAutoReplay = NO;
    [self.playerview hiddenTopView];
    self.playerview.backBlock = ^(NSDictionary *info) {
        NSLog(@"***** \n%@", info);
        
        if (weakSelf.playerview) {
            [weakSelf.playerview destroyPlayer];
            weakSelf.playerview = nil;
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [weakSelf dismissViewControllerAnimated:YES completion:^(void){
            
        }];
    };
    self.playerview.CurrentTimeBlock = ^(int time) {
        if (weakSelf.payStateType != PayStateType_free) {
            if (time > weakSelf.free_Num) {
                [weakSelf.playerview pause];
                [weakSelf.tableView reloadData];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请购买课程后继续学习" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [weakSelf.navigationController presentViewController:alert animated:YES completion:nil];
            }
        }
    };
    
    
    // 分类
    self.courseSegmrnt = [[ZWMSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.hd_width, 44) titles:@[@"推荐",@"评论"]];
    
    _courseSegmrnt.backgroundColor=[UIColor whiteColor];
    _courseSegmrnt.indicateColor = kCommonMainBlueColor;
    [_courseSegmrnt selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
        NSLog(@"%ld *** %@", index,button.titleLabel.text);
        
        [weakSelf reloadDataWithSegmentIndex:index];
    }];
    
    // 音频 manager
    [BTVoicePlayer share].getMusicProgressBlock = ^(NSDictionary *infoDic) {
        [weakSelf getMusicProgress:infoDic];
    };
    [BTVoicePlayer share].delegate = self;
    
    // 底部购买按钮
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenWidth, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:separateView];
    
    _payStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payStateBtn.frame = CGRectMake(15, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 45, kScreenWidth - 30, 40);
    [_payStateBtn setTitle:@"免费" forState:UIControlStateNormal];
    _payStateBtn.backgroundColor = kCommonMainBlueColor;
    _payStateBtn.layer.cornerRadius = _payStateBtn.hd_height / 2;
    _payStateBtn.layer.masksToBounds = YES;
    [_payStateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_payStateBtn addTarget:self action:@selector(playStateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payStateBtn];


    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(0, _payStateBtn.hd_y, 60, 40)];
    cateView.pageType = Page_sendCourse;
    cateView.info = @{@"id":@(1)};
    cateView.categoryName = @"赠送好友";
    cateView.categoryCoverUrl = @"main_赠送记录";
    [cateView setupSmallContent];
    [self.view addSubview:cateView];
    self.storeView = cateView;
    self.storeView.hidden = YES;
    
    
    
    
    // webview
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}



- (void)reloadDataWithSegmentIndex:(NSUInteger)index
{
    if (index == 0) {
        self.dataSource = [[self.courseDetailInfo objectForKey:@"recommend"] objectForKey:@"data"];
    }else
    {
        self.dataSource = [[self.courseDetailInfo objectForKey:@"common"] objectForKey:@"data"];
    }
    
    self.communities = [[self.courseDetailInfo objectForKey:@"communities"] objectForKey:@"data"];
    self.navigationItem.title = [self.courseDetailInfo objectForKey:@"title"];
    
    NSDictionary * purchase = [self.courseDetailInfo objectForKey:@"purchase"];
    NSString * type = [purchase objectForKey:@"type"];
    if ([type isEqualToString:@"free"]) {
        [_payStateBtn setTitle:@"免费" forState:UIControlStateNormal];
        self.isShowAllContent = YES;
        self.payStateType = PayStateType_free;
    }else if ([type isEqualToString:@"purchased"])
    {
        [_payStateBtn setTitle:@"已购买" forState:UIControlStateNormal];
        self.isShowAllContent = YES;
        self.payStateType = PayStateType_free;
    }else if ([type isEqualToString:@"vip-free"])
    {
        [_payStateBtn setTitle:@"会员免费观看" forState:UIControlStateNormal];
        self.isShowAllContent = YES;
        self.payStateType = PayStateType_free;
    }else if ([type isEqualToString:@"plain"])
    {
        NSDictionary * info = [purchase objectForKey:@"info"];
        [_payStateBtn setTitle:[NSString stringWithFormat:@"%@%@", [SoftManager shareSoftManager].coinName, [info objectForKey:@"money"]] forState:UIControlStateNormal];
        self.isShowAllContent = NO;
        self.payStateType = PayStateType_buy;
    }
    else if ([type isEqualToString:@"vip-discount"])
    {
        NSDictionary * info = [purchase objectForKey:@"info"];
        float price = [[info objectForKey:@"money"] floatValue] * [[info objectForKey:@"discount"] floatValue];
        [_payStateBtn setTitle:[NSString stringWithFormat:@"%@%.2f", [SoftManager shareSoftManager].coinName, price] forState:UIControlStateNormal];
        self.isShowAllContent = NO;
        self.payStateType = PayStateType_buy;
    }
    else if ([type isEqualToString:@"need_vip"])
    {
        [_payStateBtn setTitle:@"开通会员免费观看" forState:UIControlStateNormal];
        self.isShowAllContent = NO;
        self.payStateType = PayStateType_Vip;
    }else
    {
        [_payStateBtn setTitle:@"免费" forState:UIControlStateNormal];
        self.isShowAllContent = YES;
        self.payStateType = PayStateType_free;
    }
    
    if ([[self.courseDetailInfo objectForKey:@"give"] boolValue]) {
        
        if([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue])
        {
            NSLog(@"storeView hidden");
            self.storeView.hidden = NO;
            
            self.payStateBtn.frame = CGRectMake(CGRectGetMaxX(_storeView.frame), kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 45, kScreenWidth - 15 - 60, 40);
        }
    }
    
    
    self.desc = [self.courseDetailInfo objectForKey:@"desc"];
    self.content = [self.courseDetailInfo objectForKey:@"content"];
    NSDictionary * articleTypeInfo = [self.courseDetailInfo objectForKey:@"info"];
    NSString * articleType = [self.courseDetailInfo objectForKey:@"type"];
    if ([articleType isEqualToString:@"article"]) {
        self.articleType = ArticleType_article;
        self.desc = [articleTypeInfo objectForKey:@"desc"];
        self.content = [articleTypeInfo objectForKey:@"content"];
    }else if ([articleType isEqualToString:@"image"])
    {
        self.articleType = ArticleType_image;
        
        [self.images removeAllObjects];
        for (NSString * imageUrl in [articleTypeInfo objectForKey:@"images"]) {
            NSMutableDictionary * imageInfo = [NSMutableDictionary dictionary];
            [imageInfo setValue:imageUrl forKey:@"thumb"];
            [imageInfo setValue:@0 forKey:@"height"];
            [self.images addObject:imageInfo];
        }
        
        self.free_Num = [[articleTypeInfo objectForKey:@"free_num"] intValue];
    }else if ([articleType isEqualToString:@"audio"])
    {
        self.articleType = ArticleType_audio;
        self.free_Num = [[articleTypeInfo objectForKey:@"free_num"] intValue];
    }else if ([articleType isEqualToString:@"video"])
    {
        self.articleType = ArticleType_video;
        self.free_Num = [[articleTypeInfo objectForKey:@"free_num"] intValue];
    }
 
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    
    NSString * htmlStr = @"";
    if (self.isShowAllContent) {
        htmlStr = [UIUtility judgeStr:self.content];
        if (htmlStr.length <= 0) {
            htmlStr = [UIUtility judgeStr:self.desc];
        }
    }else
    {
        htmlStr =  [UIUtility judgeStr:self.desc];
    }
    
    [self testLoadHtmlImage:[headerString stringByAppendingString:[htmlStr stringByDecodingHTMLEntities]]];
    
    [self.tableView reloadData];
}

- (void)doResetQuestionRequest
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getCourseDetailWith:@{kUrlName:@"api/article/info",@"article_id":[self.infoDic objectForKey:@"id"]} withNotifiedObject:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.dataSource.count;
    }
    else if (section == 1)
    {
        if ([[[self.courseDetailInfo objectForKey:@"categories"] objectForKey:@"data"] count] > 0) {
            return 1;
        }
        return 0;
    }else if (section == 3)
    {
        return self.communities.count;
    }
    
    if (self.isShowAllContent) {
        // 全部展示
        if (self.articleType == ArticleType_article) {
            return 2;
        }else if (self.articleType == ArticleType_image)
        {
            return self.images.count + 2;
        }else
        {
            return 3;
        }
    }else
    {
        // 部分展示
        if (self.articleType == ArticleType_article) {
            return 2;
        }else if (self.articleType == ArticleType_image)
        {
            return self.free_Num + 2;
        }else
        {
            return 3;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ArticleHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kArticleHeadTableViewCell forIndexPath:indexPath];
            [cell refreshUIWith:self.courseDetailInfo];
            return cell;
        }
        if(self.articleType == ArticleType_image){
            if (self.isShowAllContent) {
                if (indexPath.row == self.images.count + 1) {
                    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
                    [cell.contentView removeAllSubviews];
                    [cell.contentView addSubview:self.webView];
                    return cell;
                }
            }else
            {
                if (indexPath.row == self.free_Num + 1) {
                    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
                    [cell.contentView removeAllSubviews];
                    [cell.contentView addSubview:self.webView];
                    return cell;
                }
            }
            
            ArticleImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kArticleImageTableViewCell forIndexPath:indexPath];
            
            NSDictionary * imageInfo = [self.images objectAtIndex:indexPath.row - 1];
            cell.imageHeight = [[imageInfo objectForKey:@"height"] floatValue];
            [cell refreshUIWith:imageInfo];
            
            cell.getImageHeightBlock = ^(CGFloat height) {
                NSMutableDictionary * mImageInfo = weakSelf.images[indexPath.row - 1];
                [mImageInfo setValue:@(height) forKey:@"height"];
                
                [weakSelf.tableView reloadData];
            };
            
            return cell;
            
        }else if (self.articleType == ArticleType_article)// 展示web
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
            [cell.contentView removeAllSubviews];
            [cell.contentView addSubview:self.webView];
            return cell;
        }else
        {
            if (indexPath.row == 1) {
                // 视频
                if (self.articleType == ArticleType_video) {
                    ArticleVideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kArticleVideoTableViewCell forIndexPath:indexPath];
                    [cell refreshUIWith:self.courseDetailInfo];
                    
                    if ([self.playerview getPlayRate] > 0) {
                        [cell hideAllView];
                        self.playFatherView = cell.backView;
                        self.playerview.currentModel.fatherView = self.playFatherView;
                        [self.playerview addPlayerToFatherView:self.playerview.currentModel.fatherView];
                    }
                    
                    __weak typeof(cell)weakCell = cell;
                    cell.playActionBlock = ^(NSDictionary * _Nonnull info) {
                        [weakCell hideAllView];
                        weakSelf.playFatherView = weakCell.backView;
                        weakSelf.playingVideo.playUrl = [[weakSelf.courseDetailInfo objectForKey:@"info"] objectForKey:@"video"];
                        [weakSelf playVideo];
                    };
                    
                    return cell;
                }else// 音频
                {
                    ArticleAudioTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kArticleAudioTableViewCell forIndexPath:indexPath];
                    [cell refreshUIWith:self.courseDetailInfo];
                    cell.playActionBlock = ^(NSDictionary * _Nonnull info) {
                        
                        if ([[BTVoicePlayer share] isPlaying]) {
                            [[BTVoicePlayer share] pause];
                        }else
                        {
                            if ([[BTVoicePlayer share] isHavePlayContent]) {
                                [[BTVoicePlayer share] playContinu];
                            }else
                            {
                                [[BTVoicePlayer share] playLine:[[weakSelf.courseDetailInfo objectForKey:@"info"] objectForKey:@"audio"]];
                            }
                        }
                        
                    };
                    self.currentLB = cell.currentLB;
                    self.durationLB = cell.durationLB;
                    self.progressSlider = cell.progressSlider;
                    
                    [self.progressSlider addTarget:self action:@selector(progressAction) forControlEvents:UIControlEventValueChanged];
                    return cell;
                }
            }else// 展示web
            {
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
                [cell.contentView removeAllSubviews];
                [cell.contentView addSubview:self.webView];
                return cell;
            }
        }
        
        
        
        
    }
    if (indexPath.section == 1) {
        ArticleCategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kArticleCategoryTableViewCell forIndexPath:indexPath];
        [cell refreshUIWith:self.courseDetailInfo];
        cell.categoryClickBLock = ^(NSDictionary * _Nonnull info) {
            NSLog(@"category = %@", info);
            SecongListViewController * vc = [[SecongListViewController alloc]init];
            vc.secondType = SecondListType_artical;
            vc.pid = [[info objectForKey:@"id"] intValue];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    if (indexPath.section == 2) {
        if (self.courseSegmrnt.index == 0) {
            SecondListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kSecondListTableViewCell forIndexPath:indexPath];
            [cell resetCellContent:self.dataSource[indexPath.row]];
            return cell;
        }else{
            ArticleCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kArticleCommentTableViewCell forIndexPath:indexPath];
            [cell refreshUIWith:self.dataSource[indexPath.row]];
            
            cell.zanBlock = ^(NSDictionary * _Nonnull info) {
                [weakSelf zanAction:info];
            };
            
            return cell;
        } 
    }
    if (indexPath.section == 3) {
        AssociationListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationListTableViewCell forIndexPath:indexPath];
        [cell resetCellContent:self.communities[indexPath.row]];
        [cell resetTitle];
        cell.cancelOrderLivingCourseBlock = ^(NSDictionary * _Nonnull info) {
            JoinAssociationViewController * vc = [[JoinAssociationViewController alloc]init];
            vc.infoDic = weakSelf.communities[indexPath.row];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString * titleStr = [self.courseDetailInfo objectForKey:@"title"];
            CGFloat titleHeight = [titleStr boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_16} context:nil].size.height;
            return titleHeight + 70;
        }else if (indexPath.row == 1)
        {
            if ([[self.courseDetailInfo objectForKey:@"type"] isEqualToString:@"video"]) {
                return (kScreenWidth - 30) * 9 / 16;
            }else if ([[self.courseDetailInfo objectForKey:@"type"] isEqualToString:@"audio"])
            {
                return 220;
            }
        }
        
        if(self.articleType == ArticleType_image){
            if (self.isShowAllContent) {
                if (indexPath.row == self.images.count + 1) {
                    return _webViewHeight;
                }
            }else
            {
                if (indexPath.row == self.free_Num + 1) {
                    return _webViewHeight;
                }
            }
            
            NSDictionary * imageInfo = [self.images objectAtIndex:indexPath.row - 1];
            return [[imageInfo objectForKey:@"height"] floatValue];
            
        }else if (self.articleType == ArticleType_article)// 展示web
        {
            return _webViewHeight;
        }else
        {
            if (indexPath.row == 1) {
                // 视频
                if (self.articleType == ArticleType_video) {
                return (kScreenWidth - 30) * 9 / 16;
                }else// 音频
                {
                    return 220;
                }
            }else// 展示web
            {
                return _webViewHeight;
            }
        }
        
    }else if (indexPath.section == 2)
    {
        if (self.courseSegmrnt.index == 0) {
            return 90;
        }else
        {
            NSDictionary * infoDic = self.dataSource[indexPath.row];
            NSString * content = [infoDic objectForKey:@"content"];
            CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
            
            if(![[infoDic objectForKey:@"reply"] isKindOfClass:[NSNull class]])
            {
                NSString * replay = [NSString stringWithFormat:@"回复：%@", [infoDic objectForKey:@"reply"]];
                CGFloat replayHeight = [replay boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
                
                return contentHeight + replayHeight + 75;
            }
            
            return contentHeight + 70;
        }
    }else if (indexPath.section == 1)
    {
        return 20;
    }else if (indexPath.section == 3)
    {
        return 80;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else if (section == 3)
    {
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        headView.backgroundColor = UIColorFromRGB(0xffffff);
        
        UILabel * titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 50)];
        titleLb.text = @"相关社群";
        titleLb.textColor = UIColorFromRGB(0x111111);
        titleLb.font = [UIFont boldSystemFontOfSize:16];
        [headView addSubview:titleLb];
        
        return headView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.hd_width, 65)];
    view.backgroundColor = [UIColor whiteColor];
    
    ZWMSegmentView * segment ;
    segment = self.courseSegmrnt;
    
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, 44, kScreenWidth - 30, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(15, CGRectGetMaxY(segment.frame), 40, 20);
    [commentBtn setImage:[UIImage imageNamed:@"comment_评论2"] forState:UIControlStateNormal];
    [commentBtn setTitle:[NSString stringWithFormat:@"%@", @"评论"] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = kMainFont_10;
    [commentBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:segment];
    [view addSubview:commentBtn];
    [view addSubview:seperateView];
    
    if (self.courseSegmrnt.index == 0 || self.payStateType != PayStateType_free) {
        commentBtn.hidden = YES;
    }else
    {
        commentBtn.hidden = NO;
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        if (self.courseSegmrnt.index == 0 || self.payStateType != PayStateType_free) {
            return 45;
        }else
        {
            return 65;
        }
    }else if (section == 3)
    {
        if (self.communities.count > 0) {
            return 50;
        }
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (self.courseSegmrnt.index == 0) {
            NSDictionary * info = self.dataSource[indexPath.row];
            ArticleDetailViewController * vc = [[ArticleDetailViewController alloc]init];
            vc.infoDic = info;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)giveAction
{
    BuyCourseSendViewController * vc = [[BuyCourseSendViewController alloc]init];
    vc.info = self.courseDetailInfo;
    vc.isArticle = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playStateAction
{
    if (self.payStateType == PayStateType_Vip) {
        
        if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue]) {
            
            MainVipCardListViewController * vc = [[MainVipCardListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            
        }
    }else if (self.payStateType == PayStateType_buy)
    {
        NSLog(@"buy");
        
        if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue]) {
            ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:NO];
            UIWindow * window = [UIApplication sharedApplication].delegate.window;
            [window addSubview:payView];
            self.payView = payView;
        }else
        {
            [self coinBuyAction];
        }
        
    }
}

#pragma mark - share
- (void)shareAction
{
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:YES];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
    self.payView = payView;
}


#pragma mark - comment & zan

- (void)addComment
{
    __weak typeof(self)weakSelf = self;
    AddCommentView * addCommentView = [[AddCommentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    addCommentView.sendBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf sendComment:info];
    };
    [window addSubview:addCommentView];
}

- (void)sendComment:(NSDictionary *)info
{
    NSString * commentContent = [info objectForKey:@"commentContent"];
    if (commentContent.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }else
    {
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestAddCommentWithCourseInfo:@{kUrlName:@"api/article/common",@"article_id":[self.courseDetailInfo objectForKey:@"id"],@"content":commentContent} withNotifiedObject:self];
    }
}

- (void)didRequestAddCommentSuccessed
{
    [SVProgressHUD dismiss];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"留言成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    [self doResetQuestionRequest];
}

- (void)didRequestAddCommentFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)zanAction:(NSDictionary *)info
{
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestCommentZantWithCourseInfo:@{kUrlName:@"api/article/commonZan",@"article_id":[info objectForKey:@"article_id"],@"common_id":[info objectForKey:@"id"]} withNotifiedObject:self];
}

-(void)didRequestCommentZanSuccessed
{
    [SVProgressHUD dismiss];
    [self doResetQuestionRequest];
}

- (void)didRequestCommentZanFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didCourseDetailSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.courseDetailInfo = [[UserManager sharedManager] getCourseDetailInfo];
    [self reloadDataWithSegmentIndex:self.courseSegmrnt.index];
    NSLog(@"self.courseDetailInfo = %@", self.courseDetailInfo);
    
    [self getShareInfo:self.courseDetailInfo];
    
}

- (void)didCourseDetailFailed:(NSString *)failedInfo
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

#pragma mark - play audio & video

- (void)playVideo
{
    LXPlayModel *model =[[LXPlayModel alloc]init];
    model.playUrl = self.playingVideo.playUrl;
    model.videoTitle = self.playingVideo.title;
    model.fatherView = self.playFatherView;
    self.playerview.currentModel = model;
}

- (void)getMusicProgress:(NSDictionary *)info
{
    /*
     currentTime = "4.000603";
     progress = "0.006084307096898556";
     totalTime = "10:57";
     */
    self.durationLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"totalTime"]];
    int current = [[info objectForKey:@"currentTime"] intValue];
    
    if (self.payStateType != PayStateType_free) {
        if (current > self.free_Num) {
            [[BTVoicePlayer share] stop];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请购买课程后继续学习" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
    
    NSString * min = (current / 60) > 9?[NSString stringWithFormat:@"%d", (current / 60)] : [NSString stringWithFormat:@"0%d", (current / 60)];
    NSString * sec = (current % 60) > 9?[NSString stringWithFormat:@"%d", (current % 60)] : [NSString stringWithFormat:@"0%d", (current / 60)];
    
    self.currentLB.text = [NSString stringWithFormat:@"%@:%@", min, sec];
    self.progressSlider.value = [[info objectForKey:@"progress"] doubleValue];
}

- (void)changeMusic
{
    
}

- (void)progressAction
{
    [[BTVoicePlayer share] seekToTime:self.progressSlider.value];
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (_webView.scrollView.contentSize.height > self.webViewHeight || _webView.scrollView.contentSize.height == 0) {
            _webViewHeight = _webView.scrollView.contentSize.height;
            _webView.frame = CGRectMake(0, 0, kScreenWidth, _webViewHeight);
            [_tableView reloadData];
        }
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
//    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable Result, NSError * _Nullable error) {
//        NSString * heightStr = [NSString stringWithFormat:@"%@", Result];
//        CGFloat height = heightStr.floatValue + 15;
//        self.webView.frame = CGRectMake(0, 0, kScreenWidth, height);
//        _webViewHeight = height;
//        [self.tableView reloadData];
//    }];
//
//    for(UIView * view in webView.subviews)
//    {
//        NSLog(@"%@", [view class]);
//        if ([view isKindOfClass:[NSClassFromString(@"WKScrollView") class]]) {
//            UIScrollView * scrollView = (UIScrollView *)view;
//            CGFloat height = scrollView.contentSize.height;
//            _webViewHeight = height;
//            self.webView.frame = CGRectMake(0, 0, kScreenWidth, height);
//            [self.tableView reloadData];
//        }
//
//    }
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //    decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    
//    NSMutableURLRequest *mutableRequest = [navigationAction.request mutableCopy];
//
//    NSDictionary *requestHeaders = navigationAction.request.allHTTPHeaderFields;
//
//    //我们项目使用的token同步的，cookie的话类似
//        if (requestHeaders[@"Referer"]) {
//            decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
//        } else {
//             //这里添加请求头，把需要的都添加进来
//            [mutableRequest setValue:@"https://h5.luezhi.com" forHTTPHeaderField:@"Referer"];
//                [webView loadRequest:mutableRequest];
//
//                decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
//            }
//
//    return;
    if([navigationAction.request.URL.absoluteString containsString:@"http"])
    {
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }else
    {
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

- (void)testLoadHtmlImage:(NSString *)html
{
    [self.urlDictsArray removeAllObjects];
    self.detailHtml = html;
    
    // @"<img.*src[^>]*/>"
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img.*?src[^>]*/>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
    
  //  NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
      NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"badge"];
  BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
      
      
    for (NSTextCheckingResult *item in result) {
      NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
      
      NSArray *tmpArray = nil;
      if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
        tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
      } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
        tmpArray = [imgHtml componentsSeparatedByString:@"src="];
      }
      
      if (tmpArray.count >= 2) {
        NSString *src = tmpArray[1];
        
        NSUInteger loc = [src rangeOfString:@"\""].location;
        if (loc != NSNotFound) {
          src = [src substringToIndex:loc];
          
          NSLog(@"正确解析出来的SRC为：%@", src);
          if (src.length > 0) {
            NSString *localPath = [docPath stringByAppendingPathComponent:[src MD5]];
  //            BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:nil];
            // 先将链接取个本地名字，且获取完整路径
            [urlDicts setObject:localPath forKey:src];
              
              [self.urlDictsArray addObject:urlDicts];
          }
        }
      }
    }
    
    // 遍历所有的URL，替换成本地的URL，并异步获取图片
    for (NSString *src in urlDicts.allKeys) {
      NSString *localPath = [urlDicts objectForKey:src];
        
      //根据本地路径获取图片
      UIImage *_image = [UIImage imageWithContentsOfFile:localPath];
      
      //把图片进行base64
      NSString * jpg = [self htmlForJPGImage:_image];
      //然后在替换scr
      html = [html stringByReplacingOccurrencesOfString:src withString:jpg];
        
      // 如果已经缓存过，就不需要重复加载了。
      if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        [self downloadImageWithUrl:src];
      }
    }
    
//    NSLog(@"%@", html);
    
    [self.webView loadHTMLString:html baseURL:nil];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)downloadImageWithUrl:(NSString *)src {
  // 注意：这里并没有写专门下载图片的代码，就直接使用了AFN的扩展，只是为了省麻烦而已。
  UIImageView *imgView = [[UIImageView alloc] init];
    imgView.hidden = YES;
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:imgView];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSData *data = UIImagePNGRepresentation(image);
            NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"badge"];
            BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSString *localPath = [docPath stringByAppendingPathComponent:[src MD5]];
            
            if (![data writeToFile:localPath atomically:NO]) {
                NSLog(@"写入本地失败：%@", src);
            }else
            {
                for (NSDictionary * urlDic in self.urlDictsArray) {
                    if ([urlDic.allKeys containsObject:src]) {
                        NSString * jpg = [self htmlForJPGImage:image];
                        //然后在替换scr
                        self.detailHtml = [self.detailHtml stringByReplacingOccurrencesOfString:src withString:jpg];
                        [self.webView loadHTMLString:self.detailHtml baseURL:nil];
                    }
                }
            }
        }
    }];
  
  if (self.imageViews == nil) {
    self.imageViews = [[NSMutableArray alloc] init];
  }
  [self.imageViews addObject:imgView];
}


- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return imageSource;

}


- (void)dealloc
{
    if (self.playerview) {
        [self.playerview destroyPlayer];
        self.playerview = nil;
    }
    [[BTVoicePlayer share] stop];
    
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    NSLog(@"界面释放了");
}


@end
