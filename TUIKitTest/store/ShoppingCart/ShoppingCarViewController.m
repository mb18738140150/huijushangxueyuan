//
//  ShoppingCarViewController.m
//  lanhailieren
//
//  Created by aaa on 2020/3/5.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarListTableViewCell.h"
#define kShoppingCarListTableViewCellID @"ShoppingCarListTableViewCellID"
#import "ShoppingCarBottomView.h"
#import "ConfirmOrderViewController.h"

@interface ShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,UserModule_ShoppingCarListProtocol,UserModule_DeleteShoppingCarProtocol,UserModule_AddShoppingCarProtocol,UserModule_MockVIPBuy>

@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, strong)NSMutableArray * selectArray;

@property (nonatomic, strong)ShoppingCarBottomView * shoppingCarBottomView;
@property (nonatomic, strong)NSDictionary * currentEditInfo;

@property (nonatomic, assign)BOOL isEditing;

@end

@implementation ShoppingCarViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self didRequestShoppingCarListSuccessed];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationViewSetup];
    
    [self loadData];
    
    [self refreshUI_iPhone];
}

- (void)loadData
{
    [self doResetQuestionRequest];
}

- (void)navigationViewSetup
{
    
    self.navigationItem.title = @"购物车";
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
//    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTintColor:kMainTextColor];
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)settingAction
{
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
    }else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    }
    [self.tableview reloadData];
    [self.shoppingCarBottomView refreshEditState:self.isEditing];
}

- (void)refreshUI_iPhone
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight  - 50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShoppingCarListTableViewCell class] forCellReuseIdentifier:kShoppingCarListTableViewCellID];
    [self.tableview registerClass:[LoadFailedTableViewCell class] forCellReuseIdentifier:kFailedCellID];

    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.tableview];
    
    
    self.shoppingCarBottomView = [[ShoppingCarBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight- kNavigationBarHeight - kStatusBarHeight  - 50, kScreenWidth, 50)];
    [self.view addSubview:self.shoppingCarBottomView];
    [self.shoppingCarBottomView refreshEditState:self.isEditing];
    __weak typeof(self)weakSelf = self;
    self.shoppingCarBottomView.selectAllBlock = ^(BOOL select) {
        [weakSelf selectAllCommodity:select];
    };
    
    self.shoppingCarBottomView.buyShoppingCarBlock = ^(NSDictionary *info) {
        [weakSelf buyAction];
    };
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doResetQuestionRequest)];
    
    [self.tableview reloadData];
}
#pragma mark - getintegerDetailList
- (void)doResetQuestionRequest
{
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestShoppingCarListWith:@{kUrlName:@"api/shop/cart/lists",kRequestType:@"get"} withNotifiedObject:self ];
}

#pragma mark - tableview delegate & datasource
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
    ShoppingCarListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kShoppingCarListTableViewCellID forIndexPath:indexPath];
    
    
    [cell refreshUIWithInfo:[self.dataSource objectAtIndex:indexPath.row] isCanSelect:YES];
    BOOL isContain = [self isContain:[self.dataSource objectAtIndex:indexPath.row]];
    [cell resetSelectState:isContain];
    
    __weak typeof(self)weakSelf = self;
    
    // 更改数量
    cell.countBlock = ^(int count) {
        NSDictionary * dic = [weakSelf.dataSource objectAtIndex:indexPath.row];
        weakSelf.currentEditInfo = dic;
        [SVProgressHUD show];
        [[UserManager sharedManager] didRequestAddShoppingCarWith:@{kUrlName:@"api/shop/cart/updateNum",@"cart_id":[dic objectForKey:@"id"],@"num":@(count)} withNotifiedObject:self];
        
    };
    
    cell.selectBtnClickBlock = ^(NSDictionary *info,BOOL select) {
        [weakSelf refreshShoppingCar:info andSelect:select];
    };
    cell.deleteBlock = ^(NSDictionary *info) {
        [weakSelf deleteAction:info];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == 0) {
        return tableView.hd_height;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == 0) {
        return;
    }
    NSDictionary * info = [self.dataSource objectAtIndex:indexPath.row];
    [self refreshShoppingCar:info andSelect:NO];
}

#pragma mark - refreshShoppingCar
- (void)refreshShoppingCar:(NSDictionary *)info andSelect:(BOOL)select
{
    NSString * type = @"active";
    if ([[info objectForKey:@"active"] boolValue]) {
        type = @" unactive";
    }
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/shop/cart/activeSwitch",@"cart_id":[info objectForKey:@"id"],@"type":type} withNotifiedObject:self];

}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD dismiss];
    [self loadData];
}

- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)refreshAllPrice:(NSDictionary *)infoDic
{
    float allPrice = [[SoftManager shareSoftManager] getAllPrice:self.selectArray];
    [self.shoppingCarBottomView refreshPrice:@{@"price":[NSString stringWithFormat:@"%.2f", allPrice],@"count":[NSString stringWithFormat:@"%d", self.selectArray.count]}];
}

- (BOOL)isContain:(NSDictionary *)info
{
    BOOL isContain = NO;
    for (NSDictionary * selectInfo in self.selectArray) {
        if ([self isEqual:selectInfo withISelectInfo:info]) {
            isContain = YES;
            break;
        }
    }
    return isContain;
}

- (BOOL)isEqual:(NSDictionary *)info withISelectInfo:(NSDictionary *)selectInfo
{
    BOOL isEqual = NO;
    
    if ( [[info objectForKey:@"goods_id"] isEqual:[selectInfo objectForKey:@"goods_id"]]) {
        isEqual = YES;
    }
    
    return isEqual;
}

#pragma mark - 删除购物车商品
- (void)deleteSelectInfo:(NSDictionary *)info
{
    NSDictionary * deleteInfo = info;
    for (NSDictionary * selectInfo in self.selectArray) {
        if ([self isEqual:selectInfo withISelectInfo:info]) {
            deleteInfo = selectInfo;
            break;
        }
    }
    [self.selectArray removeObject:deleteInfo];
}



#pragma mark - selectAll -- buy -operation
- (void)selectAllCommodity:(BOOL)select
{
    [self.selectArray removeAllObjects];
    if (select) {
        for (NSDictionary * info in self.dataSource) {
            [self.selectArray addObject:info];
        }
    }else
    {
        
    }
    [self.tableview reloadData];
    [self refreshAllPrice:@{}];
}

- (float)getAllPrice:(NSArray *)selectArray
{
    if (selectArray.count == 0) {
        return 0.00;
    }else
    {
        float allPrice = 0.00;
        for (NSDictionary * infoDic in selectArray) {
            float price = [[infoDic objectForKey:@"price"] doubleValue];
            int count = [[infoDic objectForKey:@"count"] intValue];
            allPrice += price * count;
        }
        return allPrice;
    }

}



- (void)deleteAction:(NSDictionary *)info
{
    NSLog(@"delete");
    [SVProgressHUD show];
    [[UserManager sharedManager] didRequestDeleteShoppingCarWith:@{kUrlName:@"api/shop/cart/delete",@"cart_id":[info objectForKey:@"id"]} withNotifiedObject:self];
}

- (NSArray *)getDeleteInfoArray
{
    NSMutableArray * deleteArray = [NSMutableArray array];
    for (NSDictionary * info in self.selectArray) {
        NSMutableDictionary * mInfo = [NSMutableDictionary dictionary];
        [mInfo setObject:[info objectForKey:@"pay_money"] forKey:@"price"];
        [mInfo setObject:[info objectForKey:@"num"] forKey:@"count"];
        [mInfo setObject:[info objectForKey:@"id"] forKey:@"goods_id"];
        [deleteArray addObject:mInfo];
    }
    return deleteArray;
}

- (void)buyAction
{
    NSLog(@"buy");
    if (self.selectArray.count == 0) {
        
    }else{
        ConfirmOrderViewController * vc = [[ConfirmOrderViewController alloc]init];
        vc.selectArray = self.selectArray;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - shoppingOperation request
- (void)didRequestShoppingCarListSuccessed
{
    [self.tableview.mj_header endRefreshing];
    [SVProgressHUD dismiss];
    [self.dataSource removeAllObjects];
    [self.selectArray removeAllObjects];
    NSArray * list = [[UserManager sharedManager] getShoppingCarList];
    for (NSDictionary * info in list) {
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
        [mInfo setObject:[info objectForKey:@"pay_money"] forKey:@"price"];
        [mInfo setObject:[info objectForKey:@"num"] forKey:@"count"];
        [mInfo setObject:[info objectForKey:@"id"] forKey:@"goods_id"];
        
        if ([[info objectForKey:@"active"] boolValue]) {
            [self.selectArray addObject:mInfo];
        }
        
        [self.dataSource addObject:mInfo];
    }
    
     // 更新已编辑商品数据源
    for (NSDictionary * info in self.dataSource) {
        if ([self isEqual:self.currentEditInfo withISelectInfo:info]) {
            self.currentEditInfo = info;
            break;
        }
    }
    
    [self.tableview reloadData];
    
    [self refreshAllPrice:self.currentEditInfo];
}

- (void)didRequestShoppingCarListFailed:(NSString *)failedInfo
{
    [self.tableview.mj_header endRefreshing];
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestDeleteShoppingCarSuccessed
{
    [SVProgressHUD dismiss];
    [self loadData];
}

- (void)didRequestDeleteShoppingCarFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestAddShoppingCarFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestAddShoppingCarSuccessed
{
    [SVProgressHUD dismiss];
    [self loadData];
}

@end
