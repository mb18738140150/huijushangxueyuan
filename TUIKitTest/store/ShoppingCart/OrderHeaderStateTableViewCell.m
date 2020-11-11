//
//  OrderHeaderStateTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "OrderHeaderStateTableViewCell.h"

@interface OrderHeaderStateTableViewCell()


@end

@implementation OrderHeaderStateTableViewCell

-(void)refreshUIWithInfo:(NSDictionary *)info andOrderState:(OrderState)orderState
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView removeAllSubviews];
    self.info = info;
    
    if ([[info objectForKey:@"status"] isEqualToString:@"wait-payment"] || [[info objectForKey:@"status"] isEqualToString:@"shipped"]) {
        [self addNoPayView];
    }else if ( [[info objectForKey:@"status"] isEqualToString:@"wait-pick-up"])
    {
        /*
         待取货和已发货的时候显示 【确认收货】
            待取货的时候显示【 核销码】
         */
        
        [self addNoReciveView];
    }else
    {
        [self addStateLB];
    }
    
    
    
}

- (void)addStateLB
{
    // 40
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_height - 10)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    UILabel * stateLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backView.hd_width, backView.hd_height)];
    stateLB.text = [self getOrderStateStr:self.info];
    stateLB.textAlignment = NSTextAlignmentCenter;
    stateLB.textColor = UIColorFromRGB(0x111111);
    stateLB.font = [UIFont boldSystemFontOfSize:16];
    [backView addSubview:stateLB];
}

- (void)addNoPayView
{
    // 80
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_height - 10)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    UILabel * stateLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backView.hd_width, backView.hd_height / 2)];
    stateLB.text = @"待支付";
    stateLB.textAlignment = NSTextAlignmentCenter;
    stateLB.textColor = UIColorFromRGB(0x111111);
    stateLB.font = [UIFont boldSystemFontOfSize:16];
    [backView addSubview:stateLB];
    
    UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(backView.hd_width / 2 - 35, CGRectGetMaxY(stateLB.frame) + 5, 70, 25);
    payBtn.layer.cornerRadius = payBtn.hd_height / 2;
    payBtn.layer.masksToBounds = YES;
    payBtn.backgroundColor = kCommonMainBlueColor;
    [payBtn setTitle:@"继续支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    payBtn.titleLabel.font = kMainFont_12;
    [backView addSubview:payBtn];
    
    [payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ( [[self.info objectForKey:@"status"] isEqualToString:@"shipped"]) {
        stateLB.text = @"已发货";
        [payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }
}

- (void)addNoReciveView
{
    // 130
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_height - 10)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    UILabel * stateLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backView.hd_width, 40)];
    stateLB.text = @"待取货";
    stateLB.textAlignment = NSTextAlignmentCenter;
    stateLB.textColor = UIColorFromRGB(0x111111);
    stateLB.font = [UIFont boldSystemFontOfSize:16];
    [backView addSubview:stateLB];
    
    UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(backView.hd_width / 2 - 35, CGRectGetMaxY(stateLB.frame) + 5, 70, 25);
    payBtn.layer.cornerRadius = payBtn.hd_height / 2;
    payBtn.layer.masksToBounds = YES;
    payBtn.backgroundColor = kCommonMainBlueColor;
    [payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    [payBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    payBtn.titleLabel.font = kMainFont_12;
    [backView addSubview:payBtn];
    
    [payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * seperateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, backView.hd_width, 1)];
    seperateImageView.image = [UIImage imageNamed:@"ic_place_border"];
    [backView addSubview:seperateImageView];
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 20, 20)];
    leftView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    leftView.layer.cornerRadius = leftView.hd_height / 2;
    leftView.layer.masksToBounds = YES;
    [self.contentView addSubview:leftView];
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(self.hd_width - 20, 80, 20, 20)];
    rightView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    rightView.layer.cornerRadius = rightView.hd_height / 2;
    rightView.layer.masksToBounds = YES;
    [self.contentView addSubview:rightView];
    
    UILabel * codeLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(seperateImageView.frame) + 10, backView.hd_width, 30)];
    codeLB.text = [NSString stringWithFormat:@"核销码:%@",[UIUtility judgeStr:[self.info objectForKey:@"pick_up_code"]]];
    codeLB.textAlignment = NSTextAlignmentCenter;
    codeLB.textColor = UIColorFromRGB(0x111111);
    codeLB.font = [UIFont boldSystemFontOfSize:14];
    [backView addSubview:codeLB];
    
}

- (NSString *)getOrderStateStr:(NSDictionary *)info
{
    // 支付状态 0:待支付 1:支付成功
    // 订单状态 0:待发货 1:已发货 2:已到货 3:退货
    
    /*
     wait-payment    待付款
     completed    已完成
     refund    已退款
     wait-deliver-goods    待发货
     wait-take-over    待收货
     wait-pick-up    待取货
     shipped    已发货
     return-good    退货
     */
    
    if ([[info objectForKey:@"status"] isEqualToString:@"wait-payment"]) {
        return @"待支付";
    }else if([[info objectForKey:@"status"] isEqualToString:@"completed"])
    {
        return @"已完成";
    }else if([[info objectForKey:@"status"] isEqualToString:@"refund"])
    {
        return @"已退款";
    }else if([[info objectForKey:@"status"] isEqualToString:@"return-good"])
    {
        return @"退货";
    }else if([[info objectForKey:@"status"] isEqualToString:@"wait-deliver-goods"])
    {
        return @"待发货";
    }else if([[info objectForKey:@"status"] isEqualToString:@"wait-take-over"])
    {
        return @"待收货";
    }else if([[info objectForKey:@"status"] isEqualToString:@"shipped"])
    {
        return @"已发货";
    }
    else if([[info objectForKey:@"status"] isEqualToString:@"wait-pick-up"])
    {
        return @"待取货";
    }
    
    return @"";
}


- (void)payAction:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"继续支付"]) {
        if (self.buyBlock) {
            self.buyBlock(@{});
        }
    }else
    {
        if (self.complateBlock) {
            self.complateBlock(@{});
        }
    }
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
