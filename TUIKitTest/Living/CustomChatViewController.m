//
//  CustomChatViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "CustomChatViewController.h"
#import "TUIKit.h"
#import "TXLiteAVSDK.h"
#import "ZXVideo.h"
#import "LXLivePlayerView.h"

#import "MyCustomCell.h"
#import "MyCustomCellData.h"
#import "TCUtil.h"

#import "TUITextMessageCellData.h"
#import "CustomTUIImageMessageCell.h"
#import "LiveGiftSelectView.h"
#import "LivingImageListView.h"
#import "LivingShareListView.h"
#import "LivingRightTabbarView.h"
#import "LivingBuyVIPView.h"
#import "TUISystemMessageCellData.h"
#import "UIView+RCDDanmaku.h"
#import "RCDDanmaku.h"

#import "BarrageView.h"
#import "BarrageModel.h"
#import "CustomCell.h"
#import "TestImageView.h"
#import "ShareAndPaySelectView.h"

@interface CustomChatViewController ()<TInputControllerDelegate,CustomTMessageControllerDelegate,CustomTUIChatControllerDelegate,UserModule_LiveChatRecord,UserModule_SendMessage,HttpUploadProtocol,UserModule_GiftList,UserModule_ShareList,BarrageViewDataSouce, BarrageViewDelegate,UserModule_Shutup,UserModule_MockVIPBuy, UserModule_MockPartnerBuy,UserModule_PayOrderProtocol,UserModule_MyVIPCardInfo>

@property (nonatomic, strong) CustomTUIChatController *chat;

@property(nonatomic,strong)LXAVPlayView *playerview;
@property(nonatomic,strong)UIView *playFatherView;
@property (nonatomic,strong) ZXVideo                            *playingVideo;
@property (nonatomic, strong)LXLivePlayerView * livePlayer;
@property (nonatomic, strong)TXLivePlayer * livePlayer1;

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)HYSegmentedControl * segmentC;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)TUIMessageCellData * currentSendData;

@property (nonatomic, strong)LiveGiftSelectView * giftView;
@property (nonatomic, strong)UIButton * giftBtn;
@property (nonatomic, strong)NSDictionary * currentSendGiftInfo;

@property (nonatomic, strong)LivingImageListView * imageListView;
@property (nonatomic, strong)LivingShareListView * shareListView;
@property (nonatomic, assign)int shareListPage;

@property (nonatomic, strong)LivingRightTabbarView * rightBarView;
@property (nonatomic, strong)LivingBuyVIPView * buyVipView;

@property (nonatomic, strong)NSDictionary * teacherInfo;
@property (nonatomic, strong)NSArray * guestsArray;

@property (nonatomic, assign)BOOL is_guest;// 是否是嘉宾
@property (nonatomic, assign)BOOL is_author;// 是否是老师
@property (nonatomic, strong)NSString * role_name;// 角色名称
@property (nonatomic, strong)NSString * msg_id;// 消息id
@property (nonatomic, strong)NSString * msg_type;// 消息类型
@property (nonatomic, strong)NSString * sendImageUrl;

@property (strong, nonatomic) BarrageView *barrageView;
@property (nonatomic, assign)BOOL is_shutup;// 是否禁言

@property (nonatomic, strong)NSMutableArray * chatRecordList;
@property (nonatomic, assign)BOOL isWechat; // 是否是微信支付
@property (nonatomic, assign)BOOL isPayGift;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)NSDictionary * currentBuyVIPInfo;
@property (nonatomic, strong)NSDictionary * VIPPayOrderInfo;// vip购买成功dingdanxi孽息
@property (nonatomic, strong)NSDictionary * VIPPaySeccessDanMuInfo;// vip购买成功弹幕

@end

@implementation CustomChatViewController

- (NSMutableArray *)chatRecordList
{
    if (!_chatRecordList) {
        _chatRecordList = [NSMutableArray array];
    }
    return _chatRecordList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    self.shareListPage = 0;
    self.msg_id = @"0";
    self.sendImageUrl = @"";
    [self navigationViewSetup];
    self.is_shutup = [[self.videoInfo objectForKey:@"allshutup"] boolValue];
    
    self.teacherInfo = [[self.videoInfo objectForKey:@"author"] objectForKey:@"data"];
    self.guestsArray = [[self.videoInfo objectForKey:@"guests"] objectForKey:@"data"];
    
    [self getLivaChatRecord];
    
    TUIKitConfig *config = [TUIKitConfig defaultConfig];
    // 修改头像类型为圆角矩形，圆角大小为5
    config.avatarType = TAvatarTypeRadiusCorner;
    config.avatarCornerRadius = 5.f;
    
    [self getUserJurisdiction];
    
    [self getGiftList];
    [self requestShareList:YES];
    [self prepareUI];
    
    [self shutUpWithState:self.is_shutup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shutUpClick:) name:kNotificationOfShutUpNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mockVIPBuyClick:) name:kNotificationOfMockVIPBuyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addChatRecord:) name:kNotificationOfAddChatRecord object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];
}

- (void)paySuccedsss:(NSNotification *)notification
{
    NSLog(@"paySuccedsss");
    if (self.isPayGift) {
        self.isPayGift = NO;
        
        NSDictionary *contentInfo = @{@"to_avatar":[self.teacherInfo objectForKey:@"avatar"],@"from_avatar":[[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl],@"money":[NSString stringWithFormat:@"%.2f", [[self.currentSendGiftInfo objectForKey:@"price"] floatValue] * [[self.currentSendGiftInfo objectForKey:@"count"] intValue]]};
        NSString * jsonStr = [contentInfo JSONString];
        [[UserManager sharedManager] didRequestSendMessageWithWithDic:@{kUrlName:@"api/topiclivechat/create",
                                                                        @"topic_id":[self.videoInfo objectForKey:@"id"],@"type":@"reward",
                                                                        @"content":jsonStr,
                                                                        @"ask":@"0",
                                                                        @"content_ext":[NSString stringWithFormat:@"%@ 打赏了 %@ %@ * %@",[[[UserManager sharedManager] getUserInfos] objectForKey:kUserName],[self.teacherInfo objectForKey:@"nickname"], [self.currentSendGiftInfo objectForKey:@"name"], [self.currentSendGiftInfo objectForKey:@"count"]]} WithNotifedObject:self];
        
        TUISystemMessageCellData *system = [[TUISystemMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
        system.content = [NSString stringWithFormat:@"%@ 打赏了 %@ %@ * %@",[[[UserManager sharedManager] getUserInfos] objectForKey:kUserName],[self.teacherInfo objectForKey:@"nickname"], [self.currentSendGiftInfo objectForKey:@"name"], [self.currentSendGiftInfo objectForKey:@"count"]];
        self.currentSendData = system;
    }else
    {
        [[UserManager sharedManager] didRequestMyVIPCardWithInfo:@{@"topic_id":[self.videoInfo objectForKey:@"id"],
                                                                   kUrlName:@"api/topiclivechat/vipBySuccess",
                                                                   @"order_id":[self.VIPPayOrderInfo objectForKey:@"id"],
                                                                   @"card_id":[self.currentBuyVIPInfo objectForKey:@"id"]
        } withNotifiedObject:self];
    }
}

- (void)payClick:(NSNotification *)notification
{
    
    NSDictionary *infoDic = notification.object;
    
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_wechatPay) {
        NSLog(@"微信支付");
        self.isWechat = YES;
        [SVProgressHUD show];
        if (self.isPayGift) {
            
            [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/topicGift",@"topic_id":[NSString stringWithFormat:@"%@", [self.videoInfo objectForKey:@"id"]],@"pay_type":@"wechat",@"gift_id":[self.currentSendGiftInfo objectForKey:@"id"],@"num":[self.currentSendGiftInfo objectForKey:@"count"]} withNotifiedObject:self];
        }else
        {
            [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/vip",@"vip_id":[NSString stringWithFormat:@"%@", [self.currentBuyVIPInfo objectForKey:@"id"]],@"pay_type":@"wechat"} withNotifiedObject:self];
        }
        
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_zhifubPay)
    {
        self.isWechat = NO;
        NSLog(@"支付宝支付");
        [SVProgressHUD show];
        
        if (self.isPayGift) {
            [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/topicGift",@"topic_id":[NSString stringWithFormat:@"%@", [self.videoInfo objectForKey:@"id"]],@"pay_type":@"alipay",@"gift_id":[self.currentSendGiftInfo objectForKey:@"id"],@"num":[self.currentSendGiftInfo objectForKey:@"count"]} withNotifiedObject:self];
        }else
        {
            [[UserManager sharedManager] didRequestPayOrderWithCourseInfo:@{kUrlName:@"api/pay/vip",@"vip_id":[NSString stringWithFormat:@"%@", [self.currentBuyVIPInfo objectForKey:@"id"]],@"pay_type":@"alipay"} withNotifiedObject:self];
        }
    }
}

- (void)didRequestPayOrderSuccessed
{
    [SVProgressHUD dismiss];
    [self.payView removeFromSuperview];
    NSDictionary * info = [[UserManager sharedManager]getPayOrderInfo];
    if (!self.isPayGift) {
        // VIP购买的话需要保存订单的信息
        self.VIPPayOrderInfo = [info objectForKey:@"order"];
    }
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
    __weak typeof(self)weakSelf = self;
    [[AlipaySDK defaultService] payOrder:url fromScheme:@"alipay" callback:^(NSDictionary *resultDic) {
        NSLog(@"%@",resultDic);
        NSString *str = resultDic[@"memo"];
        [SVProgressHUD showErrorWithStatus:str];
        
        NSString *resultStatus = resultDic[@"resultStatus"];
        [weakSelf.payView removeFromSuperview];
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
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestMyVIPCardInfoSuccessed
{
    NSDictionary * partnerInfo = [[UserManager sharedManager] getVIPCardInfo];
    [self mockBuySuccess:partnerInfo];
}

- (void)didRequestMyVIPCardInfoFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
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
    self.navigationItem.title = @"直播";
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

- (void)getLivaChatRecord
{
    self.page++;
    [[UserManager sharedManager] didRequestLiveChatRecordWithWithDic:@{kUrlName:@"api/topiclivechat/record",@"topic_id":[self.videoInfo objectForKey:@"id"],@"page":@(self.page)} WithNotifedObject:self];
}

- (void)didLiveChatRecordSuccessed
{
    
    NSArray * recordArray = [[UserManager sharedManager]getLiveChatRecordList];
    
    for (NSDictionary * info in recordArray) {
        [self.chatRecordList addObject:info];
    }
    
    [self.chat getMessagesWithInfo:recordArray msgCount:recordArray.count];
    NSLog(@"recordArray = %@", recordArray);
}

- (void)didLiveChatRecordFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.playFatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9 / 16)];
    self.playFatherView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.playFatherView];
    
    self.playingVideo = [[ZXVideo alloc] init];

    self.playingVideo.playUrl = self.playUrl;
    self.playingVideo.title = [self.videoInfo objectForKey:@"title"];
    
    
    self.playerview =[[LXAVPlayView alloc]init];
   self.playerview.isLandScape = YES;
    self.playerview.isAutoReplay = NO;
    __weak typeof(self)weakSelf = self;
    self.playerview.backBlock = ^(NSDictionary *info) {
        NSLog(@"***** \n%@", info);
        
        if (weakSelf.playerview) {
            [weakSelf.playerview destroyPlayer];
            weakSelf.playerview = nil;
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [weakSelf dismissViewControllerAnimated:YES completion:^(void){
            if (weakSelf.quitChatRoomBlock) {
                weakSelf.quitChatRoomBlock();
            }
        }];
    };

    
    self.livePlayer =[[LXLivePlayerView alloc]init];
   self.livePlayer.isLandScape = YES;
    self.livePlayer.isAutoReplay = NO;
    self.livePlayer.backBlock = ^(NSDictionary *info) {
        NSLog(@"***** \n%@", info);
        
        if (weakSelf.livePlayer) {
            [weakSelf.livePlayer destroyPlayer];
            weakSelf.livePlayer = nil;
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [weakSelf dismissViewControllerAnimated:YES completion:^(void){
            if (weakSelf.quitChatRoomBlock) {
                weakSelf.quitChatRoomBlock();
            }
        }];
    };
    
    if ([self.playingVideo.playUrl containsString:@"rtmp"] || [self.playingVideo.playUrl containsString:@"flv"]) {
        [self playLiving:@{}];
    }else
    {
        [self playVideo:@{}];
    }
    
    self.segmentC = [[HYSegmentedControl alloc] initWithOriginY:kZXVideoPlayerOriginalHeight Titles:@[@"互动",@"图片直播",@"分享榜"] delegate:self];
    [self.segmentC resetColor:UIRGBColor(255, 102, 10)];
    [self.segmentC resetColor:[UIColor blueColor]];
    [self.view addSubview:self.segmentC];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kScreenWidth * 9 / 16 + 42, kScreenWidth, self.view.frame.size.height - kScreenWidth * 9 / 16 - 42)];
    [self.view addSubview:self.scrollView];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 3, self.scrollView.hd_height);
    
    _chat = [[CustomTUIChatController alloc] initWithConversation:self.conversationData];
    _chat.delegate = self;
    _chat.inputController.delegate = self;
    _chat.messageController.delegate = self;
    [self addChildViewController:_chat];
    [self.scrollView addSubview:_chat.view];
    _chat.view.frame = CGRectMake(0, 0, kScreenWidth, self.scrollView.hd_height);
    _chat.viewHeight = self.scrollView.hd_height;
    
    _chat.getChatRecordBlick = ^(NSDictionary *info) {
        [weakSelf getLivaChatRecord];
    };
    
    self.chat.messageController.view.frame = CGRectMake(0, 0, kScreenWidth, self.scrollView.frame.size.height - TTextView_Height - Bottom_SafeHeight );
    self.chat.inputController.view.frame = CGRectMake(0, self.scrollView.frame.size.height - TTextView_Height - Bottom_SafeHeight, self.scrollView.frame.size.width, TTextView_Height + Bottom_SafeHeight);
    self.chat.giftBtn.frame = CGRectMake(kScreenWidth - 60, self.scrollView.frame.size.height - TTextView_Height - Bottom_SafeHeight - 60, 40, 40);
    
    self.chat.giftBlock = ^(NSDictionary *info) {
        [weakSelf giftAction];
    };
    
    
    self.giftView = [[LiveGiftSelectView alloc]initWithFrame:self.view.bounds];
    self.giftView.payBlock = ^(NSDictionary * _Nonnull info) {
        
        
//        NSDictionary *contentInfo = @{@"to_avatar":[weakSelf.teacherInfo objectForKey:@"avatar"],@"from_avatar":[[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl],@"money":[NSString stringWithFormat:@"%.2f", [[info objectForKey:@"price"] floatValue] * [[info objectForKey:@"count"] intValue]]};
//        NSString * jsonStr = [contentInfo JSONString];
//        [[UserManager sharedManager] didRequestSendMessageWithWithDic:@{kUrlName:@"api/topiclivechat/create",
//                                                                        @"topic_id":[weakSelf.videoInfo objectForKey:@"id"],
//                                                                        @"type":@"reward",
//                                                                        @"content":jsonStr,
//                                                                        @"ask":@"0",
//                                                                        @"content_ext":[NSString stringWithFormat:@"%@ 打赏了 %@ %@ * %@",[[[UserManager sharedManager] getUserInfos] objectForKey:kUserName],[weakSelf.teacherInfo objectForKey:@"nickname"], [info objectForKey:@"name"], [info objectForKey:@"count"]]} WithNotifedObject:weakSelf];
//
//        TUISystemMessageCellData *system = [[TUISystemMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
//        system.content = [NSString stringWithFormat:@"%@ 打赏了 %@ %@ * %@",[[[UserManager sharedManager] getUserInfos] objectForKey:kUserName],[weakSelf.teacherInfo objectForKey:@"nickname"], [info objectForKey:@"name"], [info objectForKey:@"count"]];
//        weakSelf.currentSendData = system;
        
        
        weakSelf.currentSendGiftInfo = info;
        weakSelf.isPayGift = YES;
        ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:NO];
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:payView];
        weakSelf.payView = payView;
    };
    
#pragma mark - buyVIP ********
    self.buyVipView = [[LivingBuyVIPView alloc]initWithFrame:self.view.bounds];
    self.buyVipView.VIPPayBlock = ^(NSDictionary * _Nonnull info) {
        NSLog(@"%@", info);
        weakSelf.currentBuyVIPInfo = info;
        weakSelf.isPayGift = NO;
        ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:NO];
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:payView];
        weakSelf.payView = payView;
        
        [weakSelf.buyVipView removeFromSuperview];
    };
    self.buyVipView.ShutupBlock = ^(BOOL isOn) {
        
        weakSelf.is_shutup = isOn;
        
        [weakSelf shutupAction];
    };
    
    self.buyVipView.buyVIPOperationBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf mockVIPBuyAction];
    };
    
    self.buyVipView.buyHeHuoRenOperationBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf mockPartnerBuyAction];
    };
    
    self.barrageView = [[BarrageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    self.barrageView.fatherView = self.scrollView;
    self.barrageView.delegate = self;
    self.barrageView.dataSouce = self;
    self.barrageView.speedBaseVlaue = 15.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewController)];
    [self.barrageView addGestureRecognizer:tap];
    [self.chat.messageController.view addSubview:self.barrageView];
    
    self.rightBarView = [[LivingRightTabbarView alloc]initWithFrame:CGRectMake(kScreenWidth - 50, self.scrollView.hd_y + 10, 40, 360) andIsTeacher:self.is_author];
    [self.view addSubview:self.rightBarView];
    self.rightBarView.rightTabbarActionBlock = ^(NSDictionary * _Nonnull info) {
        NSLog(@"%@", [info objectForKey:@"type"]);
        
        switch ([[info objectForKey:@"type"] intValue]) {
            case RightTabbarOperationType_shutUp:
            {
                BOOL isShutup = weakSelf.is_shutup;
                [weakSelf.buyVipView showShutUpViewInView:weakSelf.view andIsSHutup:isShutup];
            }
                break;
            case RightTabbarOperationType_moniV:
            {
                NSLog(@"模拟V");
                [weakSelf.buyVipView showBuyVIPViewInView:weakSelf.view];
            }
                break;
            case RightTabbarOperationType_moniP:
            {
                NSLog(@"模拟p");
                [weakSelf.buyVipView showBuyHeHuoRenViewInView:weakSelf.view];
            }
                break;
            case RightTabbarOperationType_invite:
            {
                NSLog(@"invite");
            }
                break;
            case RightTabbarOperationType_VIP:
            {
                [weakSelf.buyVipView showInView:weakSelf.view andIsVIP:YES];
            }
                break;
            case RightTabbarOperationType_Hehuoren:
            {
                [weakSelf.buyVipView showInView:weakSelf.view andIsVIP:NO];
            }
                break;
            case RightTabbarOperationType_publicNumber:
            {
                NSLog(@"公众号");
            }
                break;
            case RightTabbarOperationType_service:
            {
                NSLog(@"客服");
            }
                break;
                
            default:
                break;
        }
        
    };
    
    self.imageListView = [[LivingImageListView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.scrollView.hd_height)];
    [self.imageListView resetDataSource: [[self.videoInfo objectForKey:@"images"] objectForKey:@"data"]];
    [self.scrollView addSubview:self.imageListView];
    
    self.shareListView = [[LivingShareListView alloc]initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, self.scrollView.hd_height)];
    [self.scrollView addSubview:self.shareListView];
    self.shareListView.moreShareListBlock = ^(BOOL isFirst) {
        [weakSelf requestShareList:isFirst];
    };
}

- (void)didTapViewController
{
    [self.chat.inputController reset];
}

- (void)giftAction
{
    [self.giftView showInView:self.view];
}

- (V2TIMMessage *)transIMMsgFromUIMsg:(TUIMessageCellData *)data
{
    V2TIMMessage *msg = nil;
    if([data isKindOfClass:[TUITextMessageCellData class]]){
        TUITextMessageCellData *text = (TUITextMessageCellData *)data;
        if (text.atUserList.count > 0) {
            msg = [[V2TIMManager sharedInstance] createTextAtMessage:text.content atUserList:text.atUserList];
        } else {
            msg = [[V2TIMManager sharedInstance] createTextMessage:text.content];
        }
    }
    
    data.innerMessage = msg;
    return msg;

}

- (void)inputController:(TUIInputController *)inputController didChangeHeight:(CGFloat)height
{
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect msgFrame = ws.chat.messageController.view.frame;
        msgFrame.size.height = ws.chat.view.frame.size.height - height;
        ws.chat.messageController.view.frame = msgFrame;

        CGRect inputFrame = ws.chat.inputController.view.frame;
        inputFrame.origin.y =  msgFrame.size.height; // msgFrame.origin.y + msgFrame.size.height;
        inputFrame.size.height = height;
        ws.chat.inputController.view.frame = inputFrame;
        [ws.chat.messageController scrollToBottom:NO];
    } completion:nil];
}


- (void)playLiving:(NSDictionary *)videoInfo
{
    self.livePlayer.hidden = NO;
    LXPlayModel *model =[[LXPlayModel alloc]init];
       model.playUrl = self.playingVideo.playUrl;
       model.videoTitle = self.playingVideo.title;
       model.fatherView = self.playFatherView;
       self.livePlayer.currentModel = model;
    
    self.livePlayer.playURL = self.playUrl;
    [self.livePlayer startPlay];
    
}

- (void)playVideo:(NSDictionary *)videoInfo;
{
    self.playerview.hidden = NO;
    LXPlayModel *model =[[LXPlayModel alloc]init];
       model.playUrl = self.playingVideo.playUrl;
       model.videoTitle = self.playingVideo.title;
       model.fatherView = self.playFatherView;
       self.playerview.currentModel = model;
}

- (void)dealloc
{
    if (self.playerview) {
        [self.playerview destroyPlayer];
        self.playerview = nil;
    }
    if (self.livePlayer) {
        [self.livePlayer destroyPlayer];
        self.livePlayer = nil;
    }
    NSLog(@"界面释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOfShutUpNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOfMockVIPBuyNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOfAddChatRecord object:nil];
}


- (void)sendMessage:(TUIMessageCellData*)msg {
    
    NSDictionary * info = [[UserManager sharedManager] getUserInfos];
    
    NSString * type = @"say";
    NSString * uid = [NSString stringWithFormat:@"%@", [[[UserManager sharedManager] getUserInfos] objectForKey:kUserId]];
    NSString * create_time = [self getCurrentTimestamp];
    NSString * time = [self getTime];
    NSString * target = @"discuss";
    NSString * msgtype = @"";
    NSString * content = @"";
    NSString * chat_type = @"";
    NSString * content_ext = @"";
    if ([msg isKindOfClass:[TUITextMessageCellData class]]) {
        msgtype = @"text";
        TUITextMessageCellData * textData = (TUITextMessageCellData *)msg;
        content = textData.content;
    }else if ([msg isKindOfClass:[TUIImageMessageCellData class]])
    {
        msgtype = @"image";
        content = self.sendImageUrl;
    }else if ([msg isKindOfClass:[TUISystemMessageCellData class]])
    {
        TUISystemMessageCellData * systemData = (TUISystemMessageCellData *)msg;
        content = systemData.content;
        if ([systemData.content isEqualToString:@"on"] || [systemData.content isEqualToString:@"off"]) {
            msgtype = @"shutup";
            target = @"main";
        }else if([systemData.content containsString:@"打赏"])
        {
            msgtype = @"reward";
            chat_type = @"chat_discuss";
            content_ext = systemData.content;
            NSDictionary * contentInfo = @{@"to_avatar":[self.teacherInfo objectForKey:@"avatar"],@"from_avatar":[info objectForKey:kUserHeaderImageUrl],@"money":[NSString stringWithFormat:@"%.2f", [[self.currentSendGiftInfo objectForKey:@"price"] floatValue] * [[self.currentSendGiftInfo objectForKey:@"count"] intValue]]};
            content = [contentInfo JSONString];
        }
    }
    
    NSString * headimg = [info objectForKey:kUserHeaderImageUrl];
    NSString * from_client_name = [info objectForKey:kUserName];
    
    NSDictionary * jsonDic = @{@"type":type,
                               @"is_guest":@(self.is_guest),
                               @"is_author":@(self.is_author),
                               @"role_name":self.role_name,
                               @"uid":@(uid.intValue),
                               @"create_time":create_time,
                               @"time":time,
                               @"msg_id":self.msg_id,
                               @"target":target,
                               @"msgtype":msgtype,
                               @"headimg":headimg,
                               @"from_client_name":from_client_name,
                               @"content":content,
                               @"content_ext":content_ext,
                               @"chat_type":chat_type
    };
    
    NSString * jsonStr = [jsonDic JSONString];
    
    TUITextMessageCellData *data = [[TUITextMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    data.content = jsonStr;
   
    // 添加记录
    [self.chatRecordList insertObject:jsonDic atIndex:0];
    
    [self.chat.messageController sendMessage:data];
}


- (void)sendLocalMessage:(TUIMessageCellData*)msg {
    
    NSDictionary * info = [[UserManager sharedManager] getUserInfos];
    
    NSString * type = @"say";
    NSString * uid = [NSString stringWithFormat:@"%@", [[[UserManager sharedManager] getUserInfos] objectForKey:kUserId]];
    NSString * create_time = [self getCurrentTimestamp];
    NSString * time = [self getTime];
    NSString * target = @"discuss";
    NSString * msgtype = @"";
    NSString * content = @"";
    if ([msg isKindOfClass:[TUITextMessageCellData class]]) {
        msgtype = @"text";
        TUITextMessageCellData * textData = (TUITextMessageCellData *)msg;
        content = textData.content;
    }else if ([msg isKindOfClass:[TUIImageMessageCellData class]])
    {
        msgtype = @"image";
        content = self.sendImageUrl;
    }else if ([msg isKindOfClass:[TUISystemMessageCellData class]])
    {
        TUISystemMessageCellData * systemData = (TUISystemMessageCellData *)msg;
        if ([systemData.content isEqualToString:@"on"] || [systemData.content isEqualToString:@"off"]) {
            msgtype = @"shutup";
            target = @"main";
        }else
        {
            msgtype = @"reward";
        }
        content = systemData.content;
    }
    
    
    NSString * headimg = [info objectForKey:kUserHeaderImageUrl];
    NSString * from_client_name = [info objectForKey:kUserName];
    
    NSDictionary * jsonDic = @{@"type":type,
                               @"is_guest":@(self.is_guest),
                               @"is_author":@(self.is_author),
                               @"role_name":self.role_name,
                               @"uid":@(uid.intValue),
                               @"create_time":create_time,
                               @"time":time,
                               @"msg_id":self.msg_id,
                               @"target":target,
                               @"msgtype":msgtype,
                               @"headimg":headimg,
                               @"from_client_name":from_client_name,
                               @"content":content
    };
    
    NSString * jsonStr = [jsonDic JSONString];
    
    TUITextMessageCellData *data = [[TUITextMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    data.content = jsonStr;
   
    // 添加记录
    [self.chatRecordList insertObject:jsonDic atIndex:0];
    
    [self.chat.messageController sendLocalMessage:data];
}


#pragma mark - chatDelegate
/**
 *  发送新消息时的回调
 *
 *  @param controller 委托者，当前聊天控制器。
 *  @param msgCellData TUIMessageCellData 即将发送的 msgCellData 。
 */
- (void)chatController:(CustomTUIChatController *)controller didSendMessage:(TUIMessageCellData *)msgCellData
{
//    self.chat.inputController.inputBar
    self.currentSendData = msgCellData;
    if ([msgCellData isKindOfClass:[TUITextMessageCellData class]]) {
        // 文字消息
        NSLog(@" *************** 文字消息");
        // @{kUrlName:@"api/topiclivechat/record",@"topic_id":[self.videoInfo objectForKey:@"id"],@"page":@(self.page)}
        TUITextMessageCellData * textData = msgCellData;
        NSString * utf8Str = [textData.content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UserManager sharedManager] didRequestSendMessageWithWithDic:@{kUrlName:@"api/topiclivechat/create",@"topic_id":[self.videoInfo objectForKey:@"id"],@"type":@"text",@"content":textData.content,@"ask":@"0",@"content_ext":@""} WithNotifedObject:self];
        
    }else if ([msgCellData isKindOfClass:[TUIImageMessageCellData class]])
    {
        // 图片消息
        NSLog(@" *************** 图片消息");
        TUIImageMessageCellData * imageData = msgCellData;
        
        [[HttpUploaderManager sharedManager] uploadImage:[NSData dataWithContentsOfFile:imageData.path] withProcessDelegate:self];
    }
    
}



/**
 *  点击某一“更多”单元的回调委托。
 *  当您点击某一“更多”单元后回执行该回调，您可以通过该回调实现对“更多”视图的定制。
 *  比如您在更多视图4个单元的基础上，添加了一个名为 myMoreCell 的第5个单元，则您可以按下列代码实现该自定义单元的响应回调。
 * <pre>
 *  - (void)chatController:(TUIChatController *)chatController onSelectMoreCell:(TUIInputMoreCell *)cell{
 *      if ([cell.data.title isEqualToString:@"myMoreCell"]) {
 *       //Do something
 *      }
 *  }
 *</pre>
 *
 *  @param chatController 委托者，当前聊天控制器。
 *  @param cell 被点击的“更多”单元，在此回调中特指您自定义的“更多”单元。
 */
- (void)chatController:(CustomTUIChatController *)chatController onSelectMoreCell:(TUIInputMoreCell *)cell
{
    
}

/**
 *  点击消息头像回调
 *  默认点击头像是打开联系人资料页，如果您实现了此方法，则内部不做任何处理
 *
 *  @param controller 会话对象
 *  @param cell 所点击的消息单元
 */
- (void)chatController:(CustomTUIChatController *)controller onSelectMessageAvatar:(TUIMessageCell *)cell
{
    
}

/**
 *  点击消息内容回调
 *
 *  @param controller 会话对象
 *  @param cell 所点击的消息单元
 */
- (void)chatController:(CustomTUIChatController *)controller onSelectMessageContent:(TUIMessageCell *)cell
{
    TUIMessageCellData *messageData = cell.messageData;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [cell convertRect:cell.bounds toView:window];

    
//    NSMutableArray * imageArray = [NSMutableArray array];
//    for (int i = 0 ; i < self.chatRecordList.count; i++) {
//        NSDictionary * messageInfo = [self.chatRecordList objectAtIndex:i];
//
//        if ([[messageInfo objectForKey:@"type"] isEqualToString:@"image"] || [[messageInfo objectForKey:@"msgtype"] isEqualToString:@"image"]) {
//            [imageArray addObject:messageInfo];
//        }
//    }
    
    if ([messageData isKindOfClass:[TUIImageMessageCellData class]]) {
        NSLog(@"click TUIImageMessageCellData *** %@", messageData);
        TUIImageMessageCellData * imageData = messageData;
        [self showBigImage:@[@{@"content":imageData.path}] andStartPoint:rect];
    }
    
}

- (void)showBigImage:(NSArray *)imageUrlArray andStartPoint:(CGRect)Rect
{
    TestImageView *showView = [[TestImageView alloc] initWithFrame:self.view.frame andImageList:imageUrlArray];
    showView.outsideFrame = Rect;
    showView.insideFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [showView show];
}

#pragma mark - sendMessage
- (void)didSendMessageSuccessed
{
    self.msg_id = [NSString stringWithFormat:@"%@", [[[UserManager sharedManager] getMessageId] objectForKey:@"msg_id"]];
    self.msg_type = [NSString stringWithFormat:@"%@", [[[UserManager sharedManager] getMessageId] objectForKey:@"msg_type"]];
    [self sendMessage:self.currentSendData];
}

- (NSString *)getCurrentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (NSString *)getTime
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString * timeStr = [formatter stringFromDate:date];
    return timeStr;
}

- (void)didSendMessageFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - uploadMessage
- (void)didUploadSuccess:(NSDictionary *)successInfo
{
    self.sendImageUrl = [successInfo objectForKey:@"url"];
    [[UserManager sharedManager] didRequestSendMessageWithWithDic:@{kUrlName:@"api/topiclivechat/create",@"topic_id":[self.videoInfo objectForKey:@"id"],@"type":@"image",@"content":[successInfo objectForKey:@"url"],@"ask":@"0",@"content_ext":@""} WithNotifedObject:self];
}

- (void)didUploadFailed:(NSString *)uploadFailed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:uploadFailed];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - shutup
- (void)shutupAction
{
    NSString * type = @"off";
    if (self.is_shutup) {
        type = @"on";
    }
    
    [[UserManager sharedManager] didRequestShutupWithInfo:@{kUrlName:@"api/topiclivechat/shutUp",@"topic_id":[self.videoInfo objectForKey:@"id"],@"type":type} withNotifiedObject:self];
}

- (void)shutUpClick:(NSNotification *)notification
{
    NSDictionary * stateInfo = notification.object;
    BOOL isOn = [[stateInfo objectForKey:@"state"] boolValue];
    if (isOn) {
        self.chat.inputController.view.hidden = YES;
    }else
    {
        self.chat.inputController.view.hidden = NO;
    }
    
}

- (void)shutUpWithState:(BOOL)isOn
{
    if (isOn) {
        self.chat.inputController.view.hidden = YES;
        TUISystemMessageCellData *system = [[TUISystemMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
        system.content = @"on";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendLocalMessage:system];
        });
        
    }else
    {
        self.chat.inputController.view.hidden = NO;
    }
}


- (void)didRequestShutupSuccessed
{
    TUISystemMessageCellData *system = [[TUISystemMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    
    if (self.is_shutup) {
        system.content = @"on";
    }else
    {
        system.content = @"off";
    }
    [self sendMessage:system];
}

- (void)didRequestShutupFailed:(NSString *)failedInfo
{
    self.is_shutup = !self.is_shutup;
    [self.buyVipView resetShutupWithNojuristic];
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - mock buy
- (void)mockVIPBuyAction
{
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/topiclive/mockVip",@"topic_id":[self.videoInfo objectForKey:@"id"]} withNotifiedObject:self];
}

- (void)didRequestMockVIPBuySuccessed
{
    NSDictionary * vipInfo = [[UserManager sharedManager] getVIPBuyInfo];
    
    [self mockBuySuccess:vipInfo];
}

- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)mockPartnerBuyAction
{
    [[UserManager sharedManager] didRequestMockPartnerBuyWithInfo:@{kUrlName:@"api/topiclive/mockPartner",@"topic_id":[self.videoInfo objectForKey:@"id"]} withNotifiedObject:self];
}

- (void)didRequestMockPartnerBuySuccessed
{
    NSDictionary * partnerInfo = [[UserManager sharedManager] getPartnerBuyInfo];
    [self mockBuySuccess:partnerInfo];
}

- (void)didRequestMockPartnerBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)mockBuySuccess:(NSDictionary *)info
{
    NSArray *rebateArray = [info objectForKey:@"data"];
    
    NSString * jsonStr = [info JSONString];
    TUITextMessageCellData *data = [[TUITextMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    data.content = jsonStr;
   
    [self.chat.messageController sendMessage:data];
    
    [self sendDanmakuWith:rebateArray];
}

- (void)sendDanmakuWith:(NSArray *)rebateArray
{
    for (int i = 0; i < rebateArray.count; i++) {
        NSDictionary * rebateInfo = [rebateArray objectAtIndex:i];
        
        if (i == 0) {
            BarrageModel * model = [[BarrageModel alloc]init];
            model.avatar = [rebateInfo objectForKey:@"user_headimg"];
            model.message = [NSString stringWithFormat:@"%@购买了%@", [rebateInfo objectForKey:@"user_nick"], [rebateInfo objectForKey:@"vip_title"]];
            [self.barrageView insertBarrages:@[model] immediatelyShow:YES];
            continue;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BarrageModel * model = [[BarrageModel alloc]init];
            model.avatar = [rebateInfo objectForKey:@"head"];
            model.message = [NSString stringWithFormat:@"恭喜：%@获得￥%@分成奖励!", [rebateInfo objectForKey:@"nick"], [rebateInfo objectForKey:@"divide_money"]];
            [self.barrageView insertBarrages:@[model] immediatelyShow:YES];
        });
        
    }
}


- (void)mockVIPBuyClick:(NSNotification *)notification
{
    NSString * stateInfo = notification.object;
    
    if([stateInfo containsString:@"&quot"])
    {
        // 收到公众号消息
        NSString * jsonStr = @"";
        
        jsonStr = [stateInfo stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        NSLog(@"%@", jsonStr);
        
        NSData * jsondata = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        __autoreleasing NSError* error = nil;
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
        [self sendDanmakuWith:[infoDic objectForKey:@"data"]];
        
    }else
    {
        // 收到APP发送消息
        NSData * jsondata = [stateInfo dataUsingEncoding:NSUTF8StringEncoding];
        __autoreleasing NSError* error = nil;
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
        [self sendDanmakuWith:[infoDic objectForKey:@"data"]];
    }
    
}

- (void)addChatRecord:(NSNotification *)notification
{
    // 保存消息记录
    NSString * stateInfo = notification.object;
    if([stateInfo containsString:@"&quot"])
    {
        // 收到公众号消息
        NSString * jsonStr = @"";
        
        jsonStr = [stateInfo stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        NSLog(@"%@", jsonStr);
        
        NSData * jsondata = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        __autoreleasing NSError* error = nil;
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
        if(infoDic)
        {
            [self.chatRecordList insertObject:infoDic atIndex:0];
        }
        
    }else
    {
        // 收到APP发送消息
        NSData * jsondata = [stateInfo dataUsingEncoding:NSUTF8StringEncoding];
        __autoreleasing NSError* error = nil;
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
        if(infoDic)
        {
            [self.chatRecordList insertObject:infoDic atIndex:0];
        }
    }
}


#pragma mark - gift and shareList
- (void)getGiftList
{
    [[UserManager sharedManager] didRequestGiftListWithWithDic:@{kUrlName:@"api/topicLive/gifts",@"topic_id":[self.videoInfo objectForKey:@"id"]} WithNotifedObject:self];
}

- (void)didRequestGiftListSuccessed
{
    [self.giftView resetWithInfoArray:[[UserManager sharedManager] getGiftList]];
}

- (void)didRequestGiftListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)requestShareList:(BOOL)isFirst
{
    if (isFirst) {
        self.shareListPage = 1;
    }else
    {
        self.shareListPage++;
    }
    [[UserManager sharedManager] didRequestShareListWithInfo:@{kUrlName:@"api/topicLive/inviteList",@"topic_id":[self.videoInfo objectForKey:@"id"],@"page":@(self.shareListPage)} withNotifiedObject:self];
}

- (void)didRequestShareListSuccessed
{
    NSArray * shareList = [[UserManager sharedManager] getShareList];
    
    BOOL isFirst;
    if (self.shareListPage == 1) {
        isFirst = YES;
    }else
    {
        isFirst = NO;
    }
    
    [self.shareListView addDataSource:shareList withFirstPage:isFirst];
}

- (void)didRequestShareListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


#pragma mark - HYSegmentControlDelegate
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:NO];
    
    
}

// 获取用户权限
- (void)getUserJurisdiction
{
    NSDictionary * userInfo = [[UserManager sharedManager] getUserInfos];
    NSString * userId = [NSString stringWithFormat:@"%@", [userInfo objectForKey:kUserId]];
    NSString * teacherId = [NSString stringWithFormat:@"%@", [self.teacherInfo objectForKey:@"user_id"]];
    if ([teacherId isEqualToString:userId]) {
        self.is_author = YES;
    }else
    {
        self.is_author = NO;
    }
    
    NSDictionary * currentGuestInfo;
    for (NSDictionary * guestInfo in self.guestsArray) {
        NSString * guestId = [NSString stringWithFormat:@"%@", [guestInfo objectForKey:@"uid"]];
        if ([guestId isEqualToString:userId]) {
            self.is_guest = YES;
            currentGuestInfo = guestInfo;
        }else
        {
            self.is_guest = NO;
        }
    }
    
    if (self.is_guest) {
        self.role_name = [currentGuestInfo objectForKey:@"title"];
    }else if (self.is_author)
    {
        self.role_name = @"老师";
    }else
    {
        self.role_name = @"";
    }
    
}

#pragma mark - BarrageViewDataSource

- (NSUInteger)numberOfRowsInTableView:(BarrageView *)barrageView
{
    return 3;
}

- (BarrageViewCell *)barrageView:(BarrageView *)barrageView cellForModel:(id<BarrageModelAble>)model
{
    CustomCell *cell = [CustomCell cellWithBarrageView:barrageView];
    cell.model = (BarrageModel *)model;
    return cell;
}

#pragma mark - BarrageViewDelegate

- (void)barrageView:(BarrageView *)barrageView didSelectedCell:(BarrageViewCell *)cell
{
//    CustomCell *customCell = (CustomCell *)cell;
//    NSLog(@"你点击了:%@", customCell.model.message);
}

- (void)barrageView:(BarrageView *)barrageView willDisplayCell:(BarrageViewCell *)cell
{
//    CustomCell *customCell = (CustomCell *)cell;
//    NSLog(@"%@即将展示", customCell.model.message);
}

- (void)barrageView:(BarrageView *)barrageView didEndDisplayingCell:(BarrageViewCell *)cell
{
//    CustomCell *customCell = (CustomCell *)cell;
//    NSLog(@"%@展示完成", customCell.model.message);
}

@end
