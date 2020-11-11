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
#import "MKPPlaceholderTextView.h"
#import "AddressListViewController.h"
#import "BuySenfTypeView.h"
#import "OrderListViewController.h"

@interface ConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UserModule_CreateOrderProtocol,UserModule_CompleteUserInfoProtocol,UserModule_StoreSetting,UITextFieldDelegate,UserModule_MockVIPBuy, UserModule_MockPartnerBuy,UserModule_PayOrderProtocol>

@property (nonatomic, strong)UITableView * tableview;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, strong)ShoppingCarBottomView * shoppingCarBottomView;
@property (nonatomic, assign)p_a_yModeType p_a_yModeType;

@property (nonatomic, assign)float allPrice;
@property (nonatomic, assign)float allInteger;

@property (nonatomic, strong)MKPPlaceholderTextView * textView;

@property (nonatomic, strong)NSDictionary * shopInfo;
@property (nonatomic, strong)BuySenfTypeView * buySenfTypeView;

@property (nonatomic, assign)int buy_type;
@property (nonatomic, strong)UITextField *tihuoName;

@property (nonatomic, strong)UITextField * tihuoMobile;

@property (nonatomic, strong)NSDictionary * zitiInfo;

@property (nonatomic, assign)BOOL isWechat;
@property (nonatomic, strong)ShareAndPaySelectView * payView;
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
    self.buy_type = 1;
    [self loadData];
    [self navigationViewSetup];
    
    [self refreshUI_iPhone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payClick:) name:kNotificationOfShareAndPay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccedsss:) name:kNotificationOfBuyCourseSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailed:) name:kNotificationOfBuyCoursefailed object:nil];
}


- (void)loadData
{
    self.shopInfo = [[[UserManager sharedManager] getStoreSettingInfo] objectForKey:@"shop"];
    if (self.shopInfo == nil) {
        [[UserManager sharedManager] didRequestStoreSettingWithWithDic:@{kUrlName:@"api/custom/setting",kRequestType:@"get"} withNotifiedObject:self];
    }
    NSMutableDictionary * priceInfo = [[NSMutableDictionary alloc]initWithDictionary:@{@"title":@"配送方式",@"tip":@"500g，现杀",@"content":@"商家配送",@"count":@"2",@"id":@"1"}];;
    NSMutableDictionary  * integerInfo = [[NSMutableDictionary alloc]initWithDictionary:@{@"title":@"配送费",@"tip":@"800g，现杀",@"content":[NSString stringWithFormat:@"%@", [self.shopInfo objectForKey:@"freight"]],@"count":@"2",@"id":@"2"}];;
    [self.dataSource addObject:priceInfo];
    [self.dataSource addObject:integerInfo];
    
    [[UserManager sharedManager] didRequestMockVIPBuyWithInfo:@{kUrlName:@"api/shop/address/pickedUp",kRequestType:@"get"} withNotifiedObject:self];
    [[UserManager sharedManager]didRequestMockPartnerBuyWithInfo:@{kUrlName:@"api/shop/address/defaulted",kRequestType:@"get"} withNotifiedObject:self];
    
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
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.tableview];
    
    
    self.shoppingCarBottomView = [[ShoppingCarBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50- kNavigationBarHeight - kStatusBarHeight, kScreenWidth, 50) andBuy:YES];
    [self.view addSubview:self.shoppingCarBottomView];
    __weak typeof(self)weakSelf = self;
    self.shoppingCarBottomView.buyShoppingCarBlock = ^(NSDictionary *info) {
        [weakSelf buyAction];
    };
    
    
    self.buySenfTypeView = [[BuySenfTypeView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 30) andArray:@[@"商家配送",@"到店自提"] andMainColor:kCommonMainBlueColor];
    self.buySenfTypeView.btnSelectBlock = ^(NSInteger index) {
        NSMutableDictionary * mInfo = [weakSelf.dataSource objectAtIndex:0];
        if (index == 0) {
            [mInfo setValue:@"商家配送" forKey:@"content"];
            weakSelf.buy_type = 1;
        }else
        {
            [mInfo setValue:@"自提" forKey:@"content"];
            weakSelf.buy_type = 2;
        }
        [weakSelf.tableview reloadData];
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
                return 2;
            }
            break;
        case 1:
        {
            return self.selectArray.count;
        }
            break;
        case 2:
        {
            if (self.buySenfTypeView.index == 1) {
                return self.dataSource.count - 1;
            }
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
        if (indexPath.row == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
            [cell.contentView removeAllSubviews];
            [cell.contentView addSubview:self.buySenfTypeView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.hd_height - 1, cell.hd_width , 1)];
            separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
            [cell.contentView addSubview:separateView];
            
            return cell;
        }
        
        if (self.buySenfTypeView.index) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
            [cell.contentView removeAllSubviews];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 50, 40)];
            nameLB.text = @"提货人";
            nameLB.font = kMainFont_16;
            nameLB.textColor = UIColorFromRGB(0x333333);
            [cell.contentView addSubview:nameLB];
            
            self.tihuoName = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLB.frame) + 15, 0, 200, 40)];
            _tihuoName.placeholder = @"请输入提货人姓名";
            _tihuoName.text = [UIUtility judgeStr:[self.zitiInfo objectForKey:@"username"]];
            _tihuoName.font = kMainFont;
            _tihuoName.textColor = UIColorFromRGB(0x333333);
            [cell.contentView addSubview:_tihuoName];
            
            UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(15, 40, cell.hd_width - 30, 1)];
            separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
            [cell.contentView addSubview:separateView];
            
            UILabel * mobileLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 41, 50, 40)];
            mobileLB.text = @"手机号";
            mobileLB.font = kMainFont_16;
            mobileLB.textColor = UIColorFromRGB(0x333333);
            [cell.contentView addSubview:mobileLB];
            
            self.tihuoMobile = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mobileLB.frame) + 15, 41, 200, 40)];
            _tihuoMobile.placeholder = @"请输入提货人手机号";
            _tihuoMobile.text = [UIUtility judgeStr:[self.zitiInfo objectForKey:@"mobile"]];
            _tihuoMobile.font = kMainFont;
            _tihuoMobile.textColor = UIColorFromRGB(0x333333);
            [cell.contentView addSubview:_tihuoMobile];
            
            _tihuoMobile.delegate = self;
            _tihuoMobile.returnKeyType = UIReturnKeyDone;
            _tihuoName.delegate = self;
            _tihuoName.returnKeyType = UIReturnKeyDone;
            
            UIImageView * seperateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, cell.contentView.hd_height - 3, cell.contentView.hd_width, 3)];
            seperateImageView.image = [UIImage imageNamed:@"ic_place_border"];
            [cell.contentView addSubview:seperateImageView];
            seperateImageView.hidden = YES;
            
            return cell;
        }
        AddressListTableViewCell * headCell = [tableView dequeueReusableCellWithIdentifier:kAddressListTableViewCellID forIndexPath:indexPath];
        headCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [headCell refreshConfirmOrderUIWithInfo:[UserManager sharedManager].currentSelectAddressInfo];
        [headCell showSeperateImageView];
        return headCell;
    }else if (indexPath.section == 1)
    {
        ShoppingCarListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kShoppingCarListTableViewCellID forIndexPath:indexPath];
        
        [cell refreshUIWithInfo:[self.selectArray objectAtIndex:indexPath.row] isCanSelect:NO];
        
        return cell;
    }else if (indexPath.section == 2)
    {
        ConfirmOrderInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kConfirmOrderInfoTableViewCellID forIndexPath:indexPath];
        [cell refreshUI:[self.dataSource objectAtIndex:indexPath.row]];
        return cell;
    }else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        [cell.contentView removeAllSubviews];
        self.textView = [[MKPPlaceholderTextView alloc]init];
        _textView.placeholder = @"买家留言";
        _textView.frame = CGRectMake(15, 15, kScreenWidth - 30, 60);
        _textView.font = kMainFont_12;
        _textView.placeholderColor = UIColorFromRGB(0x666666);
        [_textView resetPlaceholderLabel];
        [_textView setPlaceholderTextAlignment:NSTextAlignmentCenter];
        _textView.returnKeyType = UIReturnKeySend;
        [cell.contentView addSubview:_textView];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[self.shopInfo objectForKey:@"picked_up"] boolValue]) {
                return 50;
            }
            return 0;
        }
        return 80;
    }else if(indexPath.section == 1)
    {
        return 80;
    }else if (indexPath.section == 2)
    {
        return 50;
    }
        
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textView resignFirstResponder];
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [weakSelf pushAddressVC];
        }
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
    if (section == 2 || section == 3) {
        return 0;
    }
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.hd_width, 5)];
    footerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
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
    [self.shoppingCarBottomView refreshGoodPrice:@{@"price":[NSString stringWithFormat:@"%.2f", allPrice]}];
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
    [self.shoppingCarBottomView refreshGoodPrice:@{@"price":[NSString stringWithFormat:@"%.2f", allPrice]}];
    self.allPrice = allPrice;
}

- (void)deleteAction
{
    NSLog(@"delete");
}



- (NSString *)getProList
{
    NSMutableArray * deleteArray = [NSMutableArray array];
    for (NSDictionary * info in self.selectArray) {
        
        [deleteArray addObject:[info objectForKey:@"id"]];
    }
    return [deleteArray componentsJoinedByString:@","];
}

#pragma mark - creatOrder

- (void)payFailed:(NSNotification *)notification
    {
        OrderListViewController * vc = [[OrderListViewController alloc]init];
        vc.cateId = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }

- (void)buyAction
{
    
    NSString * cart_ids = [self getProList];
    NSDictionary * addressInfo = [UserManager sharedManager].currentSelectAddressInfo;
    
    if (self.buySenfTypeView.index == 0) {
        if ([UserManager sharedManager].currentSelectAddressInfo == 0) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"您还未选择地址"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        
    }else
    {
        if (self.tihuoName.text.length == 0 || self.tihuoMobile.text.length == 0) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"提货人姓名电话不能为空"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
    }
   
    ShareAndPaySelectView * payView = [[ShareAndPaySelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andIsShare:NO];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:payView];
    self.payView = payView;
    
    return;
}

- (void)paySuccedsss:(NSNotification *)notification
{
    OrderListViewController * vc = [[OrderListViewController alloc]init];
    vc.cateId = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)payClick:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.object;
    [self.payView removeFromSuperview];
    
    NSString * cart_ids = [self getProList];
    NSDictionary * addressInfo = [UserManager sharedManager].currentSelectAddressInfo;
    
    if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_wechatPay) {
        NSLog(@"微信支付");
        self.isWechat = YES;
        [SVProgressHUD show];
        if (self.buySenfTypeView.index == 0) {
            [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{kUrlName:@"api/shop/order/create",@"cart_ids":cart_ids,@"buy_type":@(1),@"buy_name":[UIUtility judgeStr:[addressInfo objectForKey:@"username"]],@"buy_phone":[UIUtility judgeStr:[addressInfo objectForKey:@"mobile"]],@"buy_address":[NSString stringWithFormat:@"%@%@", [addressInfo objectForKey:@"area"],[addressInfo objectForKey:@"address"]],@"buyer_message":[UIUtility judgeStr:self.textView.text],@"pay_type":@"wechat"} withNotifiedObject:self];
        }else
        {
            [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{kUrlName:@"api/shop/order/create",@"cart_ids":cart_ids,@"buy_type":@(2),@"buy_name":[UIUtility judgeStr:[addressInfo objectForKey:@"username"]],@"buy_phone":[UIUtility judgeStr:[addressInfo objectForKey:@"mobile"]],@"buyer_message":[UIUtility judgeStr:self.textView.text],@"pay_type":@"wechat"} withNotifiedObject:self];
        }
        
    }else if ([[infoDic objectForKey:kCourseCategoryId] intValue] == CategoryType_zhifubPay)
    {
        self.isWechat = NO;
        NSLog(@"支付宝支付");
        [SVProgressHUD show];
        
        if (self.buySenfTypeView.index == 0) {
            [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{kUrlName:@"api/shop/order/create",@"cart_ids":cart_ids,@"buy_type":@(1),@"buy_name":[UIUtility judgeStr:[addressInfo objectForKey:@"username"]],@"buy_phone":[UIUtility judgeStr:[addressInfo objectForKey:@"mobile"]],@"buy_address":[NSString stringWithFormat:@"%@%@", [addressInfo objectForKey:@"area"],[addressInfo objectForKey:@"address"]],@"buyer_message":[UIUtility judgeStr:self.textView.text],@"pay_type":@"alipay"} withNotifiedObject:self];
        }else
        {
            [[UserManager sharedManager] didRequestCreateOrderWithCourseInfo:@{kUrlName:@"api/shop/order/create",@"cart_ids":cart_ids,@"buy_type":@(2),@"buy_name":[UIUtility judgeStr:[addressInfo objectForKey:@"username"]],@"buy_phone":[UIUtility judgeStr:[addressInfo objectForKey:@"mobile"]],@"buyer_message":[UIUtility judgeStr:self.textView.text],@"pay_type":@"alipay"} withNotifiedObject:self];
        }
    }
}

- (void)didRequestCreateOrderSuccessed
{
    [SVProgressHUD showSuccessWithStatus:@"下单成功"];
    [SVProgressHUD dismiss];
    NSDictionary * info = [[UserManager sharedManager] getCreateOrderInfo];
    
    if (self.isWechat) {
        [self weichatPay:[info objectForKey:@"wechat"]];
    }else
    {
        [self alipay:[info objectForKey:@"alipay"]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestCreateOrderFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestPayOrderSuccessed
{
    [SVProgressHUD dismiss];
    NSDictionary * info = [[UserManager sharedManager]getPayOrderInfo];
    if (_isWechat) {
        [self weichatPay:[info objectForKey:@"wechat"]];
    }else
    {
        [self alipay:[info objectForKey:@"alipay"]];
    }
}

- (void)weichatPay:(NSDictionary *)info
{
NSDictionary * dict = info;
NSMutableString *stamp  = [dict objectForKey:@"timestamp"];

//调起微信支付
PayReq* req             = [[PayReq alloc] init];
req.openID              = [dict objectForKey:@"appid"];
req.partnerId           = [dict objectForKey:@"partnerid"];
req.prepayId            = [dict objectForKey:@"prepayid"];
req.nonceStr            = [dict objectForKey:@"noncestr"];
req.timeStamp           = stamp.intValue;
req.package             = [dict objectForKey:@"package"];
req.sign                = [dict objectForKey:@"sign"];
[WXApi sendReq:req completion:nil];

}

- (void)alipay:(NSString *)url
{
[[AlipaySDK defaultService] payOrder:url fromScheme:@"huijushangxueyuan" callback:^(NSDictionary *resultDic) {
    NSLog(@"%@",resultDic);
    NSString *str = resultDic[@"memo"];
    [SVProgressHUD showErrorWithStatus:str];
    
    NSString *resultStatus = resultDic[@"resultStatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfBuyCourseSuccess object:nil];
    switch (resultStatus.integerValue) {
        case 9000:// 成功
            NSLog(@"支付成功");
            break;
        case 6001:// 取消
            NSLog(@"用户中途取消");
            break;
        default:
            NSLog(@"支付失败");
            break;
    }
    
}];

}

- (void)didRequestPayOrderFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [self.tableview.mj_header endRefreshing];
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

- (void)didStoreSettingSuccessed
{
    [SVProgressHUD dismiss];
    self.shopInfo = [[[UserManager sharedManager] getStoreSettingInfo] objectForKey:@"shop"];
    
    [self.dataSource removeAllObjects];
    NSMutableDictionary * priceInfo = [[NSMutableDictionary alloc]initWithDictionary:@{@"title":@"配送方式",@"tip":@"500g，现杀",@"content":@"商家配送",@"count":@"2",@"id":@"1"}];;
    NSMutableDictionary  * integerInfo = [[NSMutableDictionary alloc]initWithDictionary:@{@"title":@"配送费",@"tip":@"800g，现杀",@"content":[NSString stringWithFormat:@"%@", [self.shopInfo objectForKey:@"freight"]],@"count":@"2",@"id":@"2"}];;
    [self.dataSource addObject:priceInfo];
    [self.dataSource addObject:integerInfo];
    
    [self.tableview reloadData];
}

- (void)didStoreSettingFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestMockVIPBuySuccessed
{
    [SVProgressHUD dismiss];
    self.zitiInfo = [[UserManager sharedManager] getVIPBuyInfo];
    [self.tableview reloadData];
}

- (void)didRequestMockPartnerBuyFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didRequestMockPartnerBuySuccessed
{
    [SVProgressHUD dismiss];
    [UserManager sharedManager].currentSelectAddressInfo = [[UserManager sharedManager] getPartnerBuyInfo];
    [self.tableview reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
