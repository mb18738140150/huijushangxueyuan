//
//  MainVipCardListViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import "MainVipCardListViewController.h"
#import "MainVipCardHeadCollectionViewCell.h"
#define kMainVipCardHeadCollectionViewCell @"MainVipCardHeadCollectionViewCell"
#import "MainMyVIPCardListCollectionViewCell.h"
#define kMainMyVIPCardListCollectionViewCell @"MainMyVIPCardListCollectionViewCell"
#import "HomeVIPCardCollectionViewCell.h"
#define kHomeVIPCardCollectionViewCell @"HomeVIPCardCollectionViewCell"

#import "VIPCardDetailViewController.h"

@interface MainVipCardListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UserModule_MyVIPCardInfo,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic, strong)NSDictionary * vipCardInfo;
@end

@implementation MainVipCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];

    [self loadData];
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"会员中心";
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
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight- kNavigationBarHeight - kStatusBarHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MainVipCardHeadCollectionViewCell class] forCellWithReuseIdentifier:kMainVipCardHeadCollectionViewCell];
    [self.collectionView registerClass:[MainMyVIPCardListCollectionViewCell class] forCellWithReuseIdentifier:kMainMyVIPCardListCollectionViewCell];
    [self.collectionView registerClass:[HomeVIPCardCollectionViewCell class] forCellWithReuseIdentifier:kHomeVIPCardCollectionViewCell];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)loadData
{
    [[UserManager sharedManager] didRequestMyVIPCardWithInfo:@{kUrlName:@"api/home/vip"} withNotifiedObject:self];
}

- (void)didRequestMyVIPCardInfoSuccessed
{
    [self.collectionView.mj_header endRefreshing];
    self.vipCardInfo = [[UserManager sharedManager] getVIPCardInfo];
    self.dataSource = [self.vipCardInfo objectForKey:@"list"];
    [self.collectionView reloadData];
}

- (void)didRequestMyVIPCardInfoFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.collectionView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.dataSource.count;
    }
    if ([[self.vipCardInfo objectForKey:@"my"] isKindOfClass:[NSDictionary class]]) {
        return 2;
    }
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MainVipCardHeadCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMainVipCardHeadCollectionViewCell forIndexPath:indexPath];
            [cell resetUIWith:[[UserManager sharedManager] getUserInfos]];
            return cell;
        }
        MainMyVIPCardListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMainMyVIPCardListCollectionViewCell forIndexPath:indexPath];
        if ([[self.vipCardInfo objectForKey:@"my"] isKindOfClass:[NSDictionary class]]) {
            [cell resetUIWithInfoArray:@[[self.vipCardInfo objectForKey:@"my"]]];
            
            cell.myVIPCardClickBlock = ^(NSDictionary * _Nonnull info) {
                VIPCardDetailViewController * vc = [[VIPCardDetailViewController alloc]init];
                vc.info = info;
                vc.myInfo = info;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        return cell;
    }
    
    HomeVIPCardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeVIPCardCollectionViewCell forIndexPath:indexPath];
    [cell refreshUIWith:self.dataSource[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return CGSizeMake(collectionView.hd_width, (collectionView.hd_width - 35) / 3 + 67.5 + 40);;
    }else
    {
        if (indexPath.row == 0) {
            return CGSizeMake(collectionView.hd_width, 140);
        }
        return CGSizeMake(collectionView.hd_width, (kScreenWidth / 3 - 30) / 3 + 50 + 30 + 40);
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        VIPCardDetailViewController * vc = [[VIPCardDetailViewController alloc]init];
        vc.info = self.dataSource[indexPath.item];
        if ([self.vipCardInfo objectForKey:@"my"] != nil && [[self.vipCardInfo objectForKey:@"my"] allKeys].count > 0) {
            vc.myInfo = [self.vipCardInfo objectForKey:@"my"];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
