//
//  JoinAssociationViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "JoinAssociationViewController.h"
#import "JoinAssociationHeadTableViewCell.h"
#define kJoinAssociationHeadTableViewCell @"JoinAssociationHeadTableViewCell"
#import "AssociationCommentTableViewCell.h"
#define kAssociationCommentTableViewCell @"AssociationCommentTableViewCell"

@interface JoinAssociationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong)ShareAndPaySelectView * payView;
@property (nonatomic, strong)UIImageView * shareImageView;
@property (nonatomic, strong)NSDictionary * shareInfo;

@end

@implementation JoinAssociationViewController
- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self navigationViewSetup];
    [self prepareUI];
    
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView registerClass:[JoinAssociationHeadTableViewCell class] forCellReuseIdentifier:kJoinAssociationHeadTableViewCell];
    [self.tableView registerClass:[AssociationCommentTableViewCell class] forCellReuseIdentifier:kAssociationCommentTableViewCell];

//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50, kScreenHeight, 50)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:bottomView];
    
    UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame = CGRectMake(40, 5, kScreenWidth - 80, 40);
    joinBtn.layer.cornerRadius = 5;
    joinBtn.layer.masksToBounds = YES;
    joinBtn.backgroundColor = kCommonMainBlueColor;
    [joinBtn setTitle:@"进入社群" forState:UIControlStateNormal];
    [joinBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    joinBtn.titleLabel.font = kMainFont;
    [bottomView addSubview:joinBtn];
}

- (void)loadData
{
    NSArray * imageArray = @[@"https://qiniu.luezhi.com/4263_70cd3_1597216334.png?imageslim",@"https://qiniu.luezhi.com/4263_70cd3_1597216334.png?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim",@"https://qiniu.luezhi.com/4263_c85e3_1601364131.jpg?imageslim",@"https://qiniu.luezhi.com/4263_c85e3_1601364131.jpg?imageslim", @"https://qiniu.luezhi.com/4263_c85e3_1601364131.jpg?imageslim",@"https://qiniu.luezhi.com/4263_8e29b_1601364117.jpg?imageslim",@"https://qiniu.luezhi.com/16003086956071600308695604-0.png?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim"];
    
    NSArray * imageArray1 = @[@"https://qiniu.luezhi.com/4263_8e29b_1601364117.jpg?imageslim",@"https://qiniu.luezhi.com/16003086956071600308695604-0.png?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim"];
    
    NSArray * imageArray2 = @[@"https://qiniu.luezhi.com/4263_70cd3_1597216334.png?imageslim",@"https://qiniu.luezhi.com/4263_70cd3_1597216334.png?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim",@"https://qiniu.luezhi.com/4263_c85e3_1601364131.jpg?imageslim",@"https://qiniu.luezhi.com/4263_c85e3_1601364131.jpg?imageslim",@"https://qiniu.luezhi.com/4263_3cf32_1600486365.png?imageslim"];
    
    NSDictionary * info = @{@"avatar":@"https://thirdwx.qlogo.cn/mmopen/vi_32/8Yibib2TosQHtccDAzEJobxoftcVujXyWhqVt0Hauz9pEhFIQ9x3euhhTLwPrVnYAGPOQ3s3jmCQVF6RPLv2rQyA/132",@"name":@"梁朝伟",@"images":imageArray,@"time":@"2020-10-28 12:12:89", @"content":@"还记得你覅U盾百日uehrjvnlknlrglermogpijeropigjerpig浦东人家公婆kg破开工；都没人工破没人"};
    
    NSDictionary * info1 = @{@"avatar":@"https://thirdwx.qlogo.cn/mmopen/vi_32/8Yibib2TosQHtccDAzEJobxoftcVujXyWhqVt0Hauz9pEhFIQ9x3euhhTLwPrVnYAGPOQ3s3jmCQVF6RPLv2rQyA/132",@"name":@"梁朝伟",@"images":@[],@"time":@"2020-10-28 12:12:89", @"content":@"还记得你覅U盾百日uehrjvnlknlrglermogpijeropigjerpig浦东人家公婆kg破开工；都没人工破没人"};
    
    NSDictionary * info2 = @{@"avatar":@"https://thirdwx.qlogo.cn/mmopen/vi_32/8Yibib2TosQHtccDAzEJobxoftcVujXyWhqVt0Hauz9pEhFIQ9x3euhhTLwPrVnYAGPOQ3s3jmCQVF6RPLv2rQyA/132",@"name":@"梁朝伟",@"images":imageArray1,@"time":@"2020-10-28 12:12:89", @"content":@"还记得你覅U盾百日uehrjvnlknlrglermogpijeropigjerpig浦东人家公婆kg破开工；都没人工破没人"};
    
    NSDictionary * info3 = @{@"avatar":@"https://thirdwx.qlogo.cn/mmopen/vi_32/8Yibib2TosQHtccDAzEJobxoftcVujXyWhqVt0Hauz9pEhFIQ9x3euhhTLwPrVnYAGPOQ3s3jmCQVF6RPLv2rQyA/132",@"name":@"梁朝伟",@"images":imageArray2,@"time":@"2020-10-28 12:12:89", @"content":@"还记得"};
    
    [self.itemArray addObject:info];
    [self.itemArray addObject:info1];
    [self.itemArray addObject:info2];
    [self.itemArray addObject:info3];
    
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 1) {
        AssociationCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationCommentTableViewCell forIndexPath:indexPath];
        [cell refreshUIWith:self.itemArray[indexPath.row] andIsCanOperation:NO];
        return cell;
    }
    
    JoinAssociationHeadTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kJoinAssociationHeadTableViewCell forIndexPath:indexPath];
    [titleCell resetCellContent:self.infoDic];
    titleCell.activeBlock = ^{
        [weakSelf shareAction];
    };
    return titleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSDictionary * info = self.itemArray[indexPath.row];
        NSString * contentStr = [info objectForKey:@"content"];
        CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(tableView.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
        
        int imageCount = [[info objectForKey:@"images"] count] % 3 == 0 ? [[info objectForKey:@"images"] count] / 3 : [[info objectForKey:@"images"] count] / 3 + 1;
        CGFloat imageHeight = (kCellHeightOfCategoryView + 5) * imageCount;
        
        
        return 15 + 30 + 10 + height + 5 + imageHeight + 15;
    }
    
    
    return 280;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
