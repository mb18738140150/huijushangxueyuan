//
//  TeacherListViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import "AssociationMemberListViewController.h"
#import "TeacherListTableViewCell.h"
#define kTeacherListTableViewCell @"TeacherListTableViewCell"
#import "TeacherDetailViewController.h"
#import "TeacherListTableViewCell.h"
#define kTeacherListTableViewCell @"TeacherListTableViewCell"

@interface AssociationMemberListViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_CourseTeacherProtocol,UserModule_MockVIPBuy>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, assign)int page;

@property (nonatomic, strong)UIButton *editBtn;
@property (nonatomic, assign)BOOL canEdit;

@property (nonatomic, strong)NSDictionary * currentBlackInfo;

@end

@implementation AssociationMemberListViewController

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
    self.navigationItem.title = @"成员列表";
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
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doNextPageQuestionRequest)];

}

- (void)loadData
{
    self.page = 1;
    [SVProgressHUD show];
    [[UserManager sharedManager] getCourseTeacherWith:@{kUrlName:@"api/community/communityuserlist",@"requestType":@"get",@"c_id":[self.infoDic objectForKey:@"id"],@"page":@(self.page)} withNotifiedObject:self];
}

- (void)doNextPageQuestionRequest
{
    self.page++;
    [SVProgressHUD show];
    [[UserManager sharedManager] getCourseTeacherWith:@{kUrlName:@"api/community/communityuserlist",@"requestType":@"get",@"c_id":[self.infoDic objectForKey:@"id"],@"page":@(self.page)} withNotifiedObject:self];
}

- (void)didCourseTeacherSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    NSArray * list = [[UserManager sharedManager] getCourseTeaccherArray];
    if (list.count == 0) {
        if (self.page > 1) {
            self.page--;
        }
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
        return;
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
    
    if (self.currentBlackInfo) {
        NSDictionary * info1;
        for (NSDictionary * info in list) {
            if ([[info objectForKey:@"id"] isEqual:[self.currentBlackInfo objectForKey:@"id"]]) {
                info1 = info;
                break;
            }
        }
        NSInteger index = [self.dataSource indexOfObject:self.currentBlackInfo];
        [self.dataSource replaceObjectAtIndex:index withObject:info1];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        self.currentBlackInfo = nil;
        return;
    }
    
    
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
    }
    for (NSDictionary * info in list) {
        [self.dataSource addObject:info];
    }
    [self.tableView reloadData];
}

- (void)didCourseTeacherFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.currentBlackInfo = nil;
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    TeacherListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTeacherListTableViewCell forIndexPath:indexPath];
    NSDictionary * info = self.dataSource[indexPath.row];
    [cell refreshMemberUIWith:self.dataSource[indexPath.row]];
    
    [cell resetEditBtn:self.canEdit];
    cell.blackBlock = ^(NSDictionary * _Nonnull info) {
        weakSelf.currentBlackInfo = info;
        [weakSelf blackAction:info];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake( 15, 10, tableView.hd_width - 30, headView.hd_height - 20)];
    titleLB.textColor = UIColorFromRGB(0x999999);
    titleLB.font = kMainFont_12;
    NSString * titleStr  = @"成员列表  共16人";
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
    [mStr setAttributes:attribute range:NSMakeRange(0, 4)];
    titleLB.attributedText = mStr;
    
    [headView addSubview:titleLB];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth - 100, 0, 80, headView.hd_height);
    [button setTitle:@"管理成员" forState:UIControlStateNormal];
    [button setTitle:@"退出管理" forState:UIControlStateSelected];
    button.titleLabel.font = kMainFont;
    [button setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    if ([UserManager sharedManager].is_admin) {
        button.hidden = NO;
    }else
    {
        button.hidden = YES;
    }
    button.selected = self.editBtn.selected;
    self.editBtn = button;
    [button addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(15, headView.hd_height - 1, headView.hd_width - 30, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [headView addSubview:separateView];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)blackAction:(NSDictionary *)info
{
    [SVProgressHUD dismiss];
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/community/communityuserblack",@"c_id":[self.infoDic objectForKey:@"id"],@"cuser_id":[info objectForKey:@"id"],kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD showSuccessWithStatus:@"设置成功"];
    self.editBtn.selected = NO;
    self.canEdit = NO;
    [[UserManager sharedManager] getCourseTeacherWith:@{kUrlName:@"api/community/communityuserlist",@"requestType":@"get",@"c_id":[self.infoDic objectForKey:@"id"],@"page":@(self.page)} withNotifiedObject:self];
}

- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    self.currentBlackInfo = nil;
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)editAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.isSelected) {
        self.canEdit = YES;
    }else{
        self.canEdit = NO;
    }
    [self.tableView reloadData];
}

@end
