//
//  AddressEditViewController.m
//  lanhailieren
//
//  Created by aaa on 2020/3/6.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "AddressEditViewController.h"
#import "EditAddressTableViewCell.h"
#define kEditAddressTableViewCellID @"kEditAddressTableViewCellID"
#import "BTAreaPickViewController.h"
#import "UIAlertController+Core.h"
#import "YAddressPickerView.h"

@interface AddressEditViewController ()<UITableViewDelegate,UITableViewDataSource,BTAreaPickViewControllerDelegate,UserModule_EditAddressProtocol,AddressViewDelegate,UserModule_DeleteAddressProtocol>

@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, strong)NSMutableArray * dataSource_moren;

@property (nonatomic, strong)UIButton * addAddressBtn;

@property (nonatomic, assign)BOOL isMoren;

@property (nonatomic, strong)NSString * nameStr;
@property (nonatomic, strong)NSString * phoneStr;
//@property (nonatomic, strong)NSString * provinceStr;
//@property (nonatomic, strong)NSString * cityStr;
@property (nonatomic, strong)NSString * areaStr;
@property (nonatomic, strong)NSString * addressStr;
@property (nonatomic, strong) YAddressPickerView *addView;
@end

@implementation AddressEditViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)dataSource_moren
{
    if (!_dataSource_moren) {
        _dataSource_moren = [NSMutableArray array];
    }
    return _dataSource_moren;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    [self loadData];
    [self refreshUI_iPhone];
}
- (void)loadData
{
    if (self.infoDic) {
        self.isMoren = [[self.infoDic objectForKey:@"defaulted"] intValue];
        self.nameStr = [self.infoDic objectForKey:@"username"];
        NSDictionary * nameInfo = @{@"title":@"姓名",@"content":[self.infoDic objectForKey:@"username"],@"placeholder":@(0)};
        NSDictionary  * phoneNumberInfo = @{@"title":@"手机号",@"content":[self.infoDic objectForKey:@"mobile"],@"placeholder":@(0)};
        self.phoneStr = [self.infoDic objectForKey:@"mobile"];
        
        NSDictionary  * addressInfo = @{@"title":@"地址",@"content":[NSString stringWithFormat:@"%@", [self.infoDic objectForKey:@"area"]],@"placeholder":@(0)};
//        self.provinceStr = [self.infoDic objectForKey:@"province"];
//        self.cityStr = [self.infoDic objectForKey:@"city"];
        self.areaStr = [self.infoDic objectForKey:@"area"];
        
        NSDictionary  * addressDetailInfo = @{@"title":@"详细地址",@"content":[self.infoDic objectForKey:@"address"],@"placeholder":@(0)};
        self.addressStr = [self.infoDic objectForKey:@"address"];
        
        [self.dataSource addObject:nameInfo];
        [self.dataSource addObject:phoneNumberInfo];
        [self.dataSource addObject:addressInfo];
        [self.dataSource addObject:addressDetailInfo];
        
        NSDictionary  * morenInfo = @{@"title":@"设置默认地址",@"content":@""};
        NSDictionary  * deleteInfo = @{@"title":@"删除此收货地址",@"content":@""};
        [self.dataSource_moren addObject:morenInfo];
//        [self.dataSource_moren addObject:deleteInfo];
        return;
    }
    
    NSDictionary * nameInfo = @{@"title":@"姓名:",@"content":@"请填写姓名",@"placeholder":@(1)};
    NSDictionary  * phoneNumberInfo = @{@"title":@"手机号:",@"content":@"请填写手机号",@"placeholder":@(1)};
    NSDictionary  * addressInfo = @{@"title":@"地址:",@"content":@"请选择",@"placeholder":@(1)};
    NSDictionary  * addressDetailInfo = @{@"title":@"详细地址:",@"content":@"请填写详细地址",@"placeholder":@(1)};
    
    [self.dataSource addObject:nameInfo];
    [self.dataSource addObject:phoneNumberInfo];
    [self.dataSource addObject:addressInfo];
    [self.dataSource addObject:addressDetailInfo];
    
    NSDictionary  * morenInfo = @{@"title":@"设置默认地址",@"content":@""};
    NSDictionary  * deleteInfo = @{@"title":@"删除此收货地址",@"content":@""};
    [self.dataSource_moren addObject:morenInfo];
//    [self.dataSource_moren addObject:deleteInfo];
}


- (void)navigationViewSetup
{
    self.navigationItem.title = @"我的地址";
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

- (void)refreshUI_iPhone
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[EditAddressTableViewCell class] forCellReuseIdentifier:kEditAddressTableViewCellID];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.tableview];
    
}

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.dataSource_moren.count;
        if (self.infoDic == nil) {
            return 1;
        }else{
            return 2;
        }
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kEditAddressTableViewCellID forIndexPath:indexPath];
    
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        [cell refreshUIWith:[self.dataSource objectAtIndex:indexPath.row]];
        if (indexPath.row == 2) {
            if (self.areaStr.length > 0) {
                [cell refreshUIWith:@{@"title":@"地址",@"content":[NSString stringWithFormat:@"%@",self.areaStr],@"placeholder":@(0)}];
            }
            [cell chooceAddress];
            cell.addressBlock = ^(NSDictionary *info) {
                NSLog(@"选择地址");
                [weakSelf chooceAddress];
            };
            
        }
        
        __weak typeof(self)weakSelf = self;
        if (indexPath.row == 0) {
            cell.contentTF.text = self.nameStr;
            cell.textBlock = ^(NSString *str) {
                weakSelf.nameStr = str;
            };
        }else if (indexPath.row == 1){
            cell.contentTF.text = self.phoneStr;
            cell.textBlock = ^(NSString *str) {
                weakSelf.phoneStr = str;
            };
        }else if (indexPath.row == 3)
        {
            cell.contentTF.text = self.addressStr;
            cell.textBlock = ^(NSString *str) {
                weakSelf.addressStr = str;
            };
        }
        
        
        
    }else{
        [cell refreshUIWith:[self.dataSource_moren objectAtIndex:indexPath.row]];
        cell.contentTF.enabled = NO;
        if (indexPath.row == 0) {
            [cell setMorenAction:self.isMoren];
            cell.morenBlock = ^(NSDictionary *info) {
                weakSelf.isMoren = !weakSelf.isMoren;
                [weakSelf.tableview reloadData];
                NSLog(@"设为默认地址");
            };
        }else
        {
            [cell setDeleteAction];
        }
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }else
    {
        return 75;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableview.hd_width, 6)];
        view.backgroundColor = UIColorFromRGB(0xf5f5f5);
        
        return view;
    }else
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableview.hd_width, 75)];
        view.backgroundColor = UIColorFromRGB(0xf5f5f5);
        
        UIButton * complateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        complateBtn.frame = CGRectMake(view.hd_width / 2 - 100, 25, 200, 30);
        complateBtn.layer.cornerRadius = 4;
        complateBtn.layer.masksToBounds = YES;
        complateBtn.backgroundColor = kCommonMainBlueColor;
        [complateBtn setTitle:@"保存地址" forState:UIControlStateNormal];
        [complateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:complateBtn];
        [complateBtn addTarget:self action:@selector(storeAddress) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            self.isMoren = !self.isMoren;
            [self.tableview reloadData];
        }else
        {
            NSLog(@"deleteAddress");
            [SVProgressHUD show];
            [[UserManager sharedManager] didRequestDeleteAddressWithCourseInfo:@{@"command":@29,@"id":[self.infoDic objectForKey:@"id"]} withNotifiedObject:self];
        }
    }
}


- (void)storeAddress
{
    NSLog(@"保存地址");
    if (self.nameStr.length == 0 || self.phoneStr.length == 0 || self.areaStr.length == 0 || self.addressStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"姓名、手机号与地址均不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
//    if (self.phoneStr.length != 11) {
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
//        return;
//    }
    
    int is_default = 0;
    if (self.isMoren) {
        is_default = 1;
    }
    
    [SVProgressHUD show];
    if (self.infoDic) {
        
        [[UserManager sharedManager] editAddressWithDic:@{kUrlName:@"api/shop/address/update",@"username":self.nameStr,@"defaulted":@(is_default),@"mobile":self.phoneStr,@"area":self.areaStr,@"address":self.addressStr,@"address_id":[self.infoDic objectForKey:@"id"]} withNotifiedObject:self];
    }else
    {
        [[UserManager sharedManager] editAddressWithDic:@{kUrlName:@"api/shop/address/create",@"username":self.nameStr,@"defaulted":@(is_default),@"mobile":self.phoneStr,@"area":self.areaStr,@"address":self.addressStr} withNotifiedObject:self];
    }
    
}

- (void)didEditAddressSuccessed
{
    [SVProgressHUD dismiss];
    if (self.editAddressSuccessBlock) {
        self.editAddressSuccessBlock(@{});
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didEditAddressFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestDeleteAddressSuccessed
{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.deleteAddressSuccessBlock) {
        self.deleteAddressSuccessBlock(@{});
    }
}

- (void)didRequestDeleteAddressFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


- (void)chooceAddress
{
//    __weak typeof(self)weakSelf = self;
    _addView = [[YAddressPickerView alloc]init];
    [self.view addSubview:_addView];
    _addView.delegate = self;
    [_addView show];
    return;
    NSLog(@"选择地址");
    BTAreaPickViewController * vc = [[BTAreaPickViewController alloc]initWithDragDismissEnabal:YES];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - BTAreaPickViewControllerDelegate

- (void)completingTheSelection:(NSString *)province city:(NSString *)city area:(NSString *)area{
    
    NSString * str  = [NSString stringWithFormat:@"%@%@%@",province,city,area];

    self.areaStr = str;
    NSLog(@"%@", str);
    [self.tableview reloadData];
}

- (void)areaPickerView:(BTAreaPickViewController *)areaPickerView doneAreaModel:(BTAreaPickViewModel *)model{
    
//    self.provinceStr = model.selectedProvince.name;
//    self.cityStr = model.selectedCitie.name;
    NSString * str  = [NSString stringWithFormat:@"%@%@%@",model.selectedProvince.name,model.selectedCitie.name,model.selectedArea.name];
    self.areaStr = str;
    NSLog(@"doneAreaModel %@",model.description);
}

@end
