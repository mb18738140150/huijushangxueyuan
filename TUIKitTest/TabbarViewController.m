//
//  TabbarViewController.m
//  dayi
//
//  Created by aaa on 2018/12/17.
//  Copyright © 2018年 mcb. All rights reserved.
//

#import "TabbarViewController.h"
#import "LoginViewController.h"
#import "ScanSuccessJumpVC.h"
#import "HomeViewController.h"
#import "CustomChatViewController.h"

#import "TUIConversationCellData.h"
#import "MainViewController.h"
#import "StoreViewController.h"

@interface TabbarViewController ()<UITabBarControllerDelegate,UserModule_CourseDetailProtocol,UserModule_TabbarList>


@property (nonatomic, strong)NSString * chatRoomID;
@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabbarList = [[UserManager sharedManager] getTabarList];
    self.delegate = self;
    
    if (self.tabbarList.count > 0) {
        [self setupChildViewControllers];
    }else
    {
        [[UserManager sharedManager] didRequestTabbarWithWithDic:@{kUrlName:@"api/index/navigation"} WithNotifedObject:self];
    }
    
    
    
    
    self.tabBar.tintColor = UIColorFromRGB(0xff4550);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseClick:) name:kNotificationOfCourseClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClick:) name:kNotificationOfLoginClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadCourseClick:) name:kNotificationOfDownloadCourseClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quesitonImageClick:) name:kNotificationOfQuestionImageClick object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(livingChatClick:) name:kNotificationOfLivingChatClick object:nil];
    
}

- (void)didTabbarListSuccessed
{
    [SVProgressHUD dismiss];
    self.tabbarList = [[UserManager sharedManager] getTabarList];
    [self setupChildViewControllers];
}

- (void)didTabbarListFailed:(NSString *)failedInfo
{
//    [SVProgressHUD dismiss];
//    [SVProgressHUD showErrorWithStatus:failedInfo];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
//    });
    [[UserManager sharedManager] didRequestTabbarWithWithDic:@{kUrlName:@"api/index/navigation"} WithNotifedObject:self];
}

- (void)courseClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [SVProgressHUD show];
    [[UserManager sharedManager] getCourseDetailWith:@{@"param":[infoDic objectForKey:@"courseId"],kUrlName:@"Course/Get"} withNotifiedObject:self];
}

#pragma mark - ui setup
- (void)setupChildViewControllers
{
     LoginViewController * loginVC = [[LoginViewController alloc]init];

       UINavigationController *mainNavigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
       mainNavigation.tabBarItem.image = [UIImage imageNamed:@"icon_wode_n"];
       mainNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_wode_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       mainNavigation.tabBarItem.title = @"我的";
    
    NSMutableArray<UIViewController*> * navArray = [NSMutableArray array];
    
    for (NSDictionary * tabbarInfo in self.tabbarList) {
        
        if ([[tabbarInfo objectForKey:@"url_type"] isEqualToString:@"outer"]) {
            
            ScanSuccessJumpVC * WebVC = [[ScanSuccessJumpVC alloc]init];
            WebVC.comeFromVC = ScanSuccessJumpComeFromWC;
            WebVC.jump_URL = [tabbarInfo objectForKey:@"url"];
            WebVC.progressViewColor = kCommonMainRedColor;
            WebVC.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_kecheng_n"];
            WebVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_kecheng_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            WebVC.tabBarItem.title = [tabbarInfo objectForKey:@"title"];
            
            
            UINavigationController *mainNavigation = [[UINavigationController alloc] initWithRootViewController:WebVC];
            if ([[tabbarInfo objectForKey:@"icon_type"] isEqualToString:@"font"]) {
                
                UIColor * color = [UIColor redColor];
                if ([[tabbarInfo objectForKey:@"color"] length] > 0) {
                    color =  [UIUtility colorWithHexString:[tabbarInfo objectForKey:@"color"] alpha:1];
                }
                mainNavigation.tabBarItem.image = [UIImage iconWithInfo:TBCityIconInfoMake([UIUtility getUnicodeStr:[UIUtility judgeStr:[tabbarInfo objectForKey:@"icon"]]], 30, color)];
                
            }else
            {
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
                imageView.hidden = YES;
                AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                [delegate.window addSubview:imageView];
                NSString * imageStr = [[NSString stringWithFormat:@"%@",[UIUtility judgeStr:[tabbarInfo objectForKey:@"icon"]]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

                   dispatch_async(dispatch_get_main_queue(), ^{
                        mainNavigation.tabBarItem.image = [image imageByScalingAndCroppingForSize:CGSizeMake(30, 30)];

                    });
                }];
                
            }
               mainNavigation.tabBarItem.title = [tabbarInfo objectForKey:@"title"];
            
            [navArray addObject:mainNavigation];
        }else{
            
            UIViewController * vc = [[UIViewController alloc]init];
            if ([[tabbarInfo objectForKey:@"url"] isEqualToString:@"index"]) {
                vc = [[HomeViewController alloc]init];
            }else if ([[tabbarInfo objectForKey:@"url"] isEqualToString:@"center"])
            {
                vc = [[MainViewController alloc]init];
            }else if ([[tabbarInfo objectForKey:@"url"] isEqualToString:@"shop_index"])
            {
                vc = [[StoreViewController alloc]init];
            }
            
            UINavigationController *mainNavigation = [[UINavigationController alloc] initWithRootViewController:vc];
            if ([[tabbarInfo objectForKey:@"icon_type"] isEqualToString:@"font"]) {
                UIColor * color = [UIColor redColor];
                if ([[tabbarInfo objectForKey:@"color"] length] > 0) {
                    color =  [UIUtility colorWithHexString:[tabbarInfo objectForKey:@"color"] alpha:1];
                }
                mainNavigation.tabBarItem.image = [UIImage iconWithInfo:TBCityIconInfoMake([UIUtility getUnicodeStr:[UIUtility judgeStr:[tabbarInfo objectForKey:@"icon"]]], 30, color)];
            }else
            {
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 120, 130, 130)];
                NSString * imageStr = [[NSString stringWithFormat:@"%@",[UIUtility judgeStr:[tabbarInfo objectForKey:@"icon"]]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                imageView.hidden = YES;
                AppDelegate * delegate = [UIApplication sharedApplication].delegate;
                [delegate.window addSubview:imageView];
                
                imageStr = [NSString stringWithFormat:@"%@",[UIUtility judgeStr:[tabbarInfo objectForKey:@"icon"]]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        mainNavigation.tabBarItem.image = [image imageByScalingAndCroppingForSize:CGSizeMake(30, 30)];
                        
                    });
                }];
               
            }
               mainNavigation.tabBarItem.title = [tabbarInfo objectForKey:@"title"];
            
            [navArray addObject:mainNavigation];
        }
        
    }
    
    if(navArray.count == 0)
    {
        UIViewController * vc = [[UIViewController alloc]init];
        vc = [[HomeViewController alloc]init];
        UINavigationController *mainNavigation = [[UINavigationController alloc] initWithRootViewController:vc];
        [navArray addObject:mainNavigation];
        
        UIViewController * vc1 = [[UIViewController alloc]init];
        vc1 = [[MainViewController alloc]init];
        UINavigationController *mainNavigation1 = [[UINavigationController alloc] initWithRootViewController:vc1];
        [navArray addObject:mainNavigation1];
        
        UIViewController * vc2 = [[UIViewController alloc]init];
        vc2 = [[StoreViewController alloc]init];
        UINavigationController *mainNavigation2 = [[UINavigationController alloc] initWithRootViewController:vc2];
        [navArray addObject:mainNavigation2];
        
    }
    
    self.viewControllers = navArray;
    
    return;
}


- (void)loginClick:(NSNotification *)notification
{
    [self requireLogin];
}

#pragma mark - delegate func
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
//    if ([nav.topViewController class] == [SettingViewController class]) {
//        if (![[UserManager sharedManager] isUserLogin]) {
//            [self requireLogin];
//            [self setSelectedIndex:0];
//        }
//    }
    
}

- (void)requireLogin
{
    LoginViewController *login = [[LoginViewController alloc] init];

    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击查看大图
- (void)quesitonImageClick:(NSNotification *)notification
{
    UIImage *image = notification.object;
    if (image == nil) {
        return;
    }
//    ShowPhotoViewController *vc = [[ShowPhotoViewController alloc] initWithImage:image];
//    vc.isShowDelete = NO;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didCourseDetailSuccessed
{
    [SVProgressHUD dismiss];
    NSDictionary * infoDic = [[UserManager sharedManager] getCourseDetailInfo];
//    VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)didCourseDetailFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)livingChatClick:(NSNotification *)notification
{
    [SVProgressHUD dismiss];
    if (self.chatRoomID.length > 0) {
        return;
    }

    NSDictionary * infoDic = notification.object;
    
    
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.groupID = @"groupID";  // 如果是群会话，传入对应的群 ID
    
    
    CustomChatViewController *chatRoomVC = [[CustomChatViewController alloc]init];
    chatRoomVC.conversationData = data;
    
    chatRoomVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:chatRoomVC animated:YES completion:nil];

    __weak typeof(self)weakSelf = self;

}

- (NSMutableDictionary *)getCourseInfo:(NSDictionary *)infoDic
{
    NSMutableDictionary * teacherInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary * date = [NSMutableDictionary dictionary];
    [date setObject:[infoDic objectForKey:kTeacherPortraitUrl] forKey:@"Photo"];
    [date setObject:[infoDic objectForKey:kTeacherDetail] forKey:@"TeacharExp"];
    [date setObject:[infoDic objectForKey:kCourseTeacherName] forKey:@"TeacharName"];
    [teacherInfo setObject:date forKey:@"Data"];
    
    return teacherInfo;
}

- (void)downloadCourseClick:(NSNotification *)notification
{
    
}


@end
