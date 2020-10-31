//
//  AssociationAdminInfoTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import "AssociationAdminInfoTableViewCell.h"

@interface AssociationAdminInfoTableViewCell()


@end

@implementation AssociationAdminInfoTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, self.hd_height - 20, self.hd_height - 20)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    [self.contentView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, 200, self.hd_height - 20)];
    label.text = [infoDic objectForKey:@"c_name"];
    label.textColor = UIColorFromRGB(0x333333);
    label.font = kMainFont;
    [self.contentView addSubview:label];
    
    NSString * zanStr = @"前往主页";
    NSMutableAttributedString * mZanStr = [[NSMutableAttributedString alloc]initWithString:@"前往主页"];
    NSDictionary * zanAttribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:kCommonMainBlueColor};
    [mZanStr addAttributes:zanAttribute range:NSMakeRange(0, mZanStr.length)];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth - 100, 0, 80, self.hd_height);
    [button setImage:[UIImage imageNamed:@"living_编组3"] forState:UIControlStateNormal];
    [button setTitle:@"前往主页" forState:UIControlStateNormal];
    button.titleLabel.font = kMainFont;
    [button setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, -60);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    [self.contentView addSubview:button];
    [button addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goAction{
    if (self.joinBlock) {
        self.joinBlock(@{});
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
