//
//  JoinAssociationViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "AssociationDetailViewController.h"
#import "JoinAssociationHeadTableViewCell.h"
#define kJoinAssociationHeadTableViewCell @"JoinAssociationHeadTableViewCell"
#import "AssociationCommentTableViewCell.h"
#define kAssociationCommentTableViewCell @"AssociationCommentTableViewCell"
#import "AssociationCommentDetailViewController.h"
#import "AssociationCenterViewController.h"
#import "DeleteAssociationDynamicView.h"
#import "AssociationPublishCommentViewController.h"

typedef enum : NSUInteger {
    DynamicOperationType_none,
    DynamicOperationType_zan,
    DynamicOperationType_delete,
    DynamicOperationType_comment,
    DynamicOperationType_jingpin,
} DynamicOperationType;

@interface AssociationDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_AssociationDynamic,UserModule_AssociationDetail,UserModule_CommentZanProtocol,UserModule_deleteDynamic,UserModule_jingpinDynamic>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, assign)int page;
@property (nonatomic, assign)int pagesize;
@property (nonatomic, strong) NSMutableArray *pageIndexArray;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;

@property (nonatomic, strong)ZWMSegmentView * courseSegment;
@property (nonatomic, strong)NSDictionary * associationInfo;

@property (nonatomic, strong)NSDictionary * currentSelectDynamicInfo;

@property (nonatomic, assign)DynamicOperationType dynamicOperationType;

@property (nonatomic, strong)UIButton * pubishDynamicBtn;
@end

@implementation AssociationDetailViewController
- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSMutableArray *)pageIndexArray
{
    if (!_pageIndexArray) {
        _pageIndexArray = [NSMutableArray array];
    }
    return _pageIndexArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetcategoryArray];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self navigationViewSetup];
    [self prepareUI];
    [self requestDataWith:0];
    [[UserManager sharedManager] getAssociationDetailWith:@{kUrlName:@"api/community/detail",@"c_id":[self.infoDic objectForKey:@"id"],kRequestType:@"get",@"include":@"c_name,share,admin_info"} withNotifiedObject:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = [self.infoDic objectForKey:@"title"];
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView registerClass:[JoinAssociationHeadTableViewCell class] forCellReuseIdentifier:kJoinAssociationHeadTableViewCell];
    [self.tableView registerClass:[AssociationCommentTableViewCell class] forCellReuseIdentifier:kAssociationCommentTableViewCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
    [self.tableView registerClass:[LoadFailedTableViewCell class] forCellReuseIdentifier:kFailedCellID];
    self.pubishDynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _pubishDynamicBtn.frame = CGRectMake(kScreenWidth - 80, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 120, 60, 60 * 408 / 368);
    [_pubishDynamicBtn setImage:[UIImage imageNamed:@"dynamic_编辑"] forState:UIControlStateNormal];
    [self.view addSubview:_pubishDynamicBtn];
    [_pubishDynamicBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)resetcategoryArray
{
    // 重置数据信息
    [self.pageIndexArray removeAllObjects];
    for (int i = 0; i< 3; i++) {
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setObject:@"1" forKey:kPageNo];
        [info setObject:@"10" forKey:kPageSize];
        [info setObject:[NSMutableArray array] forKey:kDataArray];
        
        [self.pageIndexArray addObject:info];
    }
}

- (void)doResetQuestionRequest
{
    NSUInteger index = self.courseSegment.index;
    NSMutableDictionary * info = [self.pageIndexArray objectAtIndex:index];
    [info setObject:@1 forKey:kPageNo];
    [self.pageIndexArray replaceObjectAtIndex:index withObject:info];
    self.page = [[info objectForKey:kPageNo] intValue];
    
    [self requestDataWith:self.courseSegment.index];
    
    [[UserManager sharedManager] getAssociationDetailWith:@{kUrlName:@"api/community/detail",@"c_id":[self.infoDic objectForKey:@"id"],kRequestType:@"get",@"include":@"c_name,share,admin_info"} withNotifiedObject:self];
}

- (void)doNextPageQuestionRequest
{
    NSUInteger index = self.courseSegment.index;
    NSMutableDictionary * info = [self.pageIndexArray objectAtIndex:index];
    int page = [[info objectForKey:kPageNo] intValue];
    page++;
    [info setObject:@(page) forKey:kPageNo];
    [self.pageIndexArray replaceObjectAtIndex:index withObject:info];
    self.page = [[info objectForKey:kPageNo] intValue];
    
   [self requestDataWith:self.courseSegment.index];
}

#pragma mark - request
- (void)requestDataWith:(NSUInteger )index
{
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
//    self.itemArray = mArray;
    
    NSString * is_status = @"";
    NSString * is_show = @"";
    if (index == 1) {
        is_show = @"2";// 精选
    }else if (index == 2)
    {
        is_status = @"2";// 群主
    }
    else
    {
        // 全部
    }
    
    [SVProgressHUD show];
    [[UserManager sharedManager] getAssociationDynamicWith:@{kUrlName:@"api/community/communitydynamic",@"c_id":[self.infoDic objectForKey:@"id"],kRequestType:@"get",@"is_status":is_status,@"is_show":is_show,@"pindex":@(pageNo)} withNotifiedObject:self];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.itemArray.count == 0 ? 1 : self.itemArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 1) {
        
        if (self.itemArray.count == 0) {
            LoadFailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFailedCellID forIndexPath:indexPath];
            [cell refreshUIWith:@{}];
            
            return cell;
        }
        
        AssociationCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationCommentTableViewCell forIndexPath:indexPath];
        [cell refreshUIWith:self.itemArray[indexPath.row] andIsCanOperation:YES];
        
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect = [cell convertRect:cell.bounds toView:window];
        cell.imageClickBlock = ^(NSArray * _Nonnull urlArray, int index) {
            TestImageView *showView = [[TestImageView alloc] initWithFrame:weakSelf.view.frame andImageList:urlArray andCurrentIndex:index];
            showView.outsideFrame = rect;
            showView.insideFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [showView show];
        };
        
        cell.deleteBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf deleteComment:info];
        };
        cell.zanBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf zanComment:info];
        };
        cell.commentBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf checkComment:info];
        };
        
        return cell;
    }
    
    JoinAssociationHeadTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kJoinAssociationHeadTableViewCell forIndexPath:indexPath];
    [titleCell resetDetailCellContent:self.associationInfo];
    titleCell.centerBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf centerAction:weakSelf.associationInfo];
    };
    titleCell.storeBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    self.courseSegment = titleCell.zixunSegment;
    
    [self.courseSegment  selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
        NSDictionary * pageNoInfo = [weakSelf.pageIndexArray objectAtIndex:index];
        int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
        NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
        weakSelf.itemArray = mArray;
        
        if (mArray.count == 0 || pageNo > 1) {
            [weakSelf requestDataWith:index];
        }else
        {
            [weakSelf.tableView reloadData];
        }
    }];
    
    return titleCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (self.itemArray.count == 0) {
            return tableView.hd_height - 210;
        }
        
        NSDictionary * info = self.itemArray[indexPath.row];
        NSString * contentStr = [info objectForKey:@"content"];
        CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
        
//        NSString * htmlString = [UIUtility judgeStr:[info objectForKey:@"content"]];
//        htmlString = [htmlString gtm_stringByUnescapingFromHTML];
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        CGFloat height = [attrStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        
        
        int imageCount = [[info objectForKey:@"c_imgs"] count] % 3 == 0 ? [[info objectForKey:@"c_imgs"] count] / 3 : [[info objectForKey:@"c_imgs"] count] / 3 + 1;
        CGFloat imageHeight = (kCellHeightOfCategoryView + 5) * imageCount;
        
        return 15 + 30 + 10 + height + 5 + imageHeight + 35 + 15;
    }
    
    return 210 + 54;
}

#pragma mark - operation
- (void)centerAction:(NSDictionary *)info
{
    if (info == nil) {
        return;
    }
    AssociationCenterViewController * vc = [[AssociationCenterViewController alloc]init];
    vc.infoDic = [[NSMutableDictionary alloc]initWithDictionary:info];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteComment:(NSDictionary *)info
{
    NSLog(@"delete");
    self.currentSelectDynamicInfo = info ;
    DeleteAssociationDynamicView * view = [[DeleteAssociationDynamicView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andInfo:info];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:view];
    __weak typeof(self)weakSelf = self;
    view.deleteBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf deleteDynamic];
    };
    view.jingpinBlock = ^(NSDictionary * _Nonnull info) {
        weakSelf.dynamicOperationType = DynamicOperationType_jingpin;
        [weakSelf jingpinDynamic];
    };
   
}

#pragma mark - jingpinDynamic
- (void)jingpinDynamic
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getjingpinDynamicWith:@{kUrlName:@"api/community/dynamicchangeisshow",@"c_id":[self.infoDic objectForKey:@"id"],@"d_id":[self.currentSelectDynamicInfo objectForKey:@"id"],kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didjingpinDynamicSuccessed
{
    [SVProgressHUD dismiss];
    [self requestDataWith:self.courseSegment.index];
}

- (void)didjingpinDynamicFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    self.currentSelectDynamicInfo = nil;
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - deleteDynamic
- (void)deleteDynamic
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getdeleteDynamicWith:@{kUrlName:@"api/community/dynamicdelete",@"c_id":[self.infoDic objectForKey:@"id"],@"d_id":[self.currentSelectDynamicInfo objectForKey:@"id"],kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didDeleteDynamicSuccessed
{
    [SVProgressHUD dismiss];
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:self.courseSegment.index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    [mArray removeObject:self.currentSelectDynamicInfo];
    self.currentSelectDynamicInfo = nil;
    self.itemArray = mArray;
    [self.tableView reloadData];
}

- (void)didDeleteDynamicFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    self.currentSelectDynamicInfo = nil;
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - zan Dynamic
- (void)zanComment:(NSDictionary *)info
{
    self.currentSelectDynamicInfo = info;
    self.dynamicOperationType = DynamicOperationType_zan;
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestCommentZantWithCourseInfo:@{kUrlName:@"api/community/dynamicclickzan",@"c_id":[self.infoDic objectForKey:@"id"],@"d_id":[info objectForKey:@"id"],kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didRequestCommentZanSuccessed
{
    [SVProgressHUD dismiss];
    [self requestDataWith:self.courseSegment.index];
}

- (void)didRequestCommentZanFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    self.currentSelectDynamicInfo = nil;
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)checkComment:(NSDictionary *)info
{
    __weak typeof(self)weakSelf = self;
    self.currentSelectDynamicInfo = info;
    self.dynamicOperationType = DynamicOperationType_zan;
    AssociationCommentDetailViewController * vc = [[AssociationCommentDetailViewController alloc]init];
    vc.infoDic = info;
    vc.associationInfo = self.associationInfo;
    vc.commentBlock = ^(NSDictionary * _Nonnull info) {
        weakSelf.dynamicOperationType = DynamicOperationType_comment;
        weakSelf.currentSelectDynamicInfo = info;
        [weakSelf requestDataWith:weakSelf.courseSegment.index];
    };
    
    vc.deleteBlock = ^(NSDictionary * _Nonnull info) {
        weakSelf.currentSelectDynamicInfo = info;
        NSDictionary * pageNoInfo = [weakSelf.pageIndexArray objectAtIndex:self.courseSegment.index];
        int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
        NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
        [mArray removeObject:weakSelf.currentSelectDynamicInfo];
        weakSelf.currentSelectDynamicInfo = nil;
        weakSelf.itemArray = mArray;
        [weakSelf.tableView reloadData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - share
- (void)shareAction
{
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:YES];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
    self.payView = payView;
}

- (void)payClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [self.payView removeFromSuperview];
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_shareFriend)
    {
        
        NSDictionary * shareInfo = self.shareInfo;
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
        NSDictionary * shareInfo = self.shareInfo;
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


#pragma mark - get 动态 success
- (void)didAssociationDynamicSuccessed
{
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD dismiss];
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:self.courseSegment.index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    
    
    
    if (self.dynamicOperationType != DynamicOperationType_none) {
        if (self.currentSelectDynamicInfo) {
            
            NSInteger index = [mArray indexOfObject:self.currentSelectDynamicInfo];
            
            switch (self.dynamicOperationType) {
                case DynamicOperationType_zan:
                case DynamicOperationType_comment:
                case DynamicOperationType_jingpin:
                {
                    NSArray * list = [[UserManager sharedManager] getAssociationDynamicList];
                    NSDictionary * newInfo;
                    for (NSDictionary * info in list) {
                        if ([[info objectForKey:@"id"] isEqual:[self.currentSelectDynamicInfo objectForKey:@"id"]]) {
                            newInfo = info;
                        }
                    }
                        
                    if (newInfo) {
                        [mArray replaceObjectAtIndex:index withObject:newInfo];
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
            self.currentSelectDynamicInfo = nil;
            self.dynamicOperationType = DynamicOperationType_none;
            self.itemArray = mArray;
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            
            return;
        }
        self.dynamicOperationType = DynamicOperationType_none;
    }
    
    
    
    if(pageNo == 1)
    {
        [mArray removeAllObjects];
    }
    for (NSDictionary * info in [[UserManager sharedManager] getAssociationDynamicList]) {
        [mArray addObject:info];
    }
    
    if ([[[UserManager sharedManager] getAssociationDynamicList] count] == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
        NSUInteger index = self.courseSegment.index;
        NSMutableDictionary * info = [self.pageIndexArray objectAtIndex:index];
        int page = [[info objectForKey:kPageNo] intValue];
        if (page > 1) {
            page--;
        }
        [info setObject:@(page) forKey:kPageNo];
        [self.pageIndexArray replaceObjectAtIndex:index withObject:info];
        
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    self.itemArray = mArray;
    
    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didAssociationDynamicFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didAssociationDetailSuccessed
{
    [SVProgressHUD dismiss];
    self.associationInfo = [[UserManager sharedManager] getAssociationDetailInfo];
    
    if ([[self.associationInfo objectForKey:@"is_admin"] boolValue]) {
        [UserManager sharedManager].is_admin = YES;
    }else
    {
        [UserManager sharedManager].is_admin = NO;
    }
    
    [self.tableView reloadData];
}

- (void)didAssociationDetailFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [UserManager sharedManager].is_admin = NO;
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)publishAction{
    __weak typeof(self)weakSelf = self;
    AssociationPublishCommentViewController * vc = [[AssociationPublishCommentViewController alloc]init];
    vc.info = self.infoDic;
    [self.navigationController pushViewController:vc animated:YES];
    vc.publishBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf doResetQuestionRequest];
    };
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
