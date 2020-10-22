//
//  payModeSelectView.m
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "PayModeSelectView.h"

@implementation PayModeSelectView

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
    self.zhi_f_bView = [[PayModeView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, 40)];
    [self.zhi_f_bView refreshContentWithModeImage:[UIImage imageNamed:@"zhifubao"] andModeStr:@"支付宝支付" andSelectNomalImage:[UIImage imageNamed:@"shoppingCar_unselected"] andSelect_selectesImage:[UIImage imageNamed:@"shoppingCar_selected"]];
    [self addSubview:self.zhi_f_bView];
    
    self.wechatView = [[PayModeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.zhi_f_bView.frame), self.hd_width, 40)];
    [self.wechatView refreshContentWithModeImage:[UIImage imageNamed:@"weixinzhifu"] andModeStr:@"微信支付" andSelectNomalImage:[UIImage imageNamed:@"shoppingCar_unselected"] andSelect_selectesImage:[UIImage imageNamed:@"shoppingCar_selected"]];
    [self addSubview:self.wechatView];
    
    self.yueView = [[PayModeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wechatView.frame), self.hd_width, 40)];
    NSString * str = [NSString stringWithFormat:@"%@", [[[UserManager sharedManager] getUserInfos] objectForKey:kAmount]];
    NSString * yueStr = [NSString stringWithFormat:@"余额支_付(余额%@元)", str];
    
    NSMutableAttributedString * yueStr_m = [[NSMutableAttributedString alloc]initWithString:yueStr];
    NSDictionary * attribute = @{NSForegroundColorAttributeName:kCommonMainBlueColor};
    [yueStr_m addAttributes:attribute range:NSMakeRange(4, yueStr.length - 4)];
    
    [self.yueView refreshContentWithModeImage:[UIImage imageNamed:@""] andModeAttributeStr:yueStr_m andSelectNomalImage:[UIImage imageNamed:@"shoppingCar_unselected"] andSelect_selectesImage:[UIImage imageNamed:@"shoppingCar_selected"]];
//    [self addSubview:self.yueView];
    
    self.zhi_f_bView.selectStateBtn.selected = YES;
    
    [self.zhi_f_bView.backBtn addTarget:self action:@selector(zhi_f_bSelectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatView.backBtn addTarget:self action:@selector(wechatSelectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.yueView.backBtn addTarget:self action:@selector(yueSelectAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)zhi_f_bSelectAction
{
    self.zhi_f_bView.selectStateBtn.selected = YES;
    self.wechatView.selectStateBtn.selected = NO;
    self.yueView.selectStateBtn.selected = NO;
    if (self.p_a_yModeSelectBlock) {
        self.p_a_yModeSelectBlock(p_a_yModeType_zhi_f_b);
    }
}

- (void)wechatSelectAction
{
    self.zhi_f_bView.selectStateBtn.selected = NO;
    self.wechatView.selectStateBtn.selected = YES;
    self.yueView.selectStateBtn.selected = NO;
    if (self.p_a_yModeSelectBlock) {
        self.p_a_yModeSelectBlock(p_a_yModeType_wechat);
    }
}

- (void)yueSelectAction
{
    self.zhi_f_bView.selectStateBtn.selected = NO;
    self.wechatView.selectStateBtn.selected = NO;
    self.yueView.selectStateBtn.selected = YES;
    if (self.p_a_yModeSelectBlock) {
        self.p_a_yModeSelectBlock(p_a_yModeType_yue);
    }
}

@end
