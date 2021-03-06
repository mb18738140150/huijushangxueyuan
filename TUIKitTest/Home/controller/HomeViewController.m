//
//  HomeViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeViewController.h"
#import "SecongListViewController.h"
#import "MainVipCardListViewController.h"
#import "VIPCardDetailViewController.h"
#import "ScanSuccessJumpVC.h"
#import "MyBuyCourseViewController.h"
#import "StoreViewController.h"
#import "ArticleDetailViewController.h"
#import "TeacherListViewController.h"
#import "TeacherDetailViewController.h"
#import "LivingCourseDetailViewController.h"
#import "SearchCourseViewController.h"
#import "AssoiciationListViewController.h"
#import "JoinAssociationViewController.h"
#import "MyPromotionViewController.h"

#import "HomeSearchCollectionViewCell.h"
#define kHomeSearchCollectionViewCell @"HomeSearchCollectionViewCell"
#import "HomeBannerCollectionViewCell.h"
#define kHomeBannerCollectionViewCell @"HomeBannerCollectionViewCell"
#import "HomeCategoryCollectionViewCell.h"
#define kHomeCategoryCollectionViewCell @"HomeCategoryCollectionViewCell"
#import "HomeOpenVIPCollectionViewCell.h"
#define kHomeOpenVIPCollectionViewCell @"HomeOpenVIPCollectionViewCell"
#import "HomeTitleCollectionReusableView.h"
#define kHomeTitleCollectionReusableView @"HomeTitleCollectionReusableView"
#import "HomeBigImageTypeCollectionViewCell.h"
#define kHomeBigImageTypeCollectionViewCell @"HomeBigImageTypeCollectionViewCell"
#import "HomeBigImageNoTeacherTypeCollectionViewCell.h"
#define kHomeBigImageNoTeacherTypeCollectionViewCell @"HomeBigImageNoTeacherTypeCollectionViewCell"

#import "HomeJustaposeCollectionViewCell.h"
#define kHomeJustaposeCollectionViewCell @"HomeJustaposeCollectionViewCell"
#import "HomeListTypeCollectionViewCell.h"
#define kHomeListTypeCollectionViewCell @"HomeListTypeCollectionViewCell"

#import "HomeTeacherListCollectionViewCell.h"
#define kHomeTeacherListCollectionViewCell @"HomeTeacherListCollectionViewCell"
#import "HomePublicNumberCollectionViewCell.h"
#define kHomePublicNumberCollectionViewCell @"HomePublicNumberCollectionViewCell"
#import "HomeCommunityCollectionViewCell.h"
#define kHomeCommunityCollectionViewCell @"HomeCommunityCollectionViewCell"
#import "HomeVIPCardCollectionViewCell.h"
#define kHomeVIPCardCollectionViewCell @"HomeVIPCardCollectionViewCell"
#import "HomeAdverCollectionViewCell.h"
#define kHomeAdverCollectionViewCell @"HomeAdverCollectionViewCell"
#import "OrderListViewController.h"



/*
 名称    分组    更新时间
 s_art 普通专栏卡片数据    首页卡片    并列式
 adver 广告卡片数据    首页卡片
 banner 轮播图卡片数据    首页卡片
 navbars 导航栏卡片数据    首页卡片
 attention 关注公众号卡片数据    首页卡片
 oneCourse 单课程卡片数据    首页卡片    无顶部标签 art s_art topic series 需要下移十单位
 series 直播专栏卡片数据    首页卡片    大图
 topic 直播卡片数据    首页卡片    大图
 art 图文视频卡片数据    首页卡片    列表式
 teacher 老师卡片数据    首页卡片
 vipCard 会员卡卡片数据    首页卡片
 search 搜索卡片数据    首页卡片
 vip 会员卡片数据    首页卡片
 community 社群卡
 */


@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UserModule_LeadtypeProtocol,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSArray * dataArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self loadData];
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryClick:) name:kNotificationOfMainPageCategoryClick object:nil];
    
}
- (void)navigationViewSetup
{
    self.navigationItem.title = @"汇聚播商学院";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createOrderSuccedsss:) name:kNotificationOfCreateOrderSuccess object:nil];

}

//- (void)createOrderSuccedsss:(NSNotification *)notification
//{
//    OrderListViewController * vc = [[OrderListViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc  animated:YES];
//}

- (void)loadData
{
    [[UserManager sharedManager] getLeadTypeWith:@{kUrlName:@"api/index"} withNotifiedObject:self];
    [[UserManager sharedManager] didRequestStoreSettingWithWithDic:@{kUrlName:@"api/custom/setting",kRequestType:@"get"} withNotifiedObject:nil];
    [[UserManager sharedManager] getUserInfoWith:@{kUrlName:@"api/home/user"} withNotifiedObject:nil];
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
    [self.collectionView registerClass:[HomeBigImageTypeCollectionViewCell class] forCellWithReuseIdentifier:kHomeBigImageTypeCollectionViewCell];
    [self.collectionView registerClass:[HomeJustaposeCollectionViewCell class] forCellWithReuseIdentifier:kHomeJustaposeCollectionViewCell];
    [self.collectionView registerClass:[HomeListTypeCollectionViewCell class] forCellWithReuseIdentifier:kHomeListTypeCollectionViewCell];
    [self.collectionView registerClass:[HomeTeacherListCollectionViewCell class] forCellWithReuseIdentifier:kHomeTeacherListCollectionViewCell];
    [self.collectionView registerClass:[HomePublicNumberCollectionViewCell class] forCellWithReuseIdentifier:kHomePublicNumberCollectionViewCell];
    [self.collectionView registerClass:[HomeCommunityCollectionViewCell class] forCellWithReuseIdentifier:kHomeCommunityCollectionViewCell];
    [self.collectionView registerClass:[HomeVIPCardCollectionViewCell class] forCellWithReuseIdentifier:kHomeVIPCardCollectionViewCell];
    [self.collectionView registerClass:[HomeBigImageNoTeacherTypeCollectionViewCell class] forCellWithReuseIdentifier:kHomeBigImageNoTeacherTypeCollectionViewCell];
    [self.collectionView registerClass:[HomeAdverCollectionViewCell class] forCellWithReuseIdentifier:kHomeAdverCollectionViewCell];

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
            [cell showClickBtn];
            cell.searchBlock = ^(NSString * _Nonnull key) {
                SearchCourseViewController * vc = [[SearchCourseViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
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
            
            HomeJustaposeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeJustaposeCollectionViewCell forIndexPath:indexPath];
            
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
        case HomeCellType_adver:
        {
            HomeAdverCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeAdverCollectionViewCell forIndexPath:indexPath];
            [cell refreshUIWith:[info objectForKey:@"data"]];
            return cell;
        }
            break;
        case HomeCellType_PublicNumber:
        {
            HomePublicNumberCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomePublicNumberCollectionViewCell forIndexPath:indexPath];
            [cell resetCellContent:[info objectForKey:@"data"]];
            return cell;
        }
            
            break;
        case HomeCellType_BigImageType:// topic
        {
            
            HomeBigImageTypeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeBigImageTypeCollectionViewCell forIndexPath:indexPath];
            
            NSArray * dataArray = [info objectForKey:@"data"];
            if ([dataArray isKindOfClass:[NSDictionary class]])  {
                cell.isOneCourse = YES;
                [cell refreshUIWith:[info objectForKey:@"data"]];
            }else
            {
                cell.isOneCourse = NO;
                [cell refreshUIWith:[dataArray objectAtIndex:indexPath.item]];
            }
            cell.applyBlock = ^(NSDictionary * _Nonnull info) {
                NSArray * dataArray = [info objectForKey:@"data"];
                if ([dataArray isKindOfClass:[NSDictionary class]]) {
                    [weakSelf operationTopicInfo:[info objectForKey:@"data"]];
                }else
                {
                    [weakSelf operationTopicInfo:[dataArray objectAtIndex:indexPath.item]];
                }
            };
            return cell;
        }
            break;
        case HomeCellType_BigImageNoTeacherType: // series
        {
            HomeBigImageNoTeacherTypeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeBigImageNoTeacherTypeCollectionViewCell forIndexPath:indexPath];
            NSArray * dataArray = [info objectForKey:@"data"];
            if ([dataArray isKindOfClass:[NSDictionary class]]) {
                cell.isOneCourse = YES;
                [cell refreshUIWith:[info objectForKey:@"data"]];
            }else
            {
                cell.isOneCourse = NO;
                [cell refreshUIWith:[dataArray objectAtIndex:indexPath.item]];
            }
            
            cell.applyBlock = ^(NSDictionary * _Nonnull info) {
                NSArray * dataArray = [info objectForKey:@"data"];
                if ([dataArray isKindOfClass:[NSDictionary class]]) {
                    [weakSelf operationTopicInfo:[info objectForKey:@"data"]];
                }else
                {
                    [weakSelf operationTopicInfo:[dataArray objectAtIndex:indexPath.item]];
                }
            };
            
            return cell;
        }
            break;
        case HomeCellType_ListType:
        {
            NSArray * dataArray = [info objectForKey:@"data"];
            HomeListTypeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeListTypeCollectionViewCell forIndexPath:indexPath];
            if ([dataArray isKindOfClass:[NSDictionary class]]) {
                cell.isOneCourse = YES;
                [cell resetCellContent:[info objectForKey:@"data"]];
            }else
            {
                cell.isOneCourse = NO;
                [cell resetCellContent:dataArray[indexPath.item]];
            }
            return cell;
        }
            break;
        case HomeCellType_TeacherList:
        {
            HomeTeacherListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeTeacherListCollectionViewCell forIndexPath:indexPath];
            [cell refreshWithinfo:info];
            cell.teacherDetailBlock = ^(NSDictionary * _Nonnull info) {
                TeacherDetailViewController * vc = [[TeacherDetailViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.info = info;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
            break;
        case HomeCellType_VipCard:
        {
            HomeVIPCardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeVIPCardCollectionViewCell forIndexPath:indexPath];
            [cell refreshUIWith:[info objectForKey:@"data"]];
            cell.applyBtn.hidden = YES;
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
        case HomeCellType_Community:
        {
            NSArray * dataArray = [info objectForKey:@"data"];
            HomeCommunityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCommunityCollectionViewCell forIndexPath:indexPath];
            [cell resetCellContent:dataArray[indexPath.item]];
            
            cell.cancelOrderLivingCourseBlock = ^(NSDictionary * _Nonnull info) {
                JoinAssociationViewController * vc = [[JoinAssociationViewController alloc]init];
                vc.infoDic = dataArray[indexPath.item];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
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
        case HomeCellType_JustaposeType:
        {
           
        }
            break;
        case HomeCellType_adver:
        {
            // 广告
            NSDictionary * courseInfo = [info objectForKey:@"data"];
            [self operationInfo:courseInfo];
        }
            break;
        case HomeCellType_BigImageType:// topic
        {
            
            NSArray * dataArray = [info objectForKey:@"data"];
            if ([dataArray isKindOfClass:[NSDictionary class]]) {
                [self operationTopicInfo:[info objectForKey:@"data"]];
            }else
            {
                [self operationTopicInfo:[dataArray objectAtIndex:indexPath.item]];
            }
        }
            break;
        case HomeCellType_BigImageNoTeacherType: // series
        {
            NSArray * dataArray = [info objectForKey:@"data"];
            if ([dataArray isKindOfClass:[NSDictionary class]]) {
                [self operationTopicInfo:[info objectForKey:@"data"]];
            }else
            {
                [self operationTopicInfo:[dataArray objectAtIndex:indexPath.item]];
            }
            
        }
            break;
        case HomeCellType_ListType:
        {
            NSArray * dataArray = [info objectForKey:@"data"];
            ArticleDetailViewController * vc = [[ArticleDetailViewController alloc]init];
            
            if ([dataArray isKindOfClass:[NSDictionary class]]) {
                vc.infoDic = (NSDictionary *)dataArray;
            }else
            {
                vc.infoDic = dataArray[indexPath.item];
            }
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        
        case HomeCellType_VipCard:
        {
            NSDictionary * courseInfo = [info objectForKey:@"data"];
            VIPCardDetailViewController * vc = [[VIPCardDetailViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.info = courseInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case HomeCellType_openVIP:
        {
            MainVipCardListViewController * vc = [[MainVipCardListViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        
        default:
            break;
    }
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
                [weakSelf pushSecondVC:SecondListType_living andInfo:@"0"];
            }else if([type isEqualToString:@"teacher"])
            {
                TeacherListViewController * vc = [[TeacherListViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if([type isEqualToString:@"art"])
            {
                [weakSelf pushSecondVC:SecondListType_artical andInfo:@"0"];
            }else if([type isEqualToString:@"community"])
            {
                AssoiciationListViewController * vc = [[AssoiciationListViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.array = [info objectForKey:@"data"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
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
            int count = (navbars.count % 4) == 0 ? (navbars.count / 4) : (navbars.count / 4 + 1);
            
            return CGSizeMake(collectionView.hd_width, (count) * 90 + 20);
        }
            break;
        case HomeCellType_JustaposeType: // type 为onCourse 高度加20
            if ([type isEqualToString:@"oneCourse"]) {
                return CGSizeMake(collectionView.hd_width / 2 - 5, (collectionView.hd_width / 2 - 5 - 22.5) / 2 + 86.5 + 20);
            }
            return CGSizeMake(collectionView.hd_width / 2 - 5, (collectionView.hd_width / 2 - 5 - 22.5) / 2 + 86.5);
            break;
        case HomeCellType_adver:
            return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 2 + 35);
            break;
        case HomeCellType_PublicNumber:
            return CGSizeMake(collectionView.hd_width, 84);
            break;
        case HomeCellType_BigImageType: // type 为onCourse 高度加20
            if ([type isEqualToString:@"oneCourse"]) {
                return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 2 + 86 + 20);
            }
            return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 2 + 86);
            break;
        case HomeCellType_BigImageNoTeacherType: // type 为onCourse 高度加20
            if ([type isEqualToString:@"oneCourse"]) {
                return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 2 + 77.5 + 20);
            }
            return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 2 + 77.5);
            break;
        case HomeCellType_ListType: // type 为onCourse 高度加20
            if ([type isEqualToString:@"oneCourse"]) {
                return CGSizeMake(collectionView.hd_width, 90 + 20);
            }
            return CGSizeMake(collectionView.hd_width, 90);
            break;
        case HomeCellType_TeacherList:
            return CGSizeMake(collectionView.hd_width, 116);
            break;
        case HomeCellType_VipCard:
            return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 3 + 67.5 + 40);
            break;
        case HomeCellType_openVIP:
            return CGSizeMake(collectionView.hd_width, 60);
            break;
        case HomeCellType_Community:
            return CGSizeMake(collectionView.hd_width, 100);
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
    return CGSizeMake(collectionView.hd_width, 10);
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
    [SVProgressHUD dismiss];
    NSArray * dataArray = [[UserManager sharedManager] getLeadTypeArray];
    
    if ([dataArray isKindOfClass:[NSDictionary class]]) {
        NSDictionary * info = dataArray;
        self.dataArray = [info allValues];
    }else
    {self.dataArray = dataArray;}
    
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


- (void)operationTopicInfo:(NSDictionary *)info
{
    LivingCourseDetailViewController * vc = [[LivingCourseDetailViewController alloc]init];
    vc.info = info;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
         index    首页      1
         center    个人中心  1
         yd_payred_index    图文音视频  1
         ask_expert    问答
         zb_topics    直播  1
         yx_activiy    优惠券
         zb_series    直播专栏
         yd_serialize    普通专栏
         saas_bargain    砍价
         vip_introduce    会员
         shop_index    商城  1
         mypay    我的已购    1
         yx_extension_recruit    推广中心   1
         yd_detail    图文音视频详情   1
         vip_center    会员中心       1
         zb_topic_info    直播详情页   1
         
         */
        if ([innerType isEqualToString:@"index"]) {
            NSLog(@"首页");
        }else if ([innerType isEqualToString:@"center"])
        {
            NSLog(@"个人中心");
            [self.tabBarController setSelectedIndex:1];
        }
        
        else if ([innerType isEqualToString:@"mypay"])
        {
            MyBuyCourseViewController * vc = [[MyBuyCourseViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([innerType isEqualToString:@"shop_index"])
        {
            StoreViewController * vc = [[StoreViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
            vc.fromType = FromType_push;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([innerType isEqualToString:@"zb_topics"])
        {
            NSString * pid = @"";
            if (![[info objectForKey:@"need_redirect"] isKindOfClass:[NSNull class]]) {
                pid = [[info objectForKey:@"need_redirect"] objectForKey:@"tags"];
            }
            [self pushSecondVC:SecondListType_living andInfo:pid];
        }
        else if ([innerType isEqualToString:@"yd_payred_index"])
        {
            NSString * pid = @"";
            if (![[info objectForKey:@"need_redirect"] isKindOfClass:[NSNull class]]) {
                pid = [[info objectForKey:@"need_redirect"] objectForKey:@"pid"];
            }
            [self pushSecondVC:SecondListType_artical andInfo:pid];
        }else if ([innerType isEqualToString:@"yd_detail"])
        {
            [self pushArticleDetailVC:[info objectForKey:@"need_redirect"]];
        }
        else if ([innerType isEqualToString:@"zb_topic_info"])
        {
            [self pushLivingDetailVC:[info objectForKey:@"need_redirect"]];
        }else if ([innerType isEqualToString:@"yx_extension_recruit"])
        {
            MyPromotionViewController * vc = [[MyPromotionViewController alloc]init];
            NSDictionary *  promotionInfo = [[[UserManager sharedManager] getUserInfo] objectForKey:@"promoter"];
            PromotionType promotionType;
            if (![promotionInfo isKindOfClass:[NSNull class]]) {
                if ([[promotionInfo objectForKey:@"status"] intValue] == 1) {
                    promotionType = PromotionType_check;
                }else if ([[promotionInfo objectForKey:@"status"] intValue] == 2)
                {
                    promotionType = PromotionType_complate;
                }else
                {
                    promotionType = PromotionType_apply;
                }
            }else
            {
                promotionType  = PromotionType_apply;
            }
            vc.hidesBottomBarWhenPushed = YES;
            vc.promotionType = promotionType;
            [self.navigationController pushViewController:vc animated:YES];
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

- (void)pushArticleDetailVC:(NSDictionary *)info
{
    ArticleDetailViewController * vc = [[ArticleDetailViewController alloc]init];
    
    vc.infoDic = info;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushLivingDetailVC:(NSDictionary *)info
{
    LivingCourseDetailViewController * vc = [[LivingCourseDetailViewController alloc]init];
    NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
    
    vc.info = mInfo;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSecondVC:(SecondListType)type andInfo:(NSString *)pid
{
    SecongListViewController * vc = [[SecongListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.secondType = type;
    vc.pid = pid.intValue;
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
