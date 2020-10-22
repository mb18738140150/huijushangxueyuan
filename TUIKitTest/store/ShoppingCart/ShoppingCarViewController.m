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

@interface ShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,UserModule_ShoppingCarListProtocol,UserModule_DeleteShoppingCarProtocol,UserModule_AddShoppingCarProtocol>

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
    [self.tableview.mj_header endRefreshing];
    
    NSDictionary * dataInfo = @{@"title":@"深海",@"image":[[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl],@"tip":@"不要啦",@"price":@"999.9",@"count":@1,@"goods_id":@1};
    NSDictionary  * passwordFoodInfo = @{@"title":@"e",@"image":[[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl],@"tip":@"不要",@"price":@"699.9",@"count":@2,@"goods_id":@2};
    NSDictionary  * phoneNumberInfo = @{@"title":@"深海2",@"image":[[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl],@"tip":@"不要啦",@"price":@"600",@"count":@1,@"goods_id":@3};
    NSDictionary  * addressInfo = @{@"title":@"玉4",@"image":[[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl],@"tip":@"不要啦",@"price":@"800",@"count":@1,@"goods_id":@4};

    [self.dataSource addObject:dataInfo];
    [self.dataSource addObject:passwordFoodInfo];
    [self.dataSource addObject:phoneNumberInfo];
    [self.dataSource addObject:addressInfo];
    
    
//    [SVProgressHUD show];
//    [[UserManager sharedManager] didRequestShoppingCarListWith:@{@"command":@21,@"shop_id":[[UserManager sharedManager].currentSelectStore objectForKey:@"id"]} withNotifiedObject:self ];
}

- (void)navigationViewSetup
{
    
    self.navigationItem.title = @"购物车";
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];
    self.navigationItem.rightBarButtonItem = item;
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
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShoppingCarListTableViewCell class] forCellReuseIdentifier:kShoppingCarListTableViewCellID];
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
    self.shoppingCarBottomView.deleteShoppingCarBlock = ^(NSDictionary *info) {
        [weakSelf deleteAction];
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
//    [[UserManager sharedManager] didRequestShoppingCarListWith:@{@"command":@21,@"shop_id":[[UserManager sharedManager].currentSelectStore objectForKey:@"id"]} withNotifiedObject:self ];
    [self loadData];
}

#pragma mark - tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
//        [[UserManager sharedManager] didRequestAddShoppingCarWith:@{@"command":@19,@"channel_id":[dic objectForKey:@"channel_id"],@"article_id":[dic objectForKey:@"article_id"],@"goods_id":[dic objectForKey:@"goods_id"],@"quantity":@(count),@"shop_id":[[UserManager sharedManager].currentSelectStore objectForKey:@"id"]} withNotifiedObject:self];
        
        NSInteger index = [weakSelf.dataSource indexOfObject:dic];
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [weakSelf.dataSource removeObject:dic];
        [mInfo setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
        [weakSelf.dataSource insertObject:mInfo atIndex:index];
        [weakSelf.tableview reloadData];
        [weakSelf refreshAllPrice:mInfo];
    };
    
    cell.selectBtnClickBlock = ^(NSDictionary *info,BOOL select) {
        [weakSelf refreshShoppingCar:info andSelect:select];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = [self.dataSource objectAtIndex:indexPath.row];
    [self refreshShoppingCar:info andSelect:NO];
}

- (void)refreshShoppingCar:(NSDictionary *)info andSelect:(BOOL)select
{
    BOOL isContain = [self isContain:info];
    
    if (isContain) {
        [self deleteSelectInfo:info];
    }else{
        [self.selectArray addObject:info];
    }
    
    float allPrice = [self getAllPrice:self.selectArray];
    [self.shoppingCarBottomView refreshPrice:@{@"price":@(allPrice)}];
    
    [self.tableview reloadData];
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


- (void)refreshAllPrice:(NSDictionary *)infoDic
{
    if (infoDic == nil) {
        float allPrice = [self getAllPrice:self.selectArray];
        [self.shoppingCarBottomView refreshPrice:@{@"price":@(allPrice)}];
        return;
    }
    
    NSDictionary * deleteInfo = infoDic;
    for (NSDictionary * selectInfo in self.selectArray) {
        if ([self isEqual:selectInfo withISelectInfo:infoDic]) {
            deleteInfo = selectInfo;
            break;
        }
    }
    [self.selectArray removeObject:deleteInfo];
    [self.selectArray addObject:infoDic];
    
    
    float allPrice = [[SoftManager shareSoftManager] getAllPrice:self.selectArray];
    [self.shoppingCarBottomView refreshPrice:@{@"price":@(allPrice)}];
}

- (BOOL)isEqual:(NSDictionary *)info withISelectInfo:(NSDictionary *)selectInfo
{
    BOOL isEqual = NO;
    
    if ( [[info objectForKey:@"goods_id"] isEqual:[selectInfo objectForKey:@"goods_id"]]) {
        isEqual = YES;
    }
    
    return isEqual;
}

#pragma mark - selectAll -- delete -- buy -operation
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
    float allPrice = [[SoftManager shareSoftManager] getAllPrice:self.selectArray];
    [self.shoppingCarBottomView refreshPrice:@{@"price":@(allPrice)}];
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



- (void)deleteAction
{
    NSLog(@"delete");
    [SVProgressHUD show];
//    [[UserManager sharedManager] didRequestDeleteShoppingCarWith:@{@"command":@20,@"delete_list":[self getDeleteInfoArray]} withNotifiedObject:self];
}

- (NSArray *)getDeleteInfoArray
{
    NSMutableArray * deleteArray = [NSMutableArray array];
    for (NSDictionary * info in self.selectArray) {
        NSMutableDictionary * mInfo = [NSMutableDictionary dictionary];
        [mInfo setObject:[info objectForKey:@"channel_id"] forKey:@"channel_id"];
        [mInfo setObject:[info objectForKey:@"article_id"] forKey:@"article_id"];
        [mInfo setObject:[info objectForKey:@"goods_id"] forKey:@"goods_id"];
//        [mInfo setObject:[[UserManager sharedManager].currentSelectStore objectForKey:@"id"] forKey:@"shop_id"];
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
    NSArray * list = [[UserManager sharedManager] getShoppingCarList];
    for (NSDictionary * info in list) {
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
        [mInfo setObject:[info objectForKey:@"quantity"] forKey:@"count"];
        [mInfo setObject:[info objectForKey:@"user_price"] forKey:@"price"];
        [mInfo setObject:[info objectForKey:@"spec_text"] forKey:@"tip"];
//        [mInfo setObject:[NSString stringWithFormat:@"%@%@", kRootImageUrl,[info objectForKey:@"img_url"]] forKey:@"image"];
        [self.dataSource addObject:mInfo];
    }
    
    // 更新已选中购物车商品为新数据源
    NSMutableArray * selectArray = [NSMutableArray array];
    for (NSDictionary * selectInfo in self.selectArray) {
        for (NSDictionary * info in self.dataSource) {
            if ([self isEqual:selectInfo withISelectInfo:info]) {
                [selectArray addObject:info];
            }
        }
    }
    [self.selectArray removeAllObjects];
    for (NSDictionary * info in selectArray) {
        [self.selectArray addObject:info];
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
