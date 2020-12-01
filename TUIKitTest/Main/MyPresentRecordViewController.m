//
//  SecongListViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "MyPresentRecordViewController.h"
#import "MyPresentRecordTableViewCell.h"
#define kMyPresentRecordTableViewCell @"MyPresentRecordTableViewCell"

#import "SearchAndCategoryView.h"
#import "ZWMSegmentView.h"
#define kDataArray @"dataArray"
#import "LivingCourseDetailViewController.h"
#import "PresentDetailViewController.h"

@interface MyPresentRecordViewController()<UITableViewDelegate, UITableViewDataSource,UserModule_SecondCategoryProtocol,UserModule_CategoryCourseProtocol>
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int pagesize;

@property (nonatomic, strong)ZWMSegmentView * courseSegment;

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *pageIndexArray;
@property (nonatomic, strong)SearchAndCategoryView * topView;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;
@end

@implementation MyPresentRecordViewController

- (NSMutableArray *)pageIndexArray
{
    if (!_pageIndexArray) {
        _pageIndexArray = [NSMutableArray array];
    }
    return _pageIndexArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationViewSetup];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"赠送记录";
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
    self.categoryArray = @[@{@"id":@0,@"name":@"未赠送"},@{@"id":@1,@"name":@"已赠送"}];
    
    
    for (int i = 0; i< self.categoryArray.count; i++) {
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setObject:@"1" forKey:kPageNo];
        [info setObject:@"10" forKey:kPageSize];
        [info setObject:[NSMutableArray array] forKey:kDataArray];
        
        [self.pageIndexArray addObject:info];
    }
    
    self.topView = [[SearchAndCategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [self.view addSubview:self.topView];
    [self.topView refreshWith:self.categoryArray];
    [self.topView hideSearchView];
    [self.topView hideSeparateView];
    self.courseSegment = self.topView.zixunSegment;
    [self requestDataWith:0];
    __weak typeof(self)weakSelf = self;
    [self.courseSegment selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
        NSLog(@"%ld *** %@", index,button.titleLabel.text);
           
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MyPresentRecordTableViewCell class] forCellReuseIdentifier:kMyPresentRecordTableViewCell];
    [self.tableView registerClass:[LoadFailedTableViewCell class] forCellReuseIdentifier:kFailedCellID];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    [self.tableView reloadData];
}

- (void)doResetQuestionRequest
{
    NSUInteger index = self.courseSegment.index;
    NSMutableDictionary * info = [self.pageIndexArray objectAtIndex:index];
    [info setObject:@1 forKey:kPageNo];
    [self.pageIndexArray replaceObjectAtIndex:index withObject:info];
    self.page = [[info objectForKey:kPageNo] intValue];
    
    [self requestDataWith:self.courseSegment.index];
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
    NSDictionary * cateInfo = [self.categoryArray objectAtIndex:index];
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:index];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    self.itemArray = mArray;
    
    NSString * type = @"";
    if (index == 0) {
        type = @"no";
    }else
    {
        type = @"yes";
    }
    
    // ,@"debug":@"kingofzihua",@"author_id":@"1475865"
    [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:@"api/user/giveRecord",@"type":type,@"requestType":@"get"} withNotifiedObject:self];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count == 0 ? 1 : self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemArray.count == 0) {
        LoadFailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFailedCellID forIndexPath:indexPath];
        [cell refreshUIWith:@{}];
        
        return cell;
    }
    __weak typeof(self)weakSelf = self;
    MyPresentRecordTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kMyPresentRecordTableViewCell forIndexPath:indexPath];
    
    [titleCell resetCellContent:self.itemArray[indexPath.row]];
    
    titleCell.presentBlock = ^{
        [weakSelf promotionAction:weakSelf.itemArray[indexPath.row]];
    };
    
    return titleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemArray.count == 0) {
        return tableView.hd_height;
    }
    return 90 + 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemArray.count == 0) {
        return;
    }
    NSDictionary * info = [self.itemArray objectAtIndex:indexPath.row];
}

#pragma mark - request
- (void)didCategoryCourseSuccessed
{
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary * pageNoInfo = [self.pageIndexArray objectAtIndex:self.courseSegment.index];
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    if(pageNo == 1)
    {
        [mArray removeAllObjects];
    }
    for (NSDictionary * info in [[UserManager sharedManager] getCategoryCourseArray]) {
        [mArray addObject:info];
    }
    
    if ([[[UserManager sharedManager] getCategoryCourseArray] count] == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
    self.itemArray = mArray;
    [self.tableView reloadData];
    
}

- (void)didCategoryCourseFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)promotionAction:(NSDictionary *)info
{
    PresentDetailViewController * vc = [[PresentDetailViewController alloc]init];
    vc.info = info;
    [self.navigationController pushViewController:vc animated:YES];
    
//    self.shareInfo = [info objectForKey:@"share"];
//    [self getShareInfo:self.shareInfo];
}

- (void)getShareInfo:(NSDictionary *)info
{
    __weak typeof(self)weakSelf = self;
    NSDictionary * shareInfo = info;
    self.shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 1000, 100, 100)];
    [self.view addSubview:self.shareImageView];
    self.shareImageView.hidden = YES;
//    [SVProgressHUD show];
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[shareInfo objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf shareAction];
        });
        
        [SVProgressHUD dismiss];
        NSLog(@"图片下载成功");
    }];
    
}

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


@end
