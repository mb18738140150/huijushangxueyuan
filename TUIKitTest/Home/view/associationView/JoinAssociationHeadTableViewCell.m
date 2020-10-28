//
//  JoinAssociationHeadTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "JoinAssociationHeadTableViewCell.h"

@implementation JoinAssociationHeadTableViewCell

- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    float cellWidth = self.contentView.hd_width;
    
    // 100
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    // teacher
    self.groupIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.hd_width / 2 - 50, 15, 100, 100)];
    [self.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"logo"]] placeholderImage:[[UIImage imageNamed:@"courseDefaultImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
    self.groupIconImageView.layer.cornerRadius = kMainCornerRadius * 2;
    self.groupIconImageView.layer.masksToBounds = YES;
    [backView addSubview:self.groupIconImageView];
    
    // 课程名称
    self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_groupIconImageView.frame) + 15, backView.hd_width , 20)];
    self.courseNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.courseNameLabel.textColor = UIColorFromRGB(0x000000);
    self.courseNameLabel.text = [info objectForKey:@"title"];
    self.courseNameLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.courseNameLabel];
    
    // content
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseNameLabel.hd_x, CGRectGetMaxY(self.courseNameLabel.frame) + 10, self.courseNameLabel.hd_width , 20)];
    self.contentLabel.font = kMainFont_12;
    self.contentLabel.textColor = UIColorFromRGB(0x999999);
    self.contentLabel.text = [NSString stringWithFormat:@"%@人加入",[info objectForKey:@"user_num"]];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.contentLabel];
    
    
    NSString * descStr = [info objectForKey:@"desc"]!= nil ? [info objectForKey:@"desc"] : @"jurbfiuebfieubfoienof;enofneopfihewopigvneorignvpeormpv'eomvp'elamv'peomnrpv[jepove";
    self.descLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) + 10, self.courseNameLabel.hd_width- 20 , 30)];
    self.descLB.font = kMainFont_12;
    self.descLB.textColor = UIColorFromRGB(0x333333);
    self.descLB.text = descStr;
    self.descLB.numberOfLines = 0;
    self.descLB.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.descLB];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(backView.hd_width / 2 - 60, CGRectGetMaxY(_descLB.frame) + 10, 120, 30);
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderColor = kCommonMainBlueColor.CGColor;
    _cancelBtn.layer.borderWidth = 1;
    [self.cancelBtn setTitle:@"邀请好友加入" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = kMainFont;
    
    [self.cancelBtn addTarget:self action:@selector(cancelOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.cancelBtn];
    
//    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(10, 79, backView.hd_width - 30, 1)];
//    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    [backView addSubview:separateView];
    
}
    
- (void)cancelOrderAction
{
    if (self.activeBlock) {
        self.activeBlock();
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
