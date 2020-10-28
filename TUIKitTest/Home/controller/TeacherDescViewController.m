//
//  TeacherDescViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/23.
//

#import "TeacherDescViewController.h"

@interface TeacherDescViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, assign)CGFloat webViewHeight;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong)NSMutableArray * urlDictsArray;
@property (nonatomic, strong)NSString * detailHtml;

@end

@implementation TeacherDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xff0000);
    
    [self navigationViewSetup];
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = self.titleStr;
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
    
    // webview
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 10)];
    _webView.layer.cornerRadius = 5;
    _webView.layer.masksToBounds = YES;
    _webView.backgroundColor = UIColorFromRGB(0xffffff);
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self testLoadHtmlImage:[self.info objectForKey:@"desc"]];
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
            _webView.frame = CGRectMake(10, 10, kScreenWidth - 20, _webViewHeight);
            if (_webViewHeight > kScreenHeight - 20 - kNavigationBarHeight - kStatusBarHeight) {
                _webView.frame = CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 20 - kNavigationBarHeight - kStatusBarHeight);
            }
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
    
    if (html == nil) {
        return;
    }
    
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
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    NSLog(@"界面释放了");
}

@end
