//
//  TeacherDetailViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import "TeacherDetailViewController.h"
#import "TeacherArticleTableViewCell.h"
#define kTeacherArticleTableViewCell @"TeacherArticleTableViewCell"
#import "TeacherListTableViewCell.h"
#define kTeacherListTableViewCell @"TeacherListTableViewCell"

@interface TeacherDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UserModule_TeacherDetailProtocol>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * articleSource;
@property (nonatomic, strong)NSMutableArray * topicSource;
@property (nonatomic, strong)NSDictionary * teacherInfo;

@end

@implementation TeacherDetailViewController

- (NSMutableArray *)articleSource
{
    if (!_articleSource) {
        _articleSource = [NSMutableArray array];
    }
    return _articleSource;;
}

- (NSMutableArray *)topicSource
{
    if (!_topicSource) {
        _topicSource  = [NSMutableArray array];
    }
    return _topicSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationViewSetup];
    [self loadData];
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"导师主页";
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

- (void)loadData
{
    [SVProgressHUD show];
    [[UserManager sharedManager] getTeacherDetailWith:@{kUrlName:@"api/teacher/info",@"requestType":@"get",@"teacher_id":[self.info objectForKey:@"id"]} withNotifiedObject:self];
}


- (void)prepareUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TeacherListTableViewCell class] forCellReuseIdentifier:kTeacherListTableViewCell];
    [self.tableView registerClass:[TeacherArticleTableViewCell class] forCellReuseIdentifier:kTeacherArticleTableViewCell];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return self.articleSource.count;
    }
    return self.topicSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        TeacherArticleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTeacherArticleTableViewCell forIndexPath:indexPath];
        
        NSArray * dataArray ;
        if (indexPath.section == 1) {
            dataArray = self.articleSource;
        }else
        {
            dataArray = self.topicSource;
        }
        
        CellCornerType cellType = CellCornerType_none;
        if (indexPath.row == dataArray.count - 1) {
            if(dataArray.count > 1)
            {
                cellType = CellCornerType_bottom;
            }
        }
        [cell refreshUIWith:dataArray[indexPath.row] andCornerType:cellType];
        
        return cell;
    }
    
    __weak typeof(self)weakSelf = self;
    TeacherListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTeacherListTableViewCell forIndexPath:indexPath];
    [cell refreshUIWith:self.teacherInfo andCornerType:CellCornerType_none];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)didTeacherDetailSuccessed
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    self.teacherInfo = [[UserManager sharedManager] getTeacherDetailInfo];
    self.articleSource = [[self.teacherInfo objectForKey:@"article"] objectForKey:@"data"];
    self.topicSource = [[self.teacherInfo objectForKey:@"topic"] objectForKey:@"data"];
    [self.tableView reloadData];
}

- (void)didTeacherDetailFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
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
