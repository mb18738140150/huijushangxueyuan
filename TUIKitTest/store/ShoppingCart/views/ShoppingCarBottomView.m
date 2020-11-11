//
//  ShoppingCarBottomView.m
//  lanhailieren
//
//  Created by aaa on 2020/3/10.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ShoppingCarBottomView.h"

@implementation ShoppingCarBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andBuy:(BOOL)buy
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareBuyUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andFoodIntroduce:(BOOL)introduce
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareIntroduceUI];
    }
    return self;
}


- (void)prepareUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(10, self.hd_height / 2 - 7, 45, 15);
    [selectBtn setImage:[UIImage imageNamed:@"shoppingCar_selected"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"shoppingCar_unselected"] forState:UIControlStateNormal];
    [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectBtn.titleLabel.font = kMainFont_16;
    [selectBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.selectAllBtn = selectBtn;
    [selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:selectBtn];
    
    UILabel *priceLB = [[UILabel alloc]initWithFrame:CGRectMake( 15,self.selectAllBtn.hd_y , 200, 15)];
    priceLB.textColor = UIColorFromRGB(0x999999);
    priceLB.font = kMainFont;
    [self addSubview:priceLB];
    self.priceLabel = priceLB;
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(self.hd_width - 203, 0, 100, self.hd_height);
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.deleteBtn.backgroundColor = UIColorFromRGB(0xe72222);
    self.deleteBtn.titleLabel.font = kMainFont_16;
    [self addSubview:self.deleteBtn];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = CGRectMake(self.hd_width - 100, 0, 100, self.hd_height);
    [self.buyBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.buyBtn.backgroundColor = kCommonMainBlueColor;
    self.buyBtn.titleLabel.font = kMainFont;
    [self addSubview:self.buyBtn];
    
    [self.deleteBtn addTarget:self action:@selector(delectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)prepareBuyUI
{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *priceLB = [[UILabel alloc]initWithFrame:CGRectMake(15,self.hd_height / 2 - 10 , self.hd_width - 140, 20)];
    priceLB.textColor = UIColorFromRGB(0x333333);
    priceLB.font = [UIFont boldSystemFontOfSize:16];
    priceLB.textAlignment = NSTextAlignmentRight;
    [self addSubview:priceLB];
    self.priceLabel = priceLB;
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = CGRectMake(self.hd_width - 100, 5, 90, self.hd_height - 10);
    [self.buyBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.buyBtn.backgroundColor = kCommonMainBlueColor;
    self.buyBtn.titleLabel.font = kMainFont;
    self.buyBtn.layer.cornerRadius = 5;
    self.buyBtn.layer.masksToBounds = YES;
    [self addSubview:self.buyBtn];
    
    [self.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)prepareIntroduceUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(10, self.hd_height / 2 - 12, 25, 25);
    [selectBtn setImage:[UIImage imageNamed:@"ic_car_bottom"] forState:UIControlStateNormal];
    selectBtn.titleLabel.font = kMainFont_16;
    [selectBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.selectAllBtn = selectBtn;
    [selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
    
    self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectAllBtn.frame) - 7, self.selectAllBtn.hd_y - 7, 15, 15)];
    self.countLB.backgroundColor = UIColorFromRGB(0xbf0008);
    self.countLB.layer.cornerRadius = self.countLB.hd_width / 2;
    self.countLB.layer.masksToBounds = YES;
    self.countLB.font = [UIFont systemFontOfSize:7];
    self.countLB.textColor = UIColorFromRGB(0xffffff);
    self.countLB.textAlignment = NSTextAlignmentCenter;
    self.countLB.text = @"0";
    [self addSubview:self.countLB];
    
    UILabel *priceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectAllBtn.frame) + 15,self.selectAllBtn.hd_y , 200, 15)];
    priceLB.textColor = kCommonMainBlueColor;
    priceLB.font = kMainFont_16;
    priceLB.text = @"￥";
    [self addSubview:priceLB];
    self.priceLabel = priceLB;
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(self.hd_width - 200, 0, 100, self.hd_height);
    [self.deleteBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.deleteBtn.backgroundColor = UIColorFromRGB(0x37A2F5);
    self.deleteBtn.titleLabel.font = kMainFont;
    [self addSubview:self.deleteBtn];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = CGRectMake(self.hd_width - 100, 0, 100, self.hd_height);
    [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.buyBtn.backgroundColor = UIColorFromRGB(0x287DDD);
    self.buyBtn.titleLabel.font = kMainFont;
    [self addSubview:self.buyBtn];
    
    [self.deleteBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectAction
{
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    if (self.selectAllBlock) {
        self.selectAllBlock(self.selectAllBtn.selected);
    }
}

- (void)addAction
{
    if (self.addShoppingCarBlock) {
        self.addShoppingCarBlock(@{});
    }
}


- (void)delectAction
{
    NSLog(@"delete__bottom");
    if (self.deleteShoppingCarBlock) {
        self.deleteShoppingCarBlock(@{});
    }
}

- (void)buyAction
{
    NSLog(@"buy__bottom");
    if (self.buyShoppingCarBlock) {
        self.buyShoppingCarBlock(@{});
    }
}

- (void)refreshPrice:(NSDictionary *)infoDic
{
    NSLog(@"refreshPrice");
    NSString * str  = [NSString stringWithFormat:@"共%@件 合计：%@元",[infoDic objectForKey:@"count"], [infoDic objectForKey:@"price"]];
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:kCommonMainBlueColor};
    [mStr setAttributes:attribute range:NSMakeRange(str.length - [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"price"]] length] - 1, [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"price"]] length])];
    self.priceLabel.attributedText = mStr;
    
}

- (void)refreshGoodPrice:(NSDictionary *)infoDic
{
    self.priceLabel.text = [NSString stringWithFormat:@"合计：￥ %@", [infoDic objectForKey:@"price"]];
}
- (void)refreshTotalCount
{
    int count = [[[UserManager sharedManager] getShoppingCarList] count];
    self.countLB.text = [NSString stringWithFormat:@"%d", count];
}

- (void)refreshEditState:(BOOL)isEditing
{
    if (isEditing) {
        self.deleteBtn.hidden = NO;
        self.buyBtn.enabled = NO;
    }else
    {
        self.deleteBtn.hidden = YES;
        self.buyBtn.enabled = YES;
    }
}

@end
