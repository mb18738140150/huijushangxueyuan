//
//  OrderPayInfoTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "OrderPayInfoTableViewCell.h"

@implementation OrderPayInfoTableViewCell

-(void)refreshUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView removeAllSubviews];
    self.info = info;
    
    // 110
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_height - 10)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    UILabel * stateLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, backView.hd_width - 20, 15)];
    stateLB.text = @"订单信息";
    stateLB.textColor = UIColorFromRGB(0x111111);
    stateLB.font = [UIFont boldSystemFontOfSize:14];
    [backView addSubview:stateLB];
    
    UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(stateLB.frame), backView.hd_width - 20, 15)];
    nameLB.text = [NSString stringWithFormat:@"订单号码：%@", [info objectForKey:@"order_sn"]];
    nameLB.textColor = UIColorFromRGB(0x666666);
    nameLB.font = kMainFont;
    [backView addSubview:nameLB];
    
    UILabel * mobileLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(nameLB.frame), backView.hd_width - 20, 15)];
    mobileLB.text = [NSString stringWithFormat:@"下单时间：%@", [info objectForKey:@"pay_time"]];
    mobileLB.textColor = UIColorFromRGB(0x666666);
    mobileLB.font = kMainFont;
    [backView addSubview:mobileLB];
    
    UILabel * addressLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(mobileLB.frame), backView.hd_width - 20, 15)];
    addressLB.textColor = UIColorFromRGB(0x666666);
    addressLB.font = kMainFont;
    
    [backView addSubview:addressLB];
    
    if ([[info objectForKey:@"pay_type"] isEqualToString:@"wechat"]) {
        addressLB.text = [NSString stringWithFormat:@"支付方式：微信支付"];
    }else
    {
        addressLB.text = [NSString stringWithFormat:@"支付方式：支付宝支付"];
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
