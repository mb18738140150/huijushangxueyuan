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

@interface AssoiciationListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;

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
    
    self.itemArray = [self.array mutableCopy];
    [self navigationViewSetup];
    [self prepareUI];
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
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];
}

- (void)loadData
{
    
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


@end
