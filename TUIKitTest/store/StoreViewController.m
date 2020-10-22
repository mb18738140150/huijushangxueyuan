//
//  StoreViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import "StoreViewController.h"
#import "HomeViewController.h"

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

@interface StoreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UserModule_LeadtypeProtocol,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSArray * dataArray;

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self loadData];
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryClick:) name:kNotificationOfMainPageCategoryClick object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOfMainPageCategoryClick object:nil];
}

- (void)navigationViewSetup
{
    
    self.navigationItem.title = @"商城首页";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
}

- (void)loadData
{
    [[UserManager sharedManager] getLeadTypeWith:@{kUrlName:@"api/index"} withNotifiedObject:self];
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
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString * type = [[self.dataArray objectAtIndex:section] objectForKey:@"type"];
    
    // search banner navbars vipcard adver teacher oneCourse 只有一个  vipcard adver oneCourse 没有头部
    if ([type isEqualToString:@"search"] || [type isEqualToString:@"banner"] || [type isEqualToString:@"navbars"] || [type isEqualToString:@"vipCard"] || [type isEqualToString:@"adver"] || [type isEqualToString:@"teacher"] || [type isEqualToString:@"oneCourse"] || [type isEqualToString:@"vip"] || [type isEqualToString:@"attention"]  ) {
        return 1;
    }else
    {
        NSArray * dataArray = [[self.dataArray objectAtIndex:section] objectForKey:@"data"];
        return dataArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = [self.dataArray objectAtIndex:indexPath.section];
    NSString * type = [info objectForKey:@"type"];
    __weak typeof(self)weakSelf = self;
    switch ([self getHomeCellType:info]) {
        case HomeCellType_search:
        {
            HomeSearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeSearchCollectionViewCell forIndexPath:indexPath];
            [cell refreshUIWithData:info];
            return cell;
        }
            break;
        case HomeCellType_banner:
        {
            HomeBannerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeBannerCollectionViewCell forIndexPath:indexPath];
            NSMutableArray * imageUrlArray = [NSMutableArray array];
            NSArray * bannerInfos = [info objectForKey:@"data"];
            for (NSDictionary * bannerInfo in [info objectForKey:@"data"]) {
                if ([UIUtility judgeStr:[bannerInfo objectForKey:@"image"]]) {
                    [imageUrlArray addObject:[bannerInfo objectForKey:@"image"]];
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
        case HomeCellType_category:
        {
            NSArray * navbars = [info objectForKey:@"data"];
            HomeCategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCategoryCollectionViewCell forIndexPath:indexPath];
            cell.pageType = PageMain;
            [cell resetWithCategoryInfos:navbars];
            return cell;
        }
            break;
        case HomeCellType_JustaposeType:
        {
        }
        case HomeCellType_BigImageType:// topic
        {
        }
        case HomeCellType_BigImageNoTeacherType: // series
        {
        }
        case HomeCellType_ListType:
        {
            CommodityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommodityCollectionViewCell forIndexPath:indexPath];
            
            NSArray * dataArray = [info objectForKey:@"data"];
            if ([dataArray isKindOfClass:[NSDictionary class]])  {
                cell.isOneCourse = YES;
                [cell refreshUIWith:[info objectForKey:@"data"] andItem:indexPath.item];
            }else
            {
                cell.isOneCourse = NO;
                [cell refreshUIWith:[dataArray objectAtIndex:indexPath.row] andItem:indexPath.item];
            }
            
            return cell;
        }
            break;
        case HomeCellType_openVIP:
        {
            HomeOpenVIPCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeOpenVIPCollectionViewCell forIndexPath:indexPath];
            [cell resetUIWithInfo:info];
            return cell;
        }
            break;
        default:
            break;
    }
    
    HomeSearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeSearchCollectionViewCell forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = [self.dataArray objectAtIndex:indexPath.section];
    NSString * type = [info objectForKey:@"type"];
    switch ([self getHomeCellType:info]) {
        case HomeCellType_openVIP:
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
            break;
        
        default:
            break;
    }
    CommodityDetailViewController * vc = [[CommodityDetailViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        HomeTitleCollectionReusableView *headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeTitleCollectionReusableView forIndexPath:indexPath];
        
        [headview resetUIWithInfo:self.dataArray[indexPath.section]];
        
        __weak typeof(self)weakSelf= self;
        headview.moreBlock = ^(NSDictionary * _Nonnull info) {
            NSString * type = [info objectForKey:@"type"];
            if ([type isEqualToString:@"topic"] || [type isEqualToString:@"series"]) {
                
            }
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
    NSDictionary * info = [self.dataArray objectAtIndex:indexPath.section];
    NSString * type = [info objectForKey:@"type"];
    switch ([self getHomeCellType:info]) {
        case HomeCellType_search:
            return CGSizeMake(collectionView.hd_width, 75);
            break;
        case HomeCellType_banner:
            return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) * 0.45);
            break;
        case HomeCellType_category:
        {
            NSArray * navbars = [info objectForKey:@"data"];
            int count = navbars.count / 4 + 1;
            return CGSizeMake(collectionView.hd_width, (count) * 90 + 20);
        }
            break;
        case HomeCellType_openVIP:
            return CGSizeMake(collectionView.hd_width, 60);
            break;
        case HomeCellType_JustaposeType: // type 为onCourse 高度加20
        case HomeCellType_BigImageType: // type 为onCourse 高度加20
        case HomeCellType_BigImageNoTeacherType: // type 为onCourse 高度加20
        case HomeCellType_ListType: // type 为onCourse 高度加20
            return CGSizeMake(collectionView.hd_width / 2 - 5 , collectionView.hd_width / 2 - 5 - 22.5 + 70);
            break;
        default:
            break;
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSDictionary * info = self.dataArray[section];
    NSString * type = [info objectForKey:@"type"];
    if ([type isEqualToString:@"search"] || [type isEqualToString:@"banner"] || [type isEqualToString:@"navbars"] || [type isEqualToString:@"vipCard"] || [type isEqualToString:@"adver"] || [type isEqualToString:@"oneCourse"]|| [type isEqualToString:@"vip"]) {
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.hd_width, 65);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    NSDictionary * info = self.dataArray[section];
    NSString * type = [info objectForKey:@"type"];
    if ([type isEqualToString:@"search"] || [type isEqualToString:@"banner"] || [type isEqualToString:@"navbars"]) {
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.hd_width, 1);
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

- (void)didLeadtypeSuccessed
{
    self.dataArray = [[UserManager sharedManager] getLeadTypeArray];
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
}

- (void)didLeadtypeFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.collectionView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)categoryClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    
    [self operationInfo:infoDic];
}

- (void)operationInfo:(NSDictionary *)info
{
    NSLog(@"info = %@", info);
    NSString * url_type = [info objectForKey:@"url_type"];
    if ([url_type isEqualToString:@"none"]) {
        
    }else if ([url_type isEqualToString:@"inner"])
    {
        NSString * innerType = [UIUtility judgeStr:[info objectForKey:@"url"]];
        /*
         index    首页
         center    个人中心
         yd_payred_index    图文音视频
         ask_expert    问答
         zb_topics    直播
         yx_activiy    优惠券
         zb_series    直播专栏
         yd_serialize    普通专栏
         saas_bargain    砍价
         vip_introduce    会员
         shop_index    商城
         mypay    我的已购
         yx_extension_recruit    推广中心
         yd_detail    图文音视频详情
         
         */
        if ([innerType isEqualToString:@"index"]) {
            NSLog(@"首页");
        }else if ([innerType isEqualToString:@"center"])
        {
            NSLog(@"个人中心");
        }
        
        
    }else
    {
        // 跳转外部链接
        ScanSuccessJumpVC * WebVC = [[ScanSuccessJumpVC alloc]init];
        WebVC.comeFromVC = ScanSuccessJumpComeFromWB;
        WebVC.jump_URL = [UIUtility judgeStr:[info objectForKey:@"url"]];
        WebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:WebVC animated:YES];
    }
    
    
}



@end
