//
//  HomeCommunityCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeCommunityCollectionViewCell.h"

@implementation HomeCommunityCollectionViewCell

- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];

    float cellWidth = self.contentView.hd_width;
    
    // 100
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 0, self.hd_width - 35, 80)];
    backView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    backView.layer.cornerRadius = kMainCornerRadius;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    // teacher
    self.groupIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [self.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"logo"]] placeholderImage:[[UIImage imageNamed:@"img_km0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
    self.groupIconImageView.layer.cornerRadius = kMainCornerRadius * 2;
    self.groupIconImageView.layer.masksToBounds = YES;
    [backView addSubview:self.groupIconImageView];
    
    // 课程名称
    
    self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.groupIconImageView.frame) + 15, 15.5, backView.hd_width - 165, 22.5)];
    self.courseNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.courseNameLabel.textColor = kMainTextColor;
    self.courseNameLabel.text = [info objectForKey:@"title"];
    [backView addSubview:self.courseNameLabel];
    
    // content
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseNameLabel.hd_x, CGRectGetMaxY(self.courseNameLabel.frame) + 10, self.courseNameLabel.hd_width , 16.5)];
    self.contentLabel.font = kMainFont_12;
    self.contentLabel.textColor = UIColorFromRGB(0x999999);
    self.contentLabel.text = [NSString stringWithFormat:@"%@人  %@条动态",[info objectForKey:@"user_num"], [info objectForKey:@"dynamic_num"]];
    [backView addSubview:self.contentLabel];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(backView.hd_width - 85, 26, 70, 28);
    [self.cancelBtn setTitle:@"立即加入" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = kMainFont_12;
    [self.cancelBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    
    self.cancelBtn.layer.cornerRadius = self.cancelBtn.hd_height / 2;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.backgroundColor = UIColorFromRGB(0x2A75ED);
    
    [self.cancelBtn addTarget:self action:@selector(cancelOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.cancelBtn];
}
    
- (void)cancelOrderAction
{
    if (self.cancelOrderLivingCourseBlock) {
        self.cancelOrderLivingCourseBlock(@{});
    }
}

@end
