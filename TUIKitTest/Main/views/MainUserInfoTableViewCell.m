//
//  MainUserInfoTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import "MainUserInfoTableViewCell.h"

@implementation MainUserInfoTableViewCell

- (void)resetUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    // 72 + 20 + 15
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12.5, 20, 72, 72)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:kUserHeaderImageUrl]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_centerY - 10, 200, 20)];
    self.titleLB.font = [UIFont systemFontOfSize:18];
    self.titleLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:kUserNickName]];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.titleLB];
    
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
