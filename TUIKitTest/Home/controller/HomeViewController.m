//
//  HomeViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeViewController.h"
#import "SecongListViewController.h"


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

typedef enum : NSUInteger {
    HomeCellType_search,
    HomeCellType_banner,
    HomeCellType_category,
    HomeCellType_openVIP,
    HomeCellType_BigImageType,
    HomeCellType_BigImageNoTeacherType,
    HomeCellType_JustaposeType,
    HomeCellType_ListType,
    HomeCellType_TeacherList,
    HomeCellType_PublicNumber,
    HomeCellType_Community,
    HomeCellType_VipCard,
    HomeCellType_adver,
} HomeCellType;

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
}
- (void)navigationViewSetup
{
    
    self.navigationItem.title = @"汇聚商商学院";
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
            for (NSDictionary * bannerInfo in [info objectForKey:@"data"]) {
                if ([UIUtility judgeStr:[bannerInfo objectForKey:@"image"]]) {
                    [imageUrlArray addObject:[bannerInfo objectForKey:@"image"]];
                }
            }
            cell.bannerImgUrlArray = imageUrlArray;
            [cell resetCornerRadius:10];
            [cell resetSubviews];
            return cell;
        }
            break;
        case HomeCellType_category:
        {
            NSArray * navbars = [info objectForKey:@"data"];
            HomeCategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCategoryCollectionViewCell forIndexPath:indexPath];
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
            return cell;
        }
            break;
        case HomeCellType_VipCard:
        {
            HomeVIPCardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeVIPCardCollectionViewCell forIndexPath:indexPath];
            [cell refreshUIWith:[info objectForKey:@"data"]];
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
            return cell;
        }
            break;
        default:
            break;
    }
    
    HomeSearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeSearchCollectionViewCell forIndexPath:indexPath];
    return cell;
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
                SecongListViewController * vc = [[SecongListViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
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
            int count = navbars.count / 4 + 1;
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
            return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 4 + 35);
            break;
        case HomeCellType_PublicNumber:
            return CGSizeMake(collectionView.hd_width, 84);
            break;
        case HomeCellType_BigImageType: // type 为onCourse 高度加20
            if ([type isEqualToString:@"oneCourse"]) {
                return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 2 + 126 + 20);
            }
            return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 2 + 126);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
