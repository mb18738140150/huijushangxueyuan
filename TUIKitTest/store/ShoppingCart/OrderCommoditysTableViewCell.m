//
//  OrderCommoditysTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "OrderCommoditysTableViewCell.h"

@implementation OrderCommoditysTableViewCell
-(void)refreshUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView removeAllSubviews];
    self.info = info;
    
    // 150
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.hd_width - 20, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
    
    UILabel * mobileLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 , backView.hd_width - 20, 20)];
    mobileLB.textColor = kCommonMainBlueColor;
    mobileLB.font = [UIFont boldSystemFontOfSize:14];
    mobileLB.textAlignment = NSTextAlignmentRight;
    [backView addSubview:mobileLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(mobileLB.frame) + 10, backView.hd_width - 20, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
    UILabel * addressLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 + CGRectGetMaxY(separateView.frame), backView.hd_width - 20, 20)];
    addressLB.textColor = kCommonMainBlueColor;
    addressLB.font = [UIFont boldSystemFontOfSize:14];
    addressLB.textAlignment = NSTextAlignmentRight;
    [backView addSubview:addressLB];
    
    
    NSString * hejiStr = [NSString stringWithFormat:@"合计：%@", [info objectForKey:@"pay_money"]];
    NSMutableAttributedString * mHejiStr = [[NSMutableAttributedString alloc]initWithString:hejiStr];
    [mHejiStr addAttributes:attribute range:NSMakeRange(0, 3)];
    mobileLB.attributedText = mHejiStr;
    
    NSString * actualStr = [NSString stringWithFormat:@"实际支付：%@", [info objectForKey:@"pay_money"]];
    NSMutableAttributedString * mactualStr = [[NSMutableAttributedString alloc]initWithString:actualStr];
    [mactualStr addAttributes:attribute range:NSMakeRange(0, 5)];
    addressLB.attributedText = mactualStr;
    if ([[info objectForKey:@"buy_type"] intValue] == 2) {
        addressLB.hidden = YES;
        separateView.hidden = YES;
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
