//
//  SecongListViewController.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "StoreSecondViewController.h"
#import "CommodityDetailViewController.h"
#import "SearchAndCategoryView.h"
#import "ZWMSegmentView.h"
#define kDataArray @"dataArray"

#import "CommodityCollectionViewCell.h"
#define kCommodityTableViewCell @"CommodityTableViewCell"

@interface StoreSecondViewController()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UserModule_SecondCategoryProtocol,UserModule_CategoryCourseProtocol>
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int pagesize;

@property (nonatomic, strong)ZWMSegmentView * courseSegment;

@property (nonatomic, strong)UICollectionView * tableView;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *pageIndexArray;
@property (nonatomic, strong)SearchAndCategoryView * topView;
@property (nonatomic, strong)NSString * keyword;

@property (nonatomic, strong)NSString * categoryUrl;
@property (nonatomic, strong)NSString * courseListUrl;


@end

@implementation StoreSecondViewController

- (NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.courseListUrl = @"api/shop/good/lists";
    
    [self navigationViewSetup];
    
    [SVProgressHUD show];
    self.keyword = @"";
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"热销商品";
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
    self.topView = [[SearchAndCategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    [self.view addSubview:self.topView];
    __weak typeof(self)weakSelf = self;
    self.topView.searchBlock = ^(NSString * _Nonnull key) {
        weakSelf.keyword = key;
        [weakSelf requestDataWith:weakSelf.courseSegment.index];
        
    };
    
    [self.categoryArray removeAllObjects];
    for (NSDictionary * info in [[UserManager sharedManager] getSecondCategoryeArray]) {
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
        if ([info objectForKey:@"title"]) {
            [mInfo setObject:[info objectForKey:@"title"] forKey:@"name"];
        }
        [self.categoryArray addObject:mInfo];
    }
    
    
    self.pageIndexArray = [NSMutableArray array];
       for (int i = 0; i< self.categoryArray.count; i++) {
           NSMutableDictionary * info = [NSMutableDictionary dictionary];
           [info setObject:@"1" forKey:kPageNo];
           [info setObject:@"10" forKey:kPageSize];
           [info setObject:[NSMutableArray array] forKey:kDataArray];
           
           [self.pageIndexArray addObject:info];
       }
    [self.topView refreshWith:self.categoryArray];
    
    self.courseSegment = self.topView.zixunSegment;
    
    int index = 1000;
    for (int i = 0; i < self.categoryArray.count ; i++) {
        NSDictionary * cateInfo = [self.categoryArray objectAtIndex:i];
        if ([[cateInfo objectForKey:@"id"] intValue] == self.cate_id) {
            [self requestDataWith:i];
            index = i;
            [self.courseSegment setSelectedAtIndex:i];
            break;
        }
    }
    if (index == 1000) {
        [self requestDataWith:0];
    }
    
    [self.courseSegment selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
        NSLog(@"%ld *** %@", index,button.titleLabel.text);
        
        NSDictionary * cateInfo = [weakSelf.categoryArray objectAtIndex:index];
           
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
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.tableView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 95) collectionViewLayout:layout];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.tableView registerClass:[CommodityCollectionViewCell class] forCellWithReuseIdentifier:kCommodityTableViewCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
        
}

- (void)doResetQuestionRequest
{
    if (self.categoryArray.count == 0) {
        [[UserManager sharedManager] getSecondCategoryeWith:@{kUrlName:self.categoryUrl} withNotifiedObject:self];
        return;
    }
    
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
    int pageNo = [[pageNoInfo objectForKey:kPageNo] intValue];
    NSMutableArray * mArray = [pageNoInfo objectForKey:kDataArray];
    self.itemArray = mArray;
    
    [SVProgressHUD show];
    [[UserManager sharedManager] getCategoryCourseWith:@{kUrlName:self.courseListUrl,@"cate_id":[cateInfo objectForKey:@"id"],@"keyword":self.keyword,@"page":@(pageNo)} withNotifiedObject:self];
    
    [self.tableView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommodityCollectionViewCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommodityTableViewCell forIndexPath:indexPath];
    
    [titleCell refreshUIWith:self.itemArray[indexPath.row] andItem:indexPath.item];
    return titleCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.hd_width / 2 - 5 , collectionView.hd_width / 2 - 5 - 22.5 + 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = [self.itemArray objectAtIndex:indexPath.row];
    CommodityDetailViewController * vc = [[CommodityDetailViewController alloc]init];
    vc.info = self.itemArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request

- (void)didCategoryCourseSuccessed
{
    [SVProgressHUD dismiss];
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

@end
