//
//  StoreViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import "StoreViewController.h"
#import "HomeViewController.h"
#import "StoreSecondViewController.h"

#import "HomeSearchCollectionViewCell.h"
#define kHomeSearchCollectionViewCell @"HomeSearchCollectionViewCell"
#import "HomeBannerCollectionViewCell.h"
#define kHomeBannerCollectionViewCell @"HomeBannerCollectionViewCell"
#import "HomeCategoryCollectionViewCell.h"
#define kHomeCategoryCollectionViewCell @"HomeCategoryCollectionViewCell"
#import "HomeOpenVIPCollectionViewCell.h"
#define kHomeOpenVIPCollectionViewCell @"HomeOpenVIPCollectionViewCell"
#import "CommodityCollectionViewCell.h"
#define kCommodityCollectionViewCell @"CommodityCollectionViewCell"
#import "HomeTitleCollectionReusableView.h"
#define kHomeTitleCollectionReusableView @"HomeTitleCollectionReusableView"
#import "ScanSuccessJumpVC.h"
#import "CommodityDetailViewController.h"
#import "OrderListViewController.h"

@interface StoreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UserModule_LeadtypeProtocol,UICollectionViewDelegateFlowLayout,UserModule_SecondCategoryProtocol,UserModule_GiftList>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * categoryArray;

@property (nonatomic, strong)NSString * keyword;
@property (nonatomic, assign)int page;

@property (nonatomic, strong)HomeSearchCollectionViewCell * searchCell;

@end

@implementation StoreViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    self.keyword = @"";
    self.page = 1;
    [self loadData];
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryClick:) name:kNotificationOfStoreMainAction object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createOrderSuccedsss:) name:kNotificationOfCreateOrderSuccess object:nil];

}

//- (void)createOrderSuccedsss:(NSNotification *)notification
//{
//    OrderListViewController * vc = [[OrderListViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc  animated:YES];
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"商城首页";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    if (self.fromType != FromType_nomal) {
        self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
        TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
        [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
    }
}

- (void)backAction:(UIButton *)button
{
    if (self.fromType == FromType_present) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    [SVProgressHUD show];
    self.page = 1;
    [[UserManager sharedManager] getSecondCategoryeWith:@{kUrlName:@"api/shop/good/categories"} withNotifiedObject:self];
    [[UserManager sharedManager] didRequestGiftListWithInfo:@{kUrlName:@"api/shop/good/lists",@"cate_id":@0,@"keyword":self.keyword,@"page":@(self.page)} withNotifiedObject:self];
}

- (void)prepareUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight- kNavigationBarHeight - kStatusBarHeight - kTabBarHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[HomeSearchCollectionViewCell class] forCellWithReuseIdentifier:kHomeSearchCollectionViewCell];
    [self.collectionView registerClass:[HomeBannerCollectionViewCell class] forCellWithReuseIdentifier:kHomeBannerCollectionViewCell];
    [self.collectionView registerClass:[HomeCategoryCollectionViewCell class] forCellWithReuseIdentifier:kHomeCategoryCollectionViewCell];
    [self.collectionView registerClass:[HomeOpenVIPCollectionViewCell class] forCellWithReuseIdentifier:kHomeOpenVIPCollectionViewCell];
    [self.collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    [self.collectionView registerClass:[HomeTitleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeTitleCollectionReusableView];
    [self.collectionView registerClass:[CommodityCollectionViewCell class] forCellWithReuseIdentifier:kCommodityCollectionViewCell];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 4) {
        return self.dataArray.count;
    }
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    switch (indexPath.section) {
        case 0:
        {
            HomeSearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeSearchCollectionViewCell forIndexPath:indexPath];
            [cell refreshUIWithData:@{@"keyword":self.keyword}];
            cell.searchBlock = ^(NSString * _Nonnull key) {
                if (key.length == 0) {
                    weakSelf.keyword = @"";
                }else
                {
                    weakSelf.keyword = key;
                }
                [weakSelf loadData];
            };
            self.searchCell = cell;
            return cell;
        }
            break;
        case 1:
        {
            HomeBannerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeBannerCollectionViewCell forIndexPath:indexPath];
            NSMutableArray * imageUrlArray = [NSMutableArray array];
            NSArray * bannerInfos = self.categoryArray;
            for (NSDictionary * bannerInfo in bannerInfos) {
                if ([UIUtility judgeStr:[bannerInfo objectForKey:@"thumb"]]) {
                    [imageUrlArray addObject:[bannerInfo objectForKey:@"thumb"]];
                }
            }
            cell.bannerImgUrlArray = imageUrlArray;
            [cell resetCornerRadius:10];
            [cell resetSubviews];
            cell.bannerClickBlock = ^(NSDictionary * _Nonnull info) {
                [weakSelf operationInfo:[bannerInfos objectAtIndex:[[info objectForKey:@"index"] intValue]]];
            };
            
            return cell;
        }
            break;
        case 2:
        {
            NSArray * navbars = self.categoryArray;
            HomeCategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCategoryCollectionViewCell forIndexPath:indexPath];
            cell.pageType = Page_Store_main;
            [cell resetWithCategoryInfos:navbars];
            return cell;
        }
            break;
        case 3:
        {
            HomeOpenVIPCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeOpenVIPCollectionViewCell forIndexPath:indexPath];
            [cell resetUIWithInfo:@{}];
            return cell;
        }
            break;
            
        default:
        {
            CommodityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommodityCollectionViewCell forIndexPath:indexPath];
            
            NSArray * dataArray = self.dataArray;
            [cell refreshUIWith:[dataArray objectAtIndex:indexPath.row] andItem:indexPath.item];
            
            return cell;
        }
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchCell resignFirstResponder];
    if (indexPath.section == 4) {
        CommodityDetailViewController * vc = [[CommodityDetailViewController alloc]init];
        vc.info = self.dataArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        HomeTitleCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeTitleCollectionReusableView forIndexPath:indexPath];
        
        [headview resetUIWithInfo:@{@"title":@"推荐商品"}];
        
        __weak typeof(self)weakSelf= self;
        headview.moreBlock = ^(NSDictionary * _Nonnull info) {
            [weakSelf operationInfo:@{@"id":@0}];
        };
        reusableview = headview;
    }else if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionViewCell *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot" forIndexPath:indexPath];
        
        [footview.contentView removeAllSubviews];
        UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, footview.hd_width, footview.hd_height)];
        contentView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [footview.contentView addSubview:contentView];
        reusableview = footview;
    }
    return reusableview;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return CGSizeMake(collectionView.hd_width, 75);
        }
            break;
        case 1:
        {
            return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) * 0.45);
        }
            break;
        case 2:
        {
            NSArray * navbars = self.categoryArray;
            int count = navbars.count / 4 + 1;
            return CGSizeMake(collectionView.hd_width, (count) * 90 + 20);
        }
            break;
        case 3:
        {
            return CGSizeMake(collectionView.hd_width, 60);
        }
            break;
            
        default:
            return CGSizeMake(collectionView.hd_width / 2 - 5 , collectionView.hd_width / 2 - 5 - 22.5 + 70);
            break;
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        
        return CGSizeMake(collectionView.hd_width, 65);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return CGSizeMake(collectionView.hd_width, 1);
    }
    
    return CGSizeZero;
}

- (HomeCellType)getHomeCellType:(NSDictionary *)info
{
    NSString * type = [info objectForKey:@"type"];
    if ([type isEqualToString:@"search"]) {
        return HomeCellType_search;
    }else if ([type isEqualToString:@"banner"])
    {
        return HomeCellType_banner;
    }
    else if ([type isEqualToString:@"s_art"])
    {
        return HomeCellType_JustaposeType;
    }
    else if ([type isEqualToString:@"adver"])
    {
        return HomeCellType_adver;
    }
    else if ([type isEqualToString:@"navbars"])
    {
        return HomeCellType_category;
    }
    else if ([type isEqualToString:@"attention"])
    {
        return HomeCellType_PublicNumber;
    }
    else if ([type isEqualToString:@"oneCourse"])
    {
        NSString * cut = [info objectForKey:@"cut"];
        if ([cut isEqualToString:@"art"]) {
            return HomeCellType_ListType;
        }else if ([cut isEqualToString:@"s_art"])
        {
            return  HomeCellType_JustaposeType;
        }else if ([cut isEqualToString:@"topic"])
        {
            return HomeCellType_BigImageType;
        }else
        {
            return HomeCellType_BigImageNoTeacherType;
        }
    }
    else if ([type isEqualToString:@"series"])
    {
        return HomeCellType_BigImageNoTeacherType;
    }
    else if ([type isEqualToString:@"topic"])
    {
        return HomeCellType_BigImageType;
    }
    else if ([type isEqualToString:@"art"])
    {
        return HomeCellType_ListType;
    }
    else if ([type isEqualToString:@"teacher"])
    {
        return HomeCellType_TeacherList;
    }
    else if ([type isEqualToString:@"vipCard"])
    {
        return HomeCellType_VipCard;
    }
    else if ([type isEqualToString:@"vip"])
    {
        return HomeCellType_openVIP;
    }
    else if ([type isEqualToString:@"community"])
    {
        return HomeCellType_Community;
    }
    
    return HomeCellType_search;
}


- (void)categoryClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    
    [self operationInfo:infoDic];
}

- (void)operationInfo:(NSDictionary *)info
{
    NSLog(@"info = %@", info);
    StoreSecondViewController * vc = [[StoreSecondViewController alloc]init];
    vc.cate_id = [[info objectForKey:@"id"] intValue];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSecondCategorySuccessed
{
    [SVProgressHUD dismiss];
    [self.categoryArray removeAllObjects];
    
    NSMutableArray * array = [[[UserManager sharedManager] getSecondCategoryeArray] mutableCopy];
    for (NSDictionary * info in array) {
//        img_url
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
        if ([info objectForKey:@"thumb"]) {
            [mInfo setObject:[info objectForKey:@"thumb"] forKey:@"img_url"];
            [self.categoryArray addObject:mInfo];
        }
    }
    [self.collectionView reloadData];
    
}

- (void)didSecondCategoryFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestGiftListSuccessed
{
    [SVProgressHUD dismiss];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    NSArray * array = [[UserManager sharedManager] getGiftList];
    if (array.count <= 0) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.page == 1) {
        [self.dataArray removeAllObjects];
    }
    for (NSDictionary * info in array) {
        [self.dataArray addObject:info];
    }
    [self.collectionView reloadData];
    
}

- (void)didRequestGiftListFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
