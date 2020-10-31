//
//  AssoiciationListViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "AssoiciationListViewController.h"
#import "JoinAssociationViewController.h"
#import "AssociationListTableViewCell.h"
#define kAssociationListTableViewCell @"AssociationListTableViewCell"

@interface AssoiciationListViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_AssociationList>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation AssoiciationListViewController
- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self navigationViewSetup];
    [self prepareUI];
    [self loadData];
}



#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"社群列表";
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView registerClass:[AssociationListTableViewCell class] forCellReuseIdentifier:kAssociationListTableViewCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
}

- (void)loadData
{
    self.page = 1;
    [SVProgressHUD show];
    [[UserManager sharedManager] getAssociationListWith:@{kUrlName:@"api/community/lists",@"page":@(self.page)} withNotifiedObject:self];
}

- (void)doNextPageQuestionRequest
{
    self.page++;
    [[UserManager sharedManager] getAssociationListWith:@{kUrlName:@"api/community/lists",@"page":@(self.page)} withNotifiedObject:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    AssociationListTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kAssociationListTableViewCell forIndexPath:indexPath];
    
    [titleCell resetCellContent:self.itemArray[indexPath.row]];
    titleCell.cancelOrderLivingCourseBlock = ^(NSDictionary * _Nonnull info) {
        JoinAssociationViewController * vc = [[JoinAssociationViewController alloc]init];
        NSArray * dataArray = [info objectForKey:@"data"];
        vc.infoDic = weakSelf.itemArray[indexPath.item];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return titleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didAssociationListSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    NSArray * list = [[UserManager sharedManager] getAssociationList];
    if (list.count <= 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.page == 1) {
        [self.itemArray removeAllObjects];
    }
    
    for (NSDictionary * info in list) {
        [self.itemArray addObject:info];
    }
    [self.tableView reloadData];
    
}

- (void)didAssociationListFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}



@end
