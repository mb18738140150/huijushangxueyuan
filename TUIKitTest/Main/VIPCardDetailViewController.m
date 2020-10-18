//
//  VIPCardDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import "VIPCardDetailViewController.h"
#import "VIPJurisdictionTableViewCell.h"
#define kVIPJurisdictionTableViewCell @"VIPJurisdictionTableViewCell"
#import "VIPCardTypeTableViewCell.h"
#define kVIPCardTypeTableViewCell @"VIPCardTypeTableViewCell"
#import "VIPCourseListViewController.h"

typedef enum : NSUInteger {
    BuyType_buy,
    BuyType_needVIP,
    BuyType_NO,
} BuyType;

@interface VIPCardDetailViewController ()<UITableViewDelegate, UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,UserModule_MyVIPCardDetailInfo>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic, strong)UIButton *applyBtn;

@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, assign)CGFloat webViewHeight;

@property (nonatomic, strong)NSDictionary * vipCardDetailInfo;
@property (nonatomic, strong)NSMutableArray * freeArray;

@property (nonatomic, assign)BuyType buyType;

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong)NSMutableArray * urlDictsArray;
@property (nonatomic, strong)NSString * detailHtml;

@end

@implementation VIPCardDetailViewController

- (NSMutableArray *)urlDictsArray
{
    if (!_urlDictsArray) {
        _urlDictsArray = [NSMutableArray array];
    }
    return _urlDictsArray;
}

- (NSMutableArray *)freeArray
{
    if (!_freeArray) {
        _freeArray = [NSMutableArray array];
    }
    return _freeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];

    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 45 - kNavigationBarHeight - kStatusBarHeight)];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
//    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
//
//
//    [_webView loadHTMLString:[headerString stringByAppendingString:@""] baseURL:nil];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self prepareUI];
    
    [self loadData];
}

- (void)loadData
{
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestMyVIPCardDetailWithInfo:@{kUrlName:@"api/vip/info",@"card_id":[self.info objectForKey:@"id"],@"include":@"my,need",@"requestType":@"get"} withNotifiedObject:self];
}

- (void)dealloc
{
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.webView stopLoading];
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    _webView.scrollView.delegate = nil;
    self.webView = nil;
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"会员卡详情";
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[VIPJurisdictionTableViewCell class] forCellReuseIdentifier:kVIPJurisdictionTableViewCell];
    [self.tableView registerClass:[VIPCardTypeTableViewCell class] forCellReuseIdentifier:kVIPCardTypeTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    UILabel * expiredLB = [[UILabel alloc]initWithFrame:CGRectMake(15, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 54, 100, 44)];
    expiredLB.textColor = UIColorFromRGB(0x999999);
    expiredLB.font = kMainFont_12;
    expiredLB.numberOfLines = 0;
    [self.view addSubview:expiredLB];
    expiredLB.hidden = YES;
    
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(15, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 54 , kScreenWidth - 30, 44);
    
    
    
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.applyBtn.bounds;
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.applyBtn.bounds;
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0xEBD5C0) CGColor],(id)[UIColorFromRGB(0xDBB293) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0, @0.5, @1]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0.5)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 0.5)];
    [gradientLayer addSublayer:gradientLayer1];
    [self.applyBtn.layer addSublayer:gradientLayer];
    
    [self.applyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0x55310A) forState:UIControlStateNormal];
    self.applyBtn.layer.cornerRadius = 5;
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.titleLabel.font = kMainFont_16;
    [self.view addSubview:self.applyBtn];
    
    if (self.myInfo) {
        // 当前为vip
        if ([[self.myInfo objectForKey:@"id"] intValue] == kVIPCardID.intValue && [[self.info objectForKey:@"id"] intValue] != kPartnerCardID.intValue) {
            expiredLB.hidden = NO;
            self.applyBtn.frame = CGRectMake(kScreenWidth / 2 + 15, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 54 , kScreenWidth / 2 - 30, 44);
            
            NSString * timeStr = [self.myInfo objectForKey:@"end_time"];
            timeStr = [[timeStr componentsSeparatedByString:@" "] firstObject];
            NSString * expireStr = [NSString stringWithFormat:@"到期时间\n%@",  timeStr];
            NSDictionary * attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
            NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:expireStr];
            [mStr addAttributes:attribute range:NSMakeRange(4, expireStr.length - 4)];
            expiredLB.attributedText = mStr;
            [self.applyBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        }
//        else if ([[self.myInfo objectForKey:@"id"] intValue] == kPartnerCardID.intValue)
//        {
//            self.applyBtn.hidden = YES;
//        }
    }
    
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)applyAction
{
    NSLog(@"购买 %@", self.info);
}

- (void)refreshData
{
    [self.freeArray removeAllObjects];
    int vip_type = [[self.vipCardDetailInfo objectForKey:@"vip_type"] intValue];
    int discount = [[self.vipCardDetailInfo objectForKey:@"discount"] intValue];
    if (vip_type == 3) {
        [self.freeArray addObject:@{@"image":@"main_免费专区",@"id":[self.vipCardDetailInfo objectForKey:@"id"],@"courseType":@1}];
    }else if(vip_type == 1 && discount == 0)
    {
        [self.freeArray addObject:@{@"image":@"main_免费专区",@"id":[self.vipCardDetailInfo objectForKey:@"id"],@"courseType":@1}];
    }else if (vip_type == 1 && discount == 1)
    {
        [self.freeArray addObject:@{@"image":@"main_免费专区",@"id":[self.vipCardDetailInfo objectForKey:@"id"],@"courseType":@1}];
        [self.freeArray addObject:@{@"image":@"main_折扣专区",@"id":[self.vipCardDetailInfo objectForKey:@"id"],@"courseType":@2}];
    }else if (vip_type == 2)
    {
        [self.freeArray addObject:@{@"image":@"main_免费专区",@"id":[self.vipCardDetailInfo objectForKey:@"id"],@"courseType":@1}];
        [self.freeArray addObject:@{@"image":@"main_折扣专区",@"id":[self.vipCardDetailInfo objectForKey:@"id"],@"courseType":@2}];
    }
    
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    
    NSString * htmlStr = [UIUtility judgeStr:[self.vipCardDetailInfo objectForKey:@"desc"]];
    
//    [_webView loadHTMLString:[headerString stringByAppendingString:[htmlStr stringByDecodingHTMLEntities]] baseURL:[NSURL URLWithString:@"https://h5.luezhi.com"]];
//    [_webView loadHTMLString:[htmlStr stringByDecodingHTMLEntities] baseURL:[NSURL URLWithString:@"https://qiniu.luezhi.com"]];
    
    [self testLoadHtmlImage:[headerString stringByAppendingString:[htmlStr stringByDecodingHTMLEntities]]];
    
    [self.tableView reloadData];
    
    NSDictionary * my = [self.vipCardDetailInfo objectForKey:@"my"];
    NSDictionary * need = [self.vipCardDetailInfo objectForKey:@"need"];
    
    NSString * vipCardId = [NSString stringWithFormat:@"%@", [self.vipCardDetailInfo objectForKey:@"id"]];
    if ([vipCardId isEqualToString:kPartnerCardID]) {
        // 该会员卡为合伙人，普通用户需要先获得购买vip，合伙人不得重复购买
        
        // need不为空，比较my与need的id，以及my与当前card的id
        if (my == nil || my.allKeys.count == 0) {
            // my为空，需要先购买vip
            self.buyType = BuyType_needVIP;
        }else if ([[my objectForKey:@"id"] isEqual:[need objectForKey:@"id"]])
        {
            // my的id等于need的id，可以直接购买
            self.buyType = BuyType_buy;
        }else if ([[my objectForKey:@"id"] isEqual:[self.vipCardDetailInfo objectForKey:@"id"]])
        {
            // 当前用户已经是合伙人，不能重复购买
            self.buyType = BuyType_NO;
        }
        
    }else if ([vipCardId isEqualToString:kVIPCardID])
    {
        // 该会员卡为vip，不论我现在身份是vip或者合伙人，或者普通用户，三者均可以直接购买
        self.buyType = BuyType_buy;
    }
    
    
    
    if (self.buyType == BuyType_NO) {
        self.applyBtn.hidden = YES;
    }else
    {
        self.applyBtn.hidden = NO;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.freeArray.count;
            break;
            
        default:
            break;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        VIPCardTypeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kVIPCardTypeTableViewCell forIndexPath:indexPath];
        [cell refreshUIWith:self.vipCardDetailInfo];
        return cell;
    }else if (indexPath.section == 1)
    {
        VIPJurisdictionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kVIPJurisdictionTableViewCell forIndexPath:indexPath];
        [cell resetUIWithInfo:self.freeArray[indexPath.row]];
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    [cell.contentView addSubview:self.webView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (tableView.hd_width - 35) / 3 + 67.5 + 40;
    }else if (indexPath.section == 1)
    {
        return 90;
    }
    return _webViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 10)];
    footView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;;
    }
    return 10;;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 40)];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(15, 11, 2, 13)];
    separateView.backgroundColor = UIColorFromRGB(0x333333);
    [headView addSubview:separateView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(separateView.frame) + 4, 10, 200, 15)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x333333);
    
    if (section == 1) {
        label.text = @"专享权益";
    }else if (section == 2)
    {
        label.text = @"会员卡简介";
    }
    [headView addSubview:label];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        VIPCourseListViewController * vc = [[VIPCourseListViewController alloc]init];
        vc.info = self.freeArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - vipcardDetail
- (void)didRequestMyVIPCardDetailInfoSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    
    self.vipCardDetailInfo = [[UserManager sharedManager] getVIPCardDetailInfo];
    [self refreshData];
}

- (void)didRequestMyVIPCardDetailInfoFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
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

@end
