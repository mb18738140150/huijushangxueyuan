//
//  AppDelegate.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/21.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "TUIKit.h"
#import <SDWebImage/SDWebImageDownloader.h>
//#import "SDWebImageDownloader.h"

#define kWeixinAppid @"wx7989d2f3f7dbdd02"
#define kJiGuangAppid @"cb37d2f8228ef7e0930b6c1d"
#define kTXAppid @"1400051970"

#import "JRSwizzle.h"
#import "NSDictionary+Unicode.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "WelcomeViewController.h"
#import "LivingCourseDetailViewController.h"

@interface AppDelegate ()<WXApiDelegate,WXApiManagerDelegate,JPUSHRegisterDelegate,UserModule_TabbarList,UserModule_LoginProtocol>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[DBManager sharedManager] intialDB];
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    [self getToken];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[TUIKit sharedInstance] setupWithAppId:[kTXAppid longLongValue]];
    
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    
    //向微信注册
    [WXApi registerApp:kWeixinAppid universalLink:@"https://bxapi.luezhi.com/huiju/"];
    
    [WXApiManager sharedManager].delegate = self;
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      // 可以添加自定义 categories
      // NSSet<UNNotificationCategory *> *categories for iOS10 or later
      // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    

      // Required
      // init Push
      // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
      [JPUSHService setupWithOption:launchOptions appKey:kJiGuangAppid
                            channel:nil
                   apsForProduction:NO
              advertisingIdentifier:nil];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersions = [defaults stringForKey:@"lastVersions"];
    NSString *newVersions = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
    [self mainViewSetup];
    
    [DownloaderManager sharedManager];
       
       [[TYDownloadSessionManager manager] setBackgroundSessionDownloadCompleteBlock:^NSString *(NSString *downloadUrl) {
           TYDownloadModel *model = [[TYDownloadModel alloc]initWithURLString:downloadUrl];
           return model.filePath;
       }];
       [[TYDownloadSessionManager manager] configureBackroundSession];
       
       NSArray * downloadVideoArr = [[DBManager sharedManager] getDownloadingVideos];
       if (downloadVideoArr.count > 0) {
           for (NSMutableDictionary * infoDic in downloadVideoArr) {
               [[DownloaderManager sharedManager] TY_addDownloadTask:infoDic];
           }
       }
       
    SDWebImageDownloader * downloader = [SDWebImageDownloader sharedDownloader] ;
    [downloader setValue:@"https://h5.luezhi.com" forHTTPHeaderField:@"Referer"];
    
//    Declaration of 'SDWebImageDownloader' must be imported from module 'SDWebImage.SDWebImageDownloader' before it is required
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - login
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    
    [[UserManager sharedManager] didLoginWithUserCode:@{@"code":response.code,kUrlName:@"api/wechat/getUserInfo"} withNotifiedObject:self];
    
//    [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)didUserLoginSuccessed
{
    [SVProgressHUD dismiss];
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        
        [self resetJPuahAlias];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginSuccess object:nil];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginSuccess object:nil];
    
}

- (void)didUserLoginFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - UI setup
- (void)mainViewSetup
{
    [[UserManager sharedManager] didRequestTabbarWithWithDic:@{kUrlName:@"api/index/navigation"} WithNotifedObject:self];
}

- (void)didTabbarListSuccessed
{
    self.tabbarViewController = [[TabbarViewController alloc] init];
    self.window.rootViewController = self.tabbarViewController;
    
}

- (void)didTabbarListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    self.tabbarViewController = [[TabbarViewController alloc] init];
    self.window.rootViewController = self.tabbarViewController;
}

- (void)getToken
{
//    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName" ];
//    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey: @"password"];
//    if (!userName) {
//        userName = @"";
//    }
//    if (!password) {
//        password = @"";
//    }
//    [[UserManager sharedManager] loginWithUserName:userName andPassword:password withNotifiedObject:nil];
    
}



#pragma mark - 注册 APNs 成功并上报 DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark - 实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - 添加处理 APNs 通知回调方法 JPUSHRegisterDelegate

- (void)resetJPuahAlias
{
    [JPUSHService setAlias:[NSString stringWithFormat:@"%@", [[[UserManager sharedManager] getUserInfos] objectForKey:kUserId]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode != 0) {
            [self resetJPuahAlias];
        }else
        {
            NSLog(@"设置别名成功");
        }
    } seq:100];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler {
  NSDictionary * userInfo = notification.request.content.userInfo;
  
  UNNotificationRequest *request = notification.request; // 收到推送的请求
  UNNotificationContent *content = request.content; // 收到推送的消息内容
  
  NSNumber *badge = content.badge;  // 推送消息的角标
  NSString *body = content.body;    // 推送消息体
  UNNotificationSound *sound = content.sound;  // 推送消息的声音
  NSString *subtitle = content.subtitle;  // 推送消息的副标题
  NSString *title = content.title;  // 推送消息的标题
  
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);

      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]] preferredStyle:UIAlertControllerStyleAlert];
      [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      }]];
//      [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfPushLivingCourse object:userInfo];

  }
  else {
    // 判断为本地通知
    NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
  }
  completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
  
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  UNNotificationRequest *request = response.notification.request; // 收到推送的请求
  UNNotificationContent *content = request.content; // 收到推送的消息内容
  
  NSNumber *badge = content.badge;  // 推送消息的角标
  NSString *body = content.body;    // 推送消息体
  UNNotificationSound *sound = content.sound;  // 推送消息的声音
  NSString *subtitle = content.subtitle;  // 推送消息的副标题
  NSString *title = content.title;  // 推送消息的标题
  
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
      
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"iOS10 收到远程通知:%@", [self logDic:userInfo]] preferredStyle:UIAlertControllerStyleAlert];
      [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      }]];
//      [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
      
      
      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfPushLivingCourse object:userInfo];
  }
  else {
    // 判断为本地通知
    NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
  }
  
  completionHandler();  // 系统要求执行这个方法
}

- (void)pushLivingCourseDetailVC:(NSDictionary *)info
{
    NSDictionary * infoDic = @{@"id":[[info objectForKey:@"need_redirect"] objectForKey:@"topic_id"]};
    
    LivingCourseDetailViewController * vc = [[LivingCourseDetailViewController alloc]init];
    
    vc.info = infoDic;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.window.rootViewController.navigationController pushViewController:vc animated:YES];
    });
}


- (NSString *)logDic:(NSDictionary *)dic {
  if (![dic count]) {
    return nil;
  }
  NSString *tempStr1 =
      [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                   withString:@"\\U"];
  NSString *tempStr2 =
      [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  NSString *tempStr3 =
      [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
  NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
  NSString *str =
      [NSPropertyListSerialization propertyListFromData:tempData
                                       mutabilityOption:NSPropertyListImmutable
                                                 format:NULL
                                       errorDescription:NULL];
  return str;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

  // Required, For systems with less than or equal to iOS 6
  [JPUSHService handleRemoteNotification:userInfo];
}
 

#pragma mark - UISceneSession lifecycle
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSLog(@"url = %@ \nurl.host = %@",url, url.host);
    if ([url.host isEqualToString:@"safepay"]){
            [self alipayHandleOpenUrl:url];
            return YES;
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    return  [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{

    NSLog(@"userActivity : %@",userActivity.webpageURL.description);
    return [WXApi handleOpenUniversalLink:userActivity delegate:[WXApiManager sharedManager]];
    return YES;
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)resp
{
    if (resp.errCode == 0) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfPresentSuccess object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }else
    {
        [SVProgressHUD showErrorWithStatus:resp.errStr];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

//支付宝支付请求
 
//处理支付回调
- (void)alipayHandleOpenUrl:(NSURL *)url{
    // 支付跳转支付宝钱包进行支付，处理支付结果(在app被杀模式下，通过这个方法获取支付结果)
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSString *resultStatus = resultDic[@"resultStatus"];
        NSString *errStr = resultDic[@"memo"];
        NSLog(@"%@",errStr);
        switch (resultStatus.integerValue) {
            case 9000:// 成功
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfBuyCourseSuccess object:nil];
                NSLog(@"application 支付成功");
                break;
            case 6001:// 取消
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfBuyCoursefailed object:nil];
                NSLog(@"application 用户中途取消");
                break;
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfBuyCoursefailed object:nil];
                NSLog(@"application 支付失败");
                break;
        }
    }];
    
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
}



@end
