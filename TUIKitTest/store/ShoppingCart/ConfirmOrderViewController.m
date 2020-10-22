//
//  ConfirmOrderViewController.m
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "AddressListTableViewCell.h"
#define kAddressListTableViewCellID @"AddressListTableViewCellID"
#import "ShoppingCarListTableViewCell.h"
#define kShoppingCarListTableViewCellID @"ShoppingCarListTableViewCellID"
#import "ShoppingCarBottomView.h"
#import "ConfirmOrderInfoTableViewCell.h"
#define kConfirmOrderInfoTableViewCellID @"ConfirmOrderInfoTableViewCellID"
#import "PayModeSelectTableViewCell.h"
#define kp_a_yModeSelectTableViewCellID   @"payModeSelectTableViewCellID"

#import "AddressListViewController.h"

@interface ConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UserModule_CreateOrderProtocol,UserModule_CompleteUserInfoProtocol>

@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, strong)ShoppingCarBottomView * shoppingCarBottomView;
@property (nonatomic, assign)p_a_yModeType p_a_yModeType;

@property (nonatomic, assign)float allPrice;
@property (nonatomic, assign)float allInteger;

@end

@implementation ConfirmOrderViewController

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self refreshAllPrice];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self navigationViewSetup];
    
    [self refreshUI_iPhone];
}
- (void)loadData
{
    
    NSDictionary * priceInfo = @{@"title":@"商品价格",@"tip":@"500g，现杀",@"content":@"66",@"count":@"2",@"id":@"1"};
    NSDictionary  * integerInfo = @{@"title":@"赠送积分",@"tip":@"800g，现杀",@"content":@"88",@"count":@"2",@"id":@"2"};
    

    [self.dataSource addObject:priceInfo];
    [self.dataSource addObject:integerInfo];
    
    
}

- (void)navigationViewSetup
{
    self.navigationItem.title = @"确认订单";
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
    if (self.popFoodIntroVCBlock) {
        self.popFoodIntroVCBlock();
    }
}

- (void)refreshUI_iPhone
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 50) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShoppingCarListTableViewCell class] forCellReuseIdentifier:kShoppingCarListTableViewCellID];
    [self.tableview registerClass:[AddressListTableViewCell class] forCellReuseIdentifier:kAddressListTableViewCellID];
    [self.tableview registerClass:[ConfirmOrderInfoTableViewCell class] forCellReuseIdentifier:kConfirmOrderInfoTableViewCellID];
    [self.tableview registerClass:[PayModeSelectTableViewCell class] forCellReuseIdentifier:kp_a_yModeSelectTableViewCellID];
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.tableview];
    
    
    self.shoppingCarBottomView = [[ShoppingCarBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50- kNavigationBarHeight - kStatusBarHeight, kScreenWidth, 50) andBuy:YES];
    [self.view addSubview:self.shoppingCarBottomView];
    __weak typeof(self)weakSelf = self;
    self.shoppingCarBottomView.buyShoppingCarBlock = ^(NSDictionary *info) {
        [weakSelf buyAction];
    };
}

#pragma mark - tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            {
                return 1;
            }
            break;
        case 1:
        {
            return self.selectArray.count;
        }
            break;
        case 2:
        {
            return self.dataSource.count;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        AddressListTableViewCell * headCell = [tableView dequeueReusableCellWithIdentifier:kAddressListTableViewCellID forIndexPath:indexPath];
        headCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [headCell refreshConfirmOrderUIWithInfo:[UserManager sharedManager].currentSelectAddressInfo];
        [headCell showSeperateImageView];
        return headCell;
    }else if (indexPath.section == 1)
    {
        ShoppingCarListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kShoppingCarListTableViewCellID forIndexPath:indexPath];
        
        [cell refreshUIWithInfo:[self.selectArray objectAtIndex:indexPath.row] isCanSelect:NO];
        
        __weak typeof(self)weakSelf = self;
        
//        // 更改数量
        cell.countBlock = ^(int count) {
            NSDictionary * dic = [weakSelf.selectArray objectAtIndex:indexPath.row];
            NSInteger index = [weakSelf.selectArray indexOfObject:dic];
            NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:dic];
            [weakSelf.selectArray removeObject:dic];
            [mInfo setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
            [weakSelf.selectArray insertObject:mInfo atIndex:index];
            [weakSelf.tableview reloadData];
            [weakSelf refreshAllPrice];
        };
        
        return cell;
    }else if (indexPath.section == 2)
    {
        ConfirmOrderInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kConfirmOrderInfoTableViewCellID forIndexPath:indexPath];
        [cell refreshUI:[self.dataSource objectAtIndex:indexPath.row]];
        if (indexPath.row == 0) {
            NSString * price = [NSString stringWithFormat:@"￥%.2f",[[SoftManager shareSoftManager] getAllPrice:self.selectArray]];
            [cell refreshContentLB:price];
        }else if (indexPath.row == 2)
        {
            [cell resetContentLbColor:UIColorFromRGB(0x000000)];
        }else if (indexPath.row == 1)
        {
            NSString * point = [NSString stringWithFormat:@"%d",[[SoftManager shareSoftManager] getAllPoint:self.selectArray]];
            [cell refreshContentLB:point];
        }
        return cell;
    }else
    {
        PayModeSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kp_a_yModeSelectTableViewCellID forIndexPath:indexPath];
        [cell refreshUI];
        
        cell.p_a_yModeSelectBlock_cell = ^(p_a_yModeType p_a_ymodeType) {
            weakSelf.p_a_yModeType = p_a_ymodeType;
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else if(indexPath.section == 1)
    {
        return 80;
    }else if (indexPath.section == 2)
    {
        return 50;
    }
        
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        [weakSelf pushAddressVC];
    }
}

- (void)pushAddressVC
{
    AddressListViewController * addressVC = [[AddressListViewController alloc]init];
    addressVC.addressChooseBlock = ^(NSDictionary * _Nonnull info) {
        [UserManager sharedManager].currentSelectAddressInfo = info;
        [self.tableview reloadData];
    };
    addressVC.isFromOrderVC = YES;
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 5)];
    footerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    return footerView;
}


#pragma mark - selectAll delete buy
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
    float allPrice = [self getAllPrice:self.selectArray];
    [self.shoppingCarBottomView refreshPrice:@{@"price":@(allPrice)}];
}

- (float)getAllPrice:(NSArray *)selectArray
{
    if (selectArray.count == 0) {
        return 0.00;
    }else
    {
        float allPrice = 0.00;
        float allPoint = 0;
        for (NSDictionary * infoDic in selectArray) {
            float price = [[infoDic objectForKey:@"price"] doubleValue];
            int count = [[infoDic objectForKey:@"count"] intValue];
            int point = [[infoDic objectForKey:@"point"] intValue];
            allPrice += price * count;
            allPoint += point * count;
        }
        self.allInteger = allPoint;
        return allPrice;
    }
}


- (void)refreshAllPrice
{
    float allPrice = [[SoftManager shareSoftManager] getAllPrice:self.selectArray];
    [self.shoppingCarBottomView refreshPrice:@{@"price":@(allPrice)}];
    self.allPrice = allPrice;
}

- (void)deleteAction
{
    NSLog(@"delete");
}

- (void)buyAction
{
    if ([UserManager sharedManager].currentSelectAddressInfo == 0) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"您还未选择地址"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    NSArray * proList = [self getProList];
    
    int p_a_yment_id = 0;
    switch (self.p_a_yModeType) {
        case p_a_yModeType_yue:
            p_a_yment_id = 2;
            break;
        case p_a_yModeType_wechat:
            p_a_yment_id = 8;
            break;
        case p_a_yModeType_zhi_f_b:
            p_a_yment_id = 7;
            break;
            
        default:
            break;
    }
    
    [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{@"command":@14,@"address_id":[[UserManager sharedManager].currentSelectAddressInfo objectForKey:@"id"],@"remark":@"",@"p_a_yment_id":@(p_a_yment_id),@"is_invoice":@(0),@"pro_list":proList} withNotifiedObject:self];
    
    return;
}

- (NSArray *)getProList
{
    NSMutableArray * deleteArray = [NSMutableArray array];
    for (NSDictionary * info in self.selectArray) {
        NSMutableDictionary * mInfo = [NSMutableDictionary dictionary];
        [mInfo setObject:[info objectForKey:@"channel_id"] forKey:@"channel_id"];
        [mInfo setObject:[info objectForKey:@"article_id"] forKey:@"article_id"];
        [mInfo setObject:[info objectForKey:@"goods_id"] forKey:@"goods_id"];
        [mInfo setObject:@([[UserManager sharedManager] getUserId]) forKey:@"user_id"];
        [mInfo setObject:[info objectForKey:@"count"] forKey:@"quantity"];
        [deleteArray addObject:mInfo];
    }
    return deleteArray;
}

- (void)didRequestCreateOrderSuccessed
{
    [SVProgressHUD showSuccessWithStatus:@"下单成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [[UserManager sharedManager] completeUserInfoWithDic:@{@"command":@5} withNotifiedObject:self];
}

- (void)didRequestCreateOrderFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didCompleteUserSuccessed
{
    [self.tableview reloadData];
}

- (void)didCompleteUserFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
