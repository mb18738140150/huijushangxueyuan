//
//  LivingCourseDetailViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "LivingCourseDetailViewController.h"
#import "CustomChatViewController.h"
#import "LivingCourseDetailTableViewCell.h"
#define kLivingCourseDetailTableViewCell @"LivingCourseDetailTableViewCell"
#import "LivingTeacherIntroTableViewCell.h"
#define kLivingTeacherIntroTableViewCell @"LivingTeacherIntroTableViewCell"
#import "MainOpenVIPCardTableViewCell.h"
#define kMainOpenVIPCardTableViewCell @"MainOpenVIPCardTableViewCell"
#import "MainVipCardListViewController.h"

typedef enum : NSUInteger {
    topic_type_free = 1,
    topic_type_buy,
    topic_type_secret,
} Topic_type;

typedef enum : NSUInteger {
    Topic_style_audio = 1,
    Topic_style_living,
    Topic_style_video,
    Topic_style_sanfang,
} Topic_style;

@interface LivingCourseDetailViewController ()<UserModule_CourseDetailProtocol,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)NSDictionary * courseDetailInfo;

@property (nonatomic, strong)UIButton *playBackBtn;
@property (nonatomic, assign)Topic_type topic_type; // 收费类型 1.免费 2.收费 3.加密
@property (nonatomic, assign)Topic_style topic_style;// 课程类型 1.音频直播 2.直播 3.录播 4.三方直播

@end

@implementation LivingCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self navigationViewSetup];
    [self prepareUI];
    
    
}
#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.info objectForKey:@"title"]];
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
    [[UserManager sharedManager] getCourseDetailWith:@{@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]],kUrlName:@"api/topic/info",@"include":@"author",@"requestType":@"get"} withNotifiedObject:self];//
    [SVProgressHUD show];
}

- (void)prepareUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LivingCourseDetailTableViewCell class] forCellReuseIdentifier:kLivingCourseDetailTableViewCell];
    [self.tableView registerClass:[LivingTeacherIntroTableViewCell class] forCellReuseIdentifier:kLivingTeacherIntroTableViewCell];
    [self.tableView registerClass:[MainOpenVIPCardTableViewCell class] forCellReuseIdentifier:kMainOpenVIPCardTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    _playBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBackBtn.frame = CGRectMake(15, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenWidth - 30, 40);
    [_playBackBtn setTitle:@"进入观看" forState:UIControlStateNormal];
    _playBackBtn.backgroundColor = UIColorFromRGB(0x2A75ED);
    _playBackBtn.layer.cornerRadius = _playBackBtn.hd_height / 2;
    _playBackBtn.layer.masksToBounds = YES;
    [_playBackBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_playBackBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBackBtn];
}

- (void)resetPayBtn
{
    _topic_style = [[self.courseDetailInfo objectForKey:@"topic_style"] intValue];
    _topic_type = [[self.courseDetailInfo objectForKey:@"topic_type"] intValue];
    
    if (_topic_type != 1) {
        [_playBackBtn setTitle:[NSString stringWithFormat:@"￥%@购买", [self.courseDetailInfo objectForKey:@"show_paymoney"]] forState:UIControlStateNormal];
    }else
    {
        [_playBackBtn setTitle:@"进入观看" forState:UIControlStateNormal];
    }
    
}

- (void)playAction
{
    switch (_topic_type) {
        case topic_type_free:
        {
            [self getChatRoomInfo];
        }
            break;
        case topic_type_buy:
        {
            NSLog(@"购买");
        }
            break;
        case topic_type_secret:
        {
            NSLog(@"加密");
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }else if (section == 2)
    {
        return 1;
    }
    if (self.courseDetailInfo) {
        if ([[self.courseDetailInfo objectForKey:@"topic_type"] intValue] == 1) {
            return 1;
        }
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        LivingCourseDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kLivingCourseDetailTableViewCell forIndexPath:indexPath];
        [cell refreshUIWithInfo:self.courseDetailInfo];
        return cell;
    }else if (indexPath.row == 1 && indexPath.section == 0)
    {
        MainOpenVIPCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMainOpenVIPCardTableViewCell forIndexPath:indexPath];
        [cell resetUIWithInfo:@{}];
        return cell;
    }
    if (indexPath.section == 1) {
        LivingTeacherIntroTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kLivingTeacherIntroTableViewCell forIndexPath:indexPath];
        if (self.courseDetailInfo) {
            [cell refreshUIWithInfo:[[self.courseDetailInfo objectForKey:@"author"] objectForKey:@"data"]];
        }
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0){
        if (self.courseDetailInfo) {
            NSString * titleStr = [self.courseDetailInfo objectForKey:@"title"];
            CGFloat height = [titleStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_18} context:nil].size.height;
            
            return tableView.hd_width / 2 + 10 + height + 10 + 15 + 10 + 1 + 45 ;
        }
    }else if (indexPath.row == 1 && indexPath.section == 0)
    {
        return 60;
    }
    
    if (indexPath.section == 1) {
        return 74;
    }
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 40)];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 15)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x333333);
    label.text = @"课程详情";
    [headView addSubview:label];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 40;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        MainVipCardListViewController * vc = [[MainVipCardListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        NSDictionary * teacherInfo = [[self.courseDetailInfo objectForKey:@"author"] objectForKey:@"data"];
        NSLog(@"teacherInfo = %@", teacherInfo);
    }
}


- (void)didCourseDetailSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.courseDetailInfo = [[UserManager sharedManager] getCourseDetailInfo];
    [self resetPayBtn];
    [self.tableView reloadData];
    NSLog(@"self.courseDetailInfo = %@", self.courseDetailInfo);
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

- (void)getChatRoomInfo
{
    __block NSDictionary * roomDetailInfo;
    __block NSDictionary * roomIdInfo;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    // 请求用户基本信息
    dispatch_group_async(group, dispatch_queue_create("ChatRoomInfo", DISPATCH_QUEUE_CONCURRENT), ^{
        // 第一个请求；
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        NSString * sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
        
        NSDictionary * paramete = @{@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]};
        NSString * aesStr = [UIUtility getAES_Str:paramete];
        NSString * propertyStr = [UIUtility getGetRequest_Str:paramete];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",kRootUrl,@"api/topicLive/imSetting"];
        
        NSDictionary * headDic = @{@"token":[NSString stringWithFormat:@"%@", aesStr]};
        if (sessionId) {
            if (sessionId.length > 0) {
                sessionId = [NSString stringWithFormat:@"PHPSESSID=%@", sessionId];
                
                headDic = @{@"token":[NSString stringWithFormat:@"%@", aesStr],@"Cookie":sessionId};
            }
        }
        urlString = [urlString stringByAppendingFormat:@"?%@", propertyStr];
        [session GET:urlString parameters:nil headers:headDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int result = [[responseObject objectForKey:@"code"] intValue];
                if (result == 0) {
                    // 请求成功
                    roomIdInfo = [responseObject objectForKey:@"data"];
                }else if (result == 1401)
                {
                    // 登陆失效，从新登陆
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
                }
                else{
                    // 请求错误
                    [SVProgressHUD showErrorWithStatus:[UIUtility judgeStr:[responseObject objectForKey:@"msg"]]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    
    // 请求直播室信息
    dispatch_group_async(group, dispatch_queue_create("ChatRoomInfo", DISPATCH_QUEUE_CONCURRENT), ^{
        // 第二个请求;
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        NSString * sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
        
        NSDictionary * paramete = @{@"topic_id":[NSString stringWithFormat:@"%@", [self.info objectForKey:@"id"]]};
        NSString * aesStr = [UIUtility getAES_Str:paramete];
        NSString * propertyStr = [UIUtility getGetRequest_Str:paramete];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",kRootUrl,@"api/topiclive/home"];
        
        NSDictionary * headDic = @{@"token":[NSString stringWithFormat:@"%@", aesStr]};
        if (sessionId) {
            if (sessionId.length > 0) {
                sessionId = [NSString stringWithFormat:@"PHPSESSID=%@", sessionId];
                
                headDic = @{@"token":[NSString stringWithFormat:@"%@", aesStr],@"Cookie":sessionId};
            }
        }
        urlString = [urlString stringByAppendingFormat:@"?%@", propertyStr];
        [session GET:urlString parameters:nil headers:headDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@", responseObject);
            int result = [[responseObject objectForKey:@"code"] intValue];
                if (result == 0) {
                    // 请求成功
                    roomDetailInfo = [responseObject objectForKey:@"data"];
                }else if (result == 1401)
                {
                    // 登陆失效，从新登陆
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
                }
                else{
                    // 请求错误
                    [SVProgressHUD showErrorWithStatus:[UIUtility judgeStr:[responseObject objectForKey:@"msg"]]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 请求完毕
        if (roomDetailInfo && roomIdInfo) {
            NSLog(@"roomDetailInfo = %@", roomDetailInfo);
            NSLog(@"roomIdInfo = %@", roomIdInfo);
            V2TIMUserFullInfo * profile = [[V2TIMUserFullInfo alloc]init];
            profile.selfSignature = [roomIdInfo objectForKey:@"user_sig"];
            profile.nickName = [roomIdInfo objectForKey:@"identifier_nickname"];
            profile.faceURL = [[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl];
            
            [[TUIKit sharedInstance] login:[UIUtility judgeStr:[roomIdInfo objectForKey:@"identifier"]] userSig:[UIUtility judgeStr:[roomIdInfo objectForKey:@"user_sig"]] succ:^{
                
                // 登录成功,设置个人信息
                [[V2TIMManager sharedInstance] setSelfInfo:profile succ:^{
                    
                    // 加入群组
                    [[V2TIMManager sharedInstance] joinGroup:[roomIdInfo objectForKey:@"room_id"] msg:@"" succ:^{
                        
                        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
                        data.groupID = [roomIdInfo objectForKey:@"room_id"];  // 如果是群会话，传入对应的群 ID
    //                    data.userID = [roomIdInfo objectForKey:@"room_id"];
                        CustomChatViewController *chatRoomVC = [[CustomChatViewController alloc]init];
                        chatRoomVC.conversationData = data;
                        chatRoomVC.videoInfo = roomDetailInfo;
                        if (self.index % 2 == 0) {
                            chatRoomVC.playUrl = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
                        }else
                        {
                            chatRoomVC.playUrl = @"http://200024424.vod.myqcloud.com/200024424_709ae516bdf811e6ad39991f76a4df69.f20.mp4";
                        }
                        chatRoomVC.groupId = [roomIdInfo objectForKey:@"room_id"];
                        chatRoomVC.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self presentViewController:chatRoomVC animated:YES completion:nil];
                        
                    } fail:^(int code, NSString *desc) {
                        NSLog(@"joinchatroom setSelfInfo fail %d  %@", code, desc);
                    }];
                    
                    
                } fail:^(int code, NSString *desc) {
                    NSLog(@"V2TIMManager setSelfInfo fail %d  %@", code, desc);
                }];
            } fail:^(int code, NSString *msg) {
                NSLog(@"imlogin fail %d  %@", code, msg);
            }];
            
        }else
        {
            return;
        }
        
    });
}



- (void)dealloc
{
    

    NSLog(@"界面销毁");
}

@end