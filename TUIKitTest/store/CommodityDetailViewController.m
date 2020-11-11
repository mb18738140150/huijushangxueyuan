//
//  CommodityDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import "CommodityDetailViewController.h"

#import "CommodityBannerTableViewCell.h"
#define kCommodityBannerTableViewCell @"CommodityBannerTableViewCell"
#import "CommodityInfoTableViewCell.h"
#define kCommodityInfoTableViewCell @"CommodityInfoTableViewCell"
#import "CategoryView.h"
#import "ShoppingCarViewController.h"


@interface CommodityDetailViewController ()<UITableViewDelegate, UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,UserModule_CourseDetailProtocol,UserModule_AddShoppingCarProtocol,UserModule_ShoppingCarListProtocol>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataSource;

@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, assign)CGFloat webViewHeight;

@property (nonatomic, strong)NSDictionary * goodDetailInfo;
@property (nonatomic, strong)NSMutableArray * freeArray;


@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong)NSMutableArray * urlDictsArray;
@property (nonatomic, strong)NSString * detailHtml;

@property (nonatomic, strong)CategoryView * storeView;
@property (nonatomic, strong)CategoryView * shoppingCarView;
@property (nonatomic, strong)UIButton *aaddShoppingCarBtn;
@property (nonatomic, strong)UIButton *applyBtn;

@property (nonatomic, assign)BOOL isApply;

@end

@implementation CommodityDetailViewController

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
    
    self.webViewHeight = 0;
    
    [self prepareUI];
    
    [self.tableView reloadData];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeClick:) name:kNotificationOfStoreAction object:nil];
}

- (void)loadData
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getCourseDetailWith:@{kUrlName:@"api/shop/good/detail",kRequestType:@"get",@"good_id":[self.info objectForKey:@"id"]} withNotifiedObject:self];
    [[UserManager sharedManager] didRequestShoppingCarListWith:@{kUrlName:@"api/shop/cart/lists",kRequestType:@"get"} withNotifiedObject:self ];
}

- (void)dealloc
{
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.webView stopLoading];
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    _webView.scrollView.delegate = nil;
    self.webView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOfStoreAction object:nil];
}



#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"商品详情";
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
    [self.tableView registerClass:[CommodityBannerTableViewCell class] forCellReuseIdentifier:kCommodityBannerTableViewCell];
    [self.tableView registerClass:[CommodityInfoTableViewCell class] forCellReuseIdentifier:kCommodityInfoTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenWidth, 50)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:bottomView];
    
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 5, 50, 40)];
    cateView.pageType = Page_Store;
    cateView.info = @{@"id":@(1)};
    cateView.categoryName = @"商城";
    cateView.categoryCoverUrl = @"商城";
    [cateView setupSmallContent];
    [bottomView addSubview:cateView];
    self.storeView = cateView;
    //main_icon
    
    
    self.shoppingCarView = [[CategoryView alloc] initWithFrame:CGRectMake(50, 5, 50, 40)];
    _shoppingCarView.pageType = Page_Store;
    _shoppingCarView.info = @{@"id":@(2)};
    _shoppingCarView.categoryName = @"购物车";
    _shoppingCarView.categoryCoverUrl = @"main_icon";
    [_shoppingCarView setupSmallContent];
    [_shoppingCarView resetNumber:@"0"];
    [bottomView addSubview:_shoppingCarView];
    
    self.aaddShoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.aaddShoppingCarBtn.frame = CGRectMake(115, 5 , (kScreenWidth - 130) / 2, 40);
    self.aaddShoppingCarBtn.backgroundColor = UIRGBColor(227, 241, 253);
    UIBezierPath * addPath = [UIBezierPath bezierPathWithRoundedRect:self.aaddShoppingCarBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *addLayer = [[CAShapeLayer alloc]init];
    addLayer.frame = self.aaddShoppingCarBtn.bounds;
    addLayer.path = addPath.CGPath;
    [self.aaddShoppingCarBtn.layer setMask:addLayer];
    
    [self.aaddShoppingCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.aaddShoppingCarBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    self.aaddShoppingCarBtn.titleLabel.font = kMainFont_16;
    [bottomView addSubview:self.aaddShoppingCarBtn];
    
    [self.aaddShoppingCarBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(CGRectGetMaxX(_aaddShoppingCarBtn.frame), 5 , _aaddShoppingCarBtn.hd_width, 40);
    self.applyBtn.backgroundColor = kCommonMainBlueColor;
    
    UIBezierPath * applyPath = [UIBezierPath bezierPathWithRoundedRect:self.applyBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *gradientLayer = [[CAShapeLayer alloc]init];
    gradientLayer.frame = self.applyBtn.bounds;
    gradientLayer.path = applyPath.CGPath;
    [self.applyBtn.layer setMask:gradientLayer];
    
    [self.applyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.applyBtn.titleLabel.font = kMainFont_16;
    [bottomView addSubview:self.applyBtn];
    
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)storeClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    if ([[infoDic objectForKey:@"id"] intValue] == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        ShoppingCarViewController * vc = [[ShoppingCarViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)applyAction
{
    NSLog(@"购买 ");
    self.isApply = YES;
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestAddShoppingCarWith:@{kUrlName:@"api/shop/cart/create",@"good_id":[UIUtility judgeStr:[self.goodDetailInfo objectForKey:@"id"]]} withNotifiedObject:self];
    
}

- (void)addAction
{
    NSLog(@"addShoppingCar");
    [[UserManager sharedManager] didRequestAddShoppingCarWith:@{kUrlName:@"api/shop/cart/create",@"good_id":[UIUtility judgeStr:[self.goodDetailInfo objectForKey:@"id"]]} withNotifiedObject:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
            
        default:
            break;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CommodityBannerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCommodityBannerTableViewCell forIndexPath:indexPath];
            cell.bannerImgUrlArray = self.freeArray;
            [cell resetSubviews];
            return cell;
        }else
        {
            CommodityInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCommodityInfoTableViewCell forIndexPath:indexPath];
            [cell refreshUIWith:self.goodDetailInfo];
            return cell;
        }
        
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    [cell.contentView addSubview:self.webView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return tableView.hd_width;
        }
        NSString * str = [self.goodDetailInfo objectForKey:@"desc"];
        CGFloat height = [str boundingRectWithSize:CGSizeMake(tableView.hd_width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.height;
        return  height + 75;
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
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth - 20, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [headView addSubview:separateView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 35, 10, 70, 20)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x333333);
    label.backgroundColor = UIColorFromRGB(0xffffff);
    label.text = @"商品详情";
    label.textAlignment = NSTextAlignmentCenter;
    
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
   
}

#pragma mark - goodDetail
- (void)didCourseDetailSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.goodDetailInfo = [[UserManager sharedManager] getCourseDetailInfo];
    self.freeArray = [self.goodDetailInfo objectForKey:@"banner"];
    
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    NSString * htmlStr = [UIUtility judgeStr:[self.goodDetailInfo objectForKey:@"content"]];
    [self testLoadHtmlImage:[headerString stringByAppendingString:[htmlStr stringByDecodingHTMLEntities]]];
    
    [self.tableView reloadData];
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

- (void)didRequestAddShoppingCarSuccessed
{
    if (self.isApply) {
        self.isApply = NO;
        [SVProgressHUD dismiss];
        ShoppingCarViewController * vc = [[ShoppingCarViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    [self loadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestAddShoppingCarFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestShoppingCarListSuccessed
{
    NSArray * array = [[UserManager sharedManager]getShoppingCarList];
    [_shoppingCarView resetNumber:[NSString stringWithFormat:@"%d", array.count]];
}

- (void)didRequestShoppingCarListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
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

@end
