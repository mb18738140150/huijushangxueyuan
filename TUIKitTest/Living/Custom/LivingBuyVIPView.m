//
//  LivingBuyVIPView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import "LivingBuyVIPView.h"

@interface LivingBuyVIPView()

@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIView * shutupView;
@property (nonatomic, strong)UIView * buyVIPOperationView;
@property (nonatomic, strong)UIView * buyHeHuoRenOperationView;

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * priceLB;

@property (nonatomic, strong)UIImageView * VIPSelectImageView;
@property (nonatomic, strong)UIImageView * heHuoRenSelectImageView;


@property (nonatomic, strong)UIButton * cancelBtn;
@property (nonatomic, strong)UIButton * payBtn;
@property (nonatomic, strong)UISwitch * switch1;
@property (nonatomic, assign)BOOL isVIP;

@end

@implementation LivingBuyVIPView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
    [backView addGestureRecognizer:tap];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 300, kScreenWidth, 300)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 20)];
    self.titleLB.text = @"会员购买";
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:self.titleLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame) + 10, kScreenWidth, 20)];
    self.priceLB.text = @"￥ 399.00";
    self.priceLB.textColor = UIColorFromRGB(0x000000);
    self.priceLB.font = [UIFont boldSystemFontOfSize:17];
    self.priceLB.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:self.priceLB];
    
    
    UIView * listView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.priceLB.frame) + 15, kScreenWidth - 20, 160)];
    listView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    listView.layer.cornerRadius = 5;
    listView.layer.masksToBounds = YES;
    [contentView addSubview:listView];
    
    // VIP view
    UIView * vipView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, listView.hd_width - 20, 60)];
    vipView.backgroundColor = UIColorFromRGB(0xffffff);
    vipView.layer.cornerRadius = 5;
    vipView.layer.masksToBounds = YES;
    [listView addSubview:vipView];
    
    UILabel * vipTitleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 150, 15)];
    vipTitleLB.text = @"VIP学员";
    vipTitleLB.textColor = UIColorFromRGB(0x333333);
    vipTitleLB.font = kMainFont;
    [vipView addSubview:vipTitleLB];
    
    
    UILabel * vipPriceLB = [[UILabel alloc]initWithFrame:CGRectMake(20, vipView.hd_height - 20, 150, 15)];
    vipPriceLB.text = @"￥ 399.00";
    vipPriceLB.textColor = UIRGBColor(245, 161, 150);
    vipPriceLB.font = kMainFont;
    [vipView addSubview:vipPriceLB];
    
    self.VIPSelectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(vipView.hd_width - 32, vipView.hd_height / 2 - 6, 12, 12)];
    [vipView addSubview:self.VIPSelectImageView];
    
    // hehuoren
    UIView * heView = [[UIView alloc]initWithFrame:CGRectMake(10, 80, listView.hd_width - 20, 60)];
    heView.backgroundColor = UIColorFromRGB(0xffffff);
    heView.layer.cornerRadius = 5;
    heView.layer.masksToBounds = YES;
    [listView addSubview:heView];
    
    UILabel * heTitleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 150, 15)];
    heTitleLB.text = @"合伙人";
    heTitleLB.textColor = UIColorFromRGB(0x333333);
    heTitleLB.font = kMainFont;
    [heView addSubview:heTitleLB];
    
    
    UILabel * hePriceLB = [[UILabel alloc]initWithFrame:CGRectMake(20, heView.hd_height - 20, 150, 15)];
    hePriceLB.text = @"￥ 4999.00";
    hePriceLB.textColor = UIRGBColor(245, 161, 150);
    hePriceLB.font = kMainFont;
    [heView addSubview:hePriceLB];
    
    self.heHuoRenSelectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(heView.hd_width - 32, heView.hd_height / 2 - 6, 12, 12)];
    [heView addSubview:self.heHuoRenSelectImageView];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(listView.frame) + 10, kScreenWidth, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [contentView addSubview:separateView];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(10, CGRectGetMaxY(separateView.frame) + 10, kScreenWidth / 2 - 15, 40);
    self.cancelBtn.backgroundColor = UIRGBColor(35, 121, 238);
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = kMainFont;
    [contentView addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.frame = CGRectMake(kScreenWidth / 2 + 5, CGRectGetMaxY(separateView.frame) + 10, kScreenWidth / 2 - 15, 40);
    self.payBtn.backgroundColor = UIRGBColor(35, 121, 238);
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.masksToBounds = YES;
    [self.payBtn setTitle:@"确认购买" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = kMainFont;
    [contentView addSubview:self.payBtn];
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addShutUpView];
    
    [self addBuyVIPOperationView];
    
    [self addBuyHeHuoRenOperationView];
}

- (void)addShutUpView
{
    UIView * shutupView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 120, kScreenWidth, 120)];
    shutupView.backgroundColor = [UIColor whiteColor];
    self.shutupView = shutupView;
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    titleLB.backgroundColor = [UIColor whiteColor];
    titleLB.text = @"操作设置";
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = UIColorFromRGB(0x999999);
    titleLB.font = kMainFont_16;
    [shutupView addSubview:titleLB];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(shutupView.hd_width - 25, 0, 25, 25);
    closeBtn.backgroundColor = [UIColor whiteColor];
    [closeBtn setImage:[UIImage imageNamed:@"living_guanbi"] forState:UIControlStateNormal];
    [shutupView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [shutupView addSubview:separateView];
    
    UILabel * shutUpLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(separateView.frame), 100, shutupView.hd_height - CGRectGetMaxY(separateView.frame))];
    shutUpLB.text = @"禁言";
    shutUpLB.backgroundColor = [UIColor whiteColor];
    shutUpLB.textColor = UIColorFromRGB(0x333333);
    shutUpLB.font = kMainFont_16;
    [shutupView addSubview:shutUpLB];
    
    UISwitch * switch1 = [[UISwitch alloc] init];
    switch1.frame = CGRectMake(kScreenWidth - 100, 65, 100, 130);
    //其实设置了宽100 高130 也没用，因为它有一个默认的大小
    switch1.on = YES;  //设置默认为开，改变它的状态就设置这个属性就可以
    [shutupView addSubview:switch1];
    switch1.onTintColor = [UIColor blueColor]; //开关状态为开的时候左侧颜色

    [switch1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    self.switch1 = switch1;

    
    [self addSubview:shutupView];
}

- (void)addBuyVIPOperationView
{
    self.buyVIPOperationView = [[UIView alloc]initWithFrame:CGRectMake(20, kScreenHeight / 2 - 60, kScreenWidth - 40, 120)];
    self.buyVIPOperationView.backgroundColor = UIColorFromRGB(0xffffff);
    self.buyVIPOperationView.layer.cornerRadius = 5;
    self.buyVIPOperationView.layer.masksToBounds = YES;
    [self addSubview:self.buyVIPOperationView];
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.buyVIPOperationView.hd_width, 20)];
    titleLB.text = @"提示";
    titleLB.textColor = UIColorFromRGB(0x000000);
    titleLB.font = [UIFont boldSystemFontOfSize:17];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [_buyVIPOperationView addSubview:titleLB];
    
    UILabel * contentLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLB.frame) + 10, titleLB.hd_width, 20)];
    contentLB.text = @"确定模拟VIP购买吗？";
    contentLB.textColor = UIColorFromRGB(0x333333);
    contentLB.font = kMainFont;
    contentLB.textAlignment = NSTextAlignmentCenter;
    [_buyVIPOperationView addSubview:contentLB];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, CGRectGetMaxY(contentLB.frame) + 10, titleLB.hd_width / 2 - 20, 40);
    cancelBtn.backgroundColor = UIColorFromRGB(0xf2f2f2);
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kMainFont;
    [cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [_buyVIPOperationView addSubview:cancelBtn];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(_buyVIPOperationView.hd_width / 2 + 10, CGRectGetMaxY(contentLB.frame) + 10, titleLB.hd_width / 2 - 20, 40);
    sureBtn.backgroundColor = UIColorFromRGB(0x2A75ED);
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = kMainFont;
    [sureBtn addTarget:self action:@selector(buyVIPOperationAction) forControlEvents:UIControlEventTouchUpInside];
    [_buyVIPOperationView addSubview:sureBtn];
}

- (void)addBuyHeHuoRenOperationView
{
    self.buyHeHuoRenOperationView = [[UIView alloc]initWithFrame:CGRectMake(20, kScreenHeight / 2 - 60, kScreenWidth - 40, 120)];
    self.buyHeHuoRenOperationView.backgroundColor = UIColorFromRGB(0xffffff);
    self.buyHeHuoRenOperationView.layer.cornerRadius = 5;
    self.buyHeHuoRenOperationView.layer.masksToBounds = YES;
    [self addSubview:self.buyHeHuoRenOperationView];
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.buyVIPOperationView.hd_width, 20)];
    titleLB.text = @"提示";
    titleLB.textColor = UIColorFromRGB(0x000000);
    titleLB.font = [UIFont boldSystemFontOfSize:17];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [_buyHeHuoRenOperationView addSubview:titleLB];
    
    UILabel * contentLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLB.frame) + 10, titleLB.hd_width, 20)];
    contentLB.text = @"确定模拟合伙人购买吗？";
    contentLB.textColor = UIColorFromRGB(0x333333);
    contentLB.font = kMainFont;
    contentLB.textAlignment = NSTextAlignmentCenter;
    [_buyHeHuoRenOperationView addSubview:contentLB];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, CGRectGetMaxY(contentLB.frame) + 10, titleLB.hd_width / 2 - 20, 40);
    cancelBtn.backgroundColor = UIColorFromRGB(0xf2f2f2);
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kMainFont;
    [cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [_buyHeHuoRenOperationView addSubview:cancelBtn];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(_buyVIPOperationView.hd_width / 2 + 10, CGRectGetMaxY(contentLB.frame) + 10, titleLB.hd_width / 2 - 20, 40);
    sureBtn.backgroundColor = UIColorFromRGB(0x2A75ED);
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = kMainFont;
    [sureBtn addTarget:self action:@selector(buyHeHuoRenOperationAction) forControlEvents:UIControlEventTouchUpInside];
    [_buyHeHuoRenOperationView addSubview:sureBtn];
}

- (void) switchAction:(UISwitch *) s1 {
    if (s1.on == YES) {
        NSLog(@"开");
    }else{
        NSLog(@"关");
    }
    
    if (self.ShutupBlock) {
        self.ShutupBlock(s1.on);
    }
}

- (void)resetShutupWithNojuristic
{
    self.switch1.on = !self.switch1.on;
}


- (void)dismissAction
{
    [self removeFromSuperview];
}

- (void)payAction
{
    if (self.VIPPayBlock) {
        if (self.isVIP) {
            self.VIPPayBlock(@{@"price":@(399.00)});
        }else
        {
            self.VIPPayBlock(@{@"price":@(4999.00)});
        }
    }
}

- (void)buyVIPOperationAction
{
    if (self.buyVIPOperationBlock) {
        self.buyVIPOperationBlock(@{});
    }
    [self removeFromSuperview];
}

- (void)buyHeHuoRenOperationAction
{
    if (self.buyHeHuoRenOperationBlock) {
        self.buyHeHuoRenOperationBlock(@{});
    }
    [self removeFromSuperview];
}

- (void)showShutUpViewInView:(UIView *)view andIsSHutup:(BOOL)isShutup
{
    self.contentView.hidden = YES;
    self.shutupView.hidden = NO;
    self.buyVIPOperationView.hidden = YES;
    self.buyHeHuoRenOperationView.hidden = YES;
    
    self.switch1.on = isShutup;
    [view addSubview:self];
}

- (void)showInView:(UIView *)view andIsVIP:(BOOL)isVIP
{
    self.contentView.hidden = NO;
    self.shutupView.hidden = YES;
    self.buyVIPOperationView.hidden = YES;
    self.buyHeHuoRenOperationView.hidden = YES;
    
    self.isVIP = isVIP;
    [view addSubview:self];
    if (isVIP) {
        self.VIPSelectImageView.image = [UIImage imageNamed:@"huiyuan-2"];
        self.heHuoRenSelectImageView.image = [UIImage imageNamed:@"search"];
        self.priceLB.text = @"￥ 399.00";
    }else
    {
        self.VIPSelectImageView.image = [UIImage imageNamed:@"search"];
        self.heHuoRenSelectImageView.image = [UIImage imageNamed:@"huiyuan-2"];
        self.priceLB.text = @"￥ 4999.00";
    }
    
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(0, kScreenHeight - 300, kScreenWidth, 300);
    }];
    
}

- (void)showBuyVIPViewInView:(UIView *)view{
    self.contentView.hidden = YES;
    self.shutupView.hidden = YES;
    self.buyVIPOperationView.hidden = NO;
    self.buyHeHuoRenOperationView.hidden = YES;
    
    [view addSubview:self];
}
- (void)showBuyHeHuoRenViewInView:(UIView *)view
{
    self.contentView.hidden = YES;
    self.shutupView.hidden = YES;
    self.buyVIPOperationView.hidden = YES;
    self.buyHeHuoRenOperationView.hidden = NO;
    
    [view addSubview:self];
}

@end
