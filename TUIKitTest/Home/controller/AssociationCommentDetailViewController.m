//
//  AssociationCommentDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "AssociationCommentDetailViewController.h"
#import "WFReplyBody.h"
#import "YMTextData.h"
#import "WFMessageBody.h"
#import "WriteCommentContentView.h"

#import "AssociationCommentTableViewCell.h"
#define kAssociationCommentTableViewCell @"AssociationCommentTableViewCell"
#import "AssociationCommentReplayTableViewCell.h"
#define kAssociationCommentReplayTableViewCell @"AssociationCommentReplayTableViewCell"
#import "AssociationAdminInfoTableViewCell.h"
#define kAssociationAdminInfoTableViewCell @"AssociationAdminInfoTableViewCell"
#import "AssociationDetailViewController.h"
#import "DeleteAssociationDynamicView.h"


@interface AssociationCommentDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_MockVIPBuy,UserModule_GiftList,UserModule_AddDynamicComment,UserModule_CommentZanProtocol,UserModule_DeleteDynamicComment,UserModule_jingpinDynamic, UserModule_deleteDynamic>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;

@property (nonatomic, assign)int community_uid;// 当前社群，自己的成员id

@property (nonatomic, strong)WriteCommentContentView * writeCommentView;// 添加评论
@property (nonatomic, strong)NSString * commentStr;

@property (nonatomic, strong)NSDictionary * dynamicInfo;//

@property (nonatomic, strong)NSDictionary *currentSelectInfo;
@property (nonatomic, strong)NSDictionary * currentReplayInfo;

@end

@implementation AssociationCommentDetailViewController
- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.community_uid = [[self.associationInfo objectForKey:@"community_uid"] intValue];
    [self loadData];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self navigationViewSetup];
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyBoardHeight = keyboardRect.size.height;
    
//    [self.writeCommentView hideOperationBtn];
    CGRect beginUserInfo = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if (beginUserInfo.size.height <=0) {//!!搜狗输入法弹出时会发出三次UIKeyboardWillShowNotification的通知,和官方输入法相比,有效的一次为dUIKeyboardFrameBeginUserInfoKey.size.height都大于零时.
        return;
    }
    self.writeCommentView.frame = CGRectMake(0,kScreenHeight - kStatusBarHeight - kNavigationBarHeight - keyBoardHeight - 50, kScreenWidth, 50);
    NSLog(@"self.writeCommentView.frame = %@", self.writeCommentView.frame);
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    self.writeCommentView.frame = CGRectMake(0,kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kbSize.height - 50, kScreenWidth, 50);
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    [self.writeCommentView showOperationBtn];
    self.writeCommentView.frame = CGRectMake(0, kScreenHeight - kStatusBarHeight - kNavigationBarHeight - 50, kScreenWidth, 50);
    //do something
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"动态详情";
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
    if (self.commentBlock) {
        self.commentBlock(self.infoDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData
{
    self.page = 1;
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/community/dynamicDetail",@"c_id":[self.infoDic objectForKey:@"c_id"],@"d_id":[self.infoDic objectForKey:@"id"],@"include":@"zan_name",kRequestType:@"get"} withNotifiedObject:self];
    
    [self doRequest];
}

- (void)doNextPageQuestionRequest
{
    self.page++;
    
    [self doRequest];
}

- (void)doRequest
{
    [[UserManager sharedManager] didRequestGiftListWithInfo:@{kUrlName:@"api/community/dynamicdislist",kRequestType:@"get",@"c_id":[self.infoDic objectForKey:@"c_id"],@"d_id":[self.infoDic objectForKey:@"id"],@"pindex":@(self.page),@"include":@"reply"} withNotifiedObject:self];
}

- (void)prepareUI
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    [self.tableView registerClass:[AssociationCommentTableViewCell class] forCellReuseIdentifier:kAssociationCommentTableViewCell];
    [self.tableView registerClass:[AssociationCommentReplayTableViewCell class] forCellReuseIdentifier:kAssociationCommentReplayTableViewCell];
    [self.tableView registerClass:[AssociationAdminInfoTableViewCell class] forCellReuseIdentifier:kAssociationAdminInfoTableViewCell];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
    
    __weak typeof(self)weakSelf = self;
    self.writeCommentView = [[WriteCommentContentView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50 - kNavigationBarHeight - kStatusBarHeight, kScreenWidth, 50) andInfo:self.infoDic];
    [self.view addSubview:self.writeCommentView];
    self.writeCommentView.commitBlock = ^(NSString *comment) {
        NSLog(@"%@", comment);
        weakSelf.writeCommentView.textView.text = @"";
        weakSelf.commentStr = comment;
//        [SVProgressHUD show];
        [weakSelf addDynamicComment:weakSelf.currentSelectInfo andContent:comment];
    };
    
    self.writeCommentView.goodBlock = ^(NSDictionary *info) {
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestCommentZantWithCourseInfo:@{kUrlName:@"api/community/dynamicclickzan",@"c_id":[weakSelf.infoDic objectForKey:@"c_id"],@"d_id":[weakSelf.infoDic objectForKey:@"id"],kRequestType:@"get"} withNotifiedObject:weakSelf];
    };
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.itemArray.count;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            AssociationAdminInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationAdminInfoTableViewCell forIndexPath:indexPath];
            [cell refreshUIWith:[self.associationInfo objectForKey:@"admin_info"]];
            cell.joinBlock = ^(NSDictionary * _Nonnull info) {
                AssociationDetailViewController * vc = [[AssociationDetailViewController alloc]init];
                vc.infoDic = weakSelf.associationInfo;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
        
        AssociationCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationCommentTableViewCell forIndexPath:indexPath];
        [cell refresCommentDetailhUIWith:self.infoDic];
        cell.deleteBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf deleteDynamic:info];
        };
        return cell;
    }
    
    AssociationCommentReplayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationCommentReplayTableViewCell forIndexPath:indexPath];
    [cell refreshUIWith:[self.itemArray objectAtIndex:indexPath.row]];
    
    
    cell.operationCommentBlock = ^(NSDictionary * _Nonnull info, NSDictionary * _Nonnull dynamicInfo) {
        weakSelf.currentSelectInfo = dynamicInfo;
        weakSelf.currentReplayInfo = info;
        [weakSelf judgeAddOrDelete];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 40;
        }
        
        NSDictionary * info = self.infoDic;
        NSString * contentStr = [info objectForKey:@"content"];
        CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
        
        int imageCount = [[info objectForKey:@"c_imgs"] count] % 3 == 0 ? [[info objectForKey:@"c_imgs"] count] / 3 : [[info objectForKey:@"c_imgs"] count] / 3 + 1;
        CGFloat imageHeight = (kCellHeightOfCategoryView + 5) * imageCount;
        
        NSString * zanStr = @"、马传博、{{nick_name}}、不喜欢没礼貌的人- 等五人觉得很赞";
        CGFloat zanHeight = [zanStr boundingRectWithSize:CGSizeMake(kScreenWidth - 70, MAXFRAG) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.height;
        
        return 15 + 30 + 10 + height + 5 + imageHeight + 10 + zanHeight + 15 + 15;
    }
    
    YMTextData * ymData = [self.itemArray objectAtIndex:indexPath.row];
    
    NSString * content = [ymData.infoDic objectForKey:@"content"];
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height + 5;
    
    if (ymData.replyHeight <= 0) {
        return ymData.replyHeight + 65 + contentHeight;
    }
    
    return ymData.replyHeight + 75 + contentHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.writeCommentView textViewResignFirstResponder];
        self.currentSelectInfo = nil;
        self.currentReplayInfo = nil;
        return;
    }
    
    YMTextData *ymData = self.itemArray[indexPath.row];
    self.currentSelectInfo = ymData.infoDic;
    
    [self judgeAddOrDelete];
}

- (void)judgeAddOrDelete
{
    if (self.currentReplayInfo) {
        if ([[self.currentReplayInfo objectForKey:@"c_uid"] intValue] == self.community_uid) {
            NSLog(@"自己的评论,需要delete");
            [self delleteComment];
            return;
        }
    }else
    {
        if ([[self.currentSelectInfo objectForKey:@"c_uid"] intValue] == self.community_uid) {
            NSLog(@"自己的评论,需要delete");
            [self delleteComment];
            return;
        }
    }
    
    [self.writeCommentView textViewBecomeFirstResponder];
}

#pragma mark - jingpinDynamic
- (void)deleteDynamic:(NSDictionary *)info
{
    NSLog(@"delete");
    DeleteAssociationDynamicView * view = [[DeleteAssociationDynamicView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andInfo:info];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:view];
    __weak typeof(self)weakSelf = self;
    view.deleteBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf deleteDynamic];
    };
    view.jingpinBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf jingpinDynamic];
    };
   
}

- (void)jingpinDynamic
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getjingpinDynamicWith:@{kUrlName:@"api/community/dynamicchangeisshow",@"c_id":[self.associationInfo objectForKey:@"id"],@"d_id":[self.infoDic objectForKey:@"id"],kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didjingpinDynamicSuccessed
{
    [SVProgressHUD dismiss];
}

- (void)didjingpinDynamicFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - deleteDynamic
- (void)deleteDynamic
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getdeleteDynamicWith:@{kUrlName:@"api/community/dynamicdelete",@"c_id":[self.associationInfo objectForKey:@"id"],@"d_id":[self.infoDic objectForKey:@"id"],kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didDeleteDynamicSuccessed
{
    [SVProgressHUD dismiss];
    if (self.deleteBlock) {
        self.deleteBlock(self.infoDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didDeleteDynamicFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


#pragma mark - deleteComment
- (void)delleteComment
{
    __weak typeof(self)weakSelf = self;
    DeleteAssociationDynamicView * view = [[DeleteAssociationDynamicView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andInfo:self.currentSelectInfo];
    [view refreshDelete];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:view];
    
    view.dismissBlock = ^(NSDictionary * _Nonnull info) {
        weakSelf.currentSelectInfo = nil;
        weakSelf.currentReplayInfo = nil;
    };
    
    view.deleteBlock = ^(NSDictionary * _Nonnull info) {
        
        NSString * dis_id = @"";
        // 判断删除的是一级评论还是子级评论
        if (weakSelf.currentReplayInfo) {
            dis_id = [weakSelf.currentReplayInfo objectForKey:@"id"];
        }else
        {
            dis_id = [weakSelf.currentSelectInfo objectForKey:@"id"];
        }
        
        [[UserManager sharedManager] getDeleteDynamicCommentWith:@{kUrlName:@"api/community/dynamicdisdelete",@"c_id":[weakSelf.infoDic objectForKey:@"c_id"],@"d_id":[weakSelf.infoDic objectForKey:@"id"],@"dis_id":dis_id,kRequestType:@"get"} withNotifiedObject:weakSelf];
    };
}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD dismiss];
    self.dynamicInfo = [[UserManager sharedManager] getVIPBuyInfo];
    [self.writeCommentView refreshUIWithInfo:self.dynamicInfo];
    [self.tableView reloadData];
}

- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)didRequestGiftListSuccessed
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD dismiss];
    NSArray * commentList = [[UserManager sharedManager] getGiftList];
    
    
    
    if (self.currentSelectInfo) {
        
        YMTextData * data;
        NSDictionary *commentInfo;
        
        for (YMTextData * ymData in self.itemArray) {
            if ([[self.currentSelectInfo objectForKey:@"id"] isEqual:[ymData.infoDic objectForKey:@"id"]]) {
                data = ymData;
            }
        }
        for (NSDictionary * info in commentList) {
            if ([[self.currentSelectInfo objectForKey:@"id"] isEqual:[info objectForKey:@"id"]]) {
                commentInfo = info;
            }
        }
        
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:commentInfo];
        [mInfo setObject:[commentInfo objectForKey:@"avatar"] forKey:@"img_url"];
        [mInfo setObject:[commentInfo objectForKey:@"create_time"] forKey:@"time"];
        [mInfo setObject:[commentInfo objectForKey:@"c_name"] forKey:@"title"];
        WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
        messBody1.posterContent = [commentInfo objectForKey:@"content"];
        messBody1.posterImgstr = [NSString stringWithFormat:@"%@",[commentInfo objectForKey:@"avatar"]];
        messBody1.posterName = [commentInfo objectForKey:@"c_name"];
        messBody1.posterIntro = [commentInfo objectForKey:@"content"];
        messBody1.publishTime = [commentInfo objectForKey:@"create_time"];
        messBody1.isFavour = YES;
        
        for (NSDictionary * replayInfo in [[commentInfo objectForKey:@"reply"] objectForKey:@"data"]) {
            WFReplyBody *body6 = [[WFReplyBody alloc] init];
            body6.replyUser = [replayInfo objectForKey:@"c_name"];
            body6.repliedUser = [replayInfo objectForKey:@"reply_name"];
            body6.replyInfo = [replayInfo objectForKey:@"content"];
            body6.info = replayInfo;
            [messBody1.posterReplies addObject:body6];
        }
        
        YMTextData *ymData = [[YMTextData alloc] init ];
        ymData.messageBody = messBody1;
        ymData.infoDic = mInfo;
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:(kScreenWidth - 80)];
        
        NSInteger index = [self.itemArray indexOfObject:data];
        [self.itemArray replaceObjectAtIndex:index withObject:ymData];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
        self.currentReplayInfo = nil;
        self.currentSelectInfo = nil;
        return;
    }
    
    if (self.page == 1) {
        [self.itemArray removeAllObjects];
    }
    if ([[[UserManager sharedManager] getGiftList] count] <= 0) {
        
        if (self.page > 1 ) {
            self.page--;
        }
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    for (NSDictionary * commentInfo in commentList) {
        
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:commentInfo];
        [mInfo setObject:[commentInfo objectForKey:@"avatar"] forKey:@"img_url"];
        [mInfo setObject:[commentInfo objectForKey:@"create_time"] forKey:@"time"];
        [mInfo setObject:[commentInfo objectForKey:@"c_name"] forKey:@"title"];
        
        
        WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
        messBody1.posterContent = [commentInfo objectForKey:@"content"];
//        messBody1.posterPostImage = @[chang];
//        messBody1.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
        messBody1.posterImgstr = [NSString stringWithFormat:@"%@",[commentInfo objectForKey:@"avatar"]];
        messBody1.posterName = [commentInfo objectForKey:@"c_name"];
        messBody1.posterIntro = [commentInfo objectForKey:@"content"];
        messBody1.publishTime = [commentInfo objectForKey:@"create_time"];
        messBody1.isFavour = YES;
        
        for (NSDictionary * replayInfo in [[commentInfo objectForKey:@"reply"] objectForKey:@"data"]) {
            WFReplyBody *body6 = [[WFReplyBody alloc] init];
            body6.replyUser = [replayInfo objectForKey:@"c_name"];
            body6.repliedUser = [replayInfo objectForKey:@"reply_name"];
            body6.replyInfo = [replayInfo objectForKey:@"content"];
            body6.info = replayInfo;
            [messBody1.posterReplies addObject:body6];
        }
        
        YMTextData *ymData = [[YMTextData alloc] init ];
        ymData.messageBody = messBody1;
        ymData.infoDic = mInfo;
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:(kScreenWidth - 80)];
        [self.itemArray addObject:ymData];
    }
    
    [self.tableView reloadData];
}

- (void)didRequestGiftListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.currentReplayInfo = nil;
    self.currentSelectInfo = nil;
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - zan
- (void)didRequestCommentZanSuccessed
{
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/community/dynamicDetail",@"c_id":[self.infoDic objectForKey:@"c_id"],@"d_id":[self.infoDic objectForKey:@"id"],@"include":@"zan_name",kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didRequestCommentZanFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


#pragma mark - addDynamicComment
-(void)addDynamicComment:(NSDictionary *)info andContent:(NSString *)content
{
    NSString * p_id = @"";
    NSString * reply_id = @"";
    
    if (self.currentReplayInfo) {
        reply_id = [self.currentReplayInfo objectForKey:@"id"];
        p_id = [self.currentReplayInfo objectForKey:@"p_id"];
    }else
    {
        if (self.currentSelectInfo) {
            p_id = [self.currentSelectInfo objectForKey:@"id"];
        }
    }
    
    [SVProgressHUD show];
    [[UserManager sharedManager] getAddDynamicCommentWith:@{kUrlName:@"api/community/dynamicdisadd",@"c_id":[self.infoDic objectForKey:@"c_id"],@"d_id":[self.infoDic objectForKey:@"id"],@"p_id":p_id,@"reply_id":reply_id,@"content":content,kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didAddDynamicCommentSuccessed
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
    
    if (self.currentSelectInfo) {
        
       /*
        WFReplyBody *body6 = [[WFReplyBody alloc] init];
        body6.replyUser = [[UserManager sharedManager] getUserNickName];
        body6.repliedUser = @"";
        // 判断添加的是一级评论还是子级评论
        if (self.currentReplayInfo) {
            body6.repliedUser = [self.currentReplayInfo objectForKey:@"c_name"];
        }
        body6.replyInfo = self.commentStr;
        
        YMTextData * ymData ;
        
        for (YMTextData * ymData1 in self.itemArray) {
            
            if ([[ymData1.infoDic objectForKey:@"id"] isEqual:[self.currentSelectInfo objectForKey:@"id"]]) {
                
                ymData = ymData1;
                
                break;
            }
            
        }
        
        
        WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
        messBody1.posterContent = ymData.messageBody.posterContent;
        messBody1.posterImgstr = ymData.messageBody.posterImgstr;
        messBody1.posterName = ymData.messageBody.posterName;
        messBody1.posterIntro = ymData.messageBody.posterIntro;
        messBody1.publishTime = ymData.messageBody.publishTime;
        for (WFReplyBody * body in ymData.messageBody.posterReplies) {
            [messBody1.posterReplies addObject:body];
        }
        [messBody1.posterReplies addObject:body6];
        ymData.messageBody = messBody1;
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:(kScreenWidth - 80)];
        
        
        
        YMTextData *newYmData = [[YMTextData alloc] init ];
        newYmData.messageBody = messBody1;
        newYmData.infoDic = ymData.infoDic;
        newYmData.replyHeight = [newYmData calculateReplyHeightWithWidth:(kScreenWidth - 80)];
        
        NSInteger index = [self.itemArray indexOfObject:ymData];
        [self.itemArray removeObject:ymData];
        
        [self.itemArray insertObject:newYmData atIndex:index];
        
        [self.tableView reloadData];*/
        
        [self doRequest];
        
    }else
    {
        self.page = 1;
        [self loadData];
    }
    
    self.commentStr = @"";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didAddDynamicCommentFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    self.currentReplayInfo = nil;
    self.currentSelectInfo = nil;
    self.commentStr = @"";
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didDeleteDynamicCommentSuccessed
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD dismiss];
    
    if (self.currentSelectInfo) {
        
        if (self.currentReplayInfo) {
            YMTextData * ymData ;
            
            for (YMTextData * ymData1 in self.itemArray) {
                if ([[ymData1.infoDic objectForKey:@"id"] isEqual:[self.currentSelectInfo objectForKey:@"id"]]) {
                    ymData = ymData1;
                    break;
                }
            }
            
            YMTextData *newYmData = [[YMTextData alloc] init ];
            newYmData.infoDic = ymData.infoDic;
            
            WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
            messBody1.posterContent = ymData.messageBody.posterContent;
            messBody1.posterImgstr = ymData.messageBody.posterImgstr;
            messBody1.posterName = ymData.messageBody.posterName;
            messBody1.posterIntro = ymData.messageBody.posterIntro;
            messBody1.publishTime = ymData.messageBody.publishTime;
            
            for (WFReplyBody * body in ymData.messageBody.posterReplies) {
                [messBody1.posterReplies addObject:body];
            }
            WFReplyBody *body6 ;
            for (WFReplyBody * body in messBody1.posterReplies) {
                if ([[self.currentReplayInfo objectForKey:@"id"] isEqual:[body.info objectForKey:@"id"]]) {
                    body6 = body;
                    break;
                }
            }
            [messBody1.posterReplies removeObject:body6];
            newYmData.messageBody = messBody1;
            newYmData.replyHeight = [newYmData calculateReplyHeightWithWidth:(kScreenWidth - 80)];
            
            NSInteger index = [self.itemArray indexOfObject:ymData];
            [self.itemArray removeObject:ymData];
            
            [self.itemArray insertObject:newYmData atIndex:index];
            
            [self.tableView reloadData];
            
        }else
        {
            YMTextData * ymData ;
            for (YMTextData * ymData1 in self.itemArray) {
                if ([[ymData1.infoDic objectForKey:@"id"] isEqual:[self.currentSelectInfo objectForKey:@"id"]]) {
                    ymData = ymData1;
                    break;
                }
            }
            [self.itemArray removeObject:ymData];
            [self.tableView reloadData];
        }
        
        
    }else
    {
        self.page = 1;
        [self loadData];
    }
    
    self.currentSelectInfo = nil;
    self.currentReplayInfo = nil;
    self.commentStr = @"";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didDeleteDynamicCommentFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    self.currentSelectInfo = nil;
    self.currentReplayInfo = nil;
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
