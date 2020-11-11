//
//  OrderBottomTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/4.
//

#import "OrderBottomTableViewCell.h"

@implementation OrderBottomTableViewCell


- (void)refreshUIWith:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView removeAllSubviews];
    self.info = info;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.hd_width - 20, self.hd_height - 10)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = backView.bounds;
    layer.path = path.CGPath;
    [backView.layer setMask:layer];
    
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, backView.hd_width - 20, 40)];
    titleLB.textColor = UIColorFromRGB(0x333333);
    titleLB.font = kMainFont_12;
    NSString * str = @"";
    if ([[info objectForKey:@"buy_type"] intValue] == 1) {
        NSDictionary * shopInfo = [[[UserManager sharedManager] getStoreSettingInfo] objectForKey:@"shop"];
        str = [NSString stringWithFormat:@"实付款:￥%.2f(含运费:%.2f)", [[info objectForKey:@"pay_money"] floatValue],[[shopInfo objectForKey:@"freight"] floatValue]];
    }else
    {
        str = [NSString stringWithFormat:@"实付款:￥%.2f", [[info objectForKey:@"pay_money"] floatValue]];
    }
    titleLB.text = str;
    titleLB.textAlignment = NSTextAlignmentRight;
    [backView addSubview:titleLB];
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLB.frame), backView.hd_width - 20, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:seperateView];
    
    UIButton * stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stateBtn.frame = CGRectMake(backView.hd_width - 170, CGRectGetMaxY(seperateView.frame) + 15, 90, 30);
    stateBtn.layer.cornerRadius = stateBtn.hd_height / 2;
    stateBtn.layer.masksToBounds = YES;
    stateBtn.layer.borderWidth = 1;
    stateBtn.layer.borderColor = kCommonMainBlueColor.CGColor;
    [stateBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    stateBtn.titleLabel.font = kMainFont;
    [stateBtn setTitle:[self getOrderStateStr:info] forState:UIControlStateNormal];
    [backView addSubview:stateBtn];
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(backView.hd_width - 70,CGRectGetMaxY(seperateView.frame) + 15, 60, 30);
    deleteBtn.layer.cornerRadius = deleteBtn.hd_height / 2;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    [deleteBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = kMainFont;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [backView addSubview:deleteBtn];
    
    if ([stateBtn.titleLabel.text isEqualToString:@"待支付"]) {
        [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [stateBtn addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([stateBtn.titleLabel.text isEqualToString:@"查看订单详情"])
    {
        stateBtn.frame = CGRectMake(backView.hd_width - 120, CGRectGetMaxY(seperateView.frame) + 15, 110, 30);
        deleteBtn.hidden = YES;
        [stateBtn addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)deleteAction
{
    if (self.deleteBlock) {
        self.deleteBlock(self.info);
    }
}

- (void)stateAction:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"待支付"]) {
        if (self.buyBlock) {
            self.buyBlock(self.info);
        }
    }else if ([button.titleLabel.text isEqualToString:@"查看订单详情"])
    {
        if (self.detailBlock) {
            self.detailBlock(self.info);
        }
    }
}

- (NSString *)getOrderStateStr:(NSDictionary *)info
{
    // 支付状态 0:待支付 1:支付成功
    // 订单状态 0:待发货 1:已发货 2:已到货 3:退货
    
    if ([[info objectForKey:@"status"] isEqualToString:@"wait-payment"]) {
        return @"待支付";
    }
    return @"查看订单详情";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
