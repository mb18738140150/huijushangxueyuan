//
//  TeacherListViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import "TeacherListViewController.h"
#import "TeacherListTableViewCell.h"
#define kTeacherListTableViewCell @"TeacherListTableViewCell"
#import "TeacherDetailViewController.h"


@interface TeacherListViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_CourseTeacherProtocol>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, assign)int page;

@end

@implementation TeacherListViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self navigationViewSetup];

    [self loadData];
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"热门导师";
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
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TeacherListTableViewCell class] forCellReuseIdentifier:kTeacherListTableViewCell];
    [self.tableView registerClass:[LoadFailedTableViewCell class] forCellReuseIdentifier:kFailedCellID];

    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)loadData
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getCourseTeacherWith:@{kUrlName:@"api/teacher/lists",@"requestType":@"get"} withNotifiedObject:self];
}

- (void)didCourseTeacherSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    NSArray * list = [[UserManager sharedManager] getCourseTeaccherArray];
   
    self.dataSource = [list mutableCopy];
    [self.tableView reloadData];
}

- (void)didCourseTeacherFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count == 0 ? 1 : self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == 0) {
        LoadFailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFailedCellID forIndexPath:indexPath];
        [cell refreshUIWith:@{}];
        
        return cell;
    }
    
    __weak typeof(self)weakSelf = self;
    TeacherListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTeacherListTableViewCell forIndexPath:indexPath];
    CellCornerType cellType = CellCornerType_none;
    if(indexPath.row == 0)
    {
        cellType = CellCornerType_top;
    }else if (indexPath.row == self.dataSource.count - 1)
    {
        cellType = CellCornerType_bottom;
    }
    [cell refreshUIWith:self.dataSource[indexPath.row] andCornerType:cellType];
    
    cell.checkDetailBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf pushTeacherDetailVC:info];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == 0) {
        return tableView.hd_height;
    }
    return 70;
}

- (void)pushTeacherDetailVC:(NSDictionary *)info
{
    TeacherDetailViewController * vc = [[TeacherDetailViewController alloc]init];
    vc.info = info;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
