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

@interface VIPCardDetailViewController ()<UITableViewDelegate, UITableViewDataSource,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic, strong)UIButton *applyBtn;

@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, assign)CGFloat webViewHeight;

@end

@implementation VIPCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];

    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 45 - kNavigationBarHeight - kStatusBarHeight)];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    
    
    [_webView loadHTMLString:[headerString stringByAppendingString:@"www.baidu.com"] baseURL:nil];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self prepareUI];
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
    
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(15, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 64 , kScreenWidth - 30, 44);
    
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
    
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)applyAction
{
    NSLog(@"购买 %@", self.info);
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
            if (self.vipCardType == VIPCardType_VIP) {
                return 2;
            }else
            {
                return 1;
            }
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
        [cell refreshUIWith:self.info];
        return cell;
    }else if (indexPath.section == 1)
    {
        VIPJurisdictionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kVIPJurisdictionTableViewCell forIndexPath:indexPath];
        
        if (self.vipCardType == VIPCardType_HeHuoRen) {
            [cell resetUIWithInfo:@{@"image":@"main_免费专区"}];
        }else
        {
            if (indexPath.row == 0) {
                [cell resetUIWithInfo:@{@"image":@"main_免费专区"}];
            }else
            {
                [cell resetUIWithInfo:@{@"image":@"main_折扣专区"}];
            }
        }
        
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
    return 50;
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
    
    /*
     //    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable Result, NSError * _Nullable error) {
     //        NSString * heightStr = [NSString stringWithFormat:@"%@", Result];
     //        CGFloat height = heightStr.floatValue + 15;
     //        self.webView.frame = CGRectMake(0, 0, kScreenWidth, height);
     //        [self.tableview reloadData];
     //    }];
     
     //    for(UIView * view in webView.subviews)
     //    {
     //        NSLog(@"%@", [view class]);
     //        if ([view isKindOfClass:[NSClassFromString(@"WKScrollView") class]]) {
     //            UIScrollView * scrollView = (UIScrollView *)view;
     //            CGFloat height = scrollView.contentSize.height;
     //            self.webView.frame = CGRectMake(0, 0, kScreenWidth, height);
     //            [self.tableview reloadData];
     //        }
     //
     //    }
     
     */
    
    
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
@end
