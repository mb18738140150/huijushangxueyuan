//
//  LivingShareListTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import "LivingShareListTableViewCell.h"

@implementation LivingShareListTableViewCell

- (void)resetUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    // 64
    NSDictionary * userInfo = [info objectForKey:@"from"];
    
    self.numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numberBtn.frame = CGRectMake(15, 20, 24, 24);
    [self.numberBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    self.numberBtn.titleLabel.font = kMainFont;
    [self.contentView addSubview:self.numberBtn];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.numberBtn.frame) + 10, 10, 44, 44)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    [self.contentView addSubview:self.iconImageView];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_centerY - 10, 150, 20)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.text = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"nickname"]];
    [self.contentView addSubview:self.titleLB];
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 150, self.titleLB.hd_y, 120, 20)];
    self.contentLB.textColor = UIColorFromRGB(0x333333);
    self.contentLB.font = kMainFont;
    self.contentLB.textAlignment = NSTextAlignmentRight;
    NSString * str = [NSString stringWithFormat:@"邀请%@人", [info objectForKey:@"count"]];
    NSDictionary * attribute = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mStr setAttributes:attribute range:NSMakeRange(2, str.length - 3)];
    self.contentLB.attributedText = mStr;
    
    [self.contentView addSubview:self.contentLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(10, 63, kScreenWidth - 20, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:separateView];
}

- (void)setSort:(int)sort
{
    [self.numberBtn setTitle:[NSString stringWithFormat:@"%d", sort] forState:UIControlStateNormal];
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
