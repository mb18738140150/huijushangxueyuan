//
//  HomePublicNumberCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomePublicNumberCollectionViewCell.h"

@interface HomePublicNumberCollectionViewCell()



@end

@implementation HomePublicNumberCollectionViewCell
- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.infoDic = info;
    float cellWidth = self.contentView.hd_width;
    
    // 84
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 0, self.hd_width - 35, 64)];
    backView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    backView.layer.cornerRadius = kMainCornerRadius * 2;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    // teacher
    self.teacherIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [self.teacherIconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"logo"]] placeholderImage:[[UIImage imageNamed:@"img_km0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
    self.teacherIconImageView.layer.cornerRadius = self.teacherIconImageView.hd_height / 2;
    self.teacherIconImageView.layer.masksToBounds = YES;
    [backView addSubview:self.teacherIconImageView];
    
    // 课程名称
    
    self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherIconImageView.frame) + 10, 12, backView.hd_width - 134, 20)];
    self.courseNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.courseNameLabel.textColor = kMainTextColor;
    self.courseNameLabel.text = [info objectForKey:@"name"];
    [backView addSubview:self.courseNameLabel];
    
    // content
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseNameLabel.hd_x, CGRectGetMaxY(self.courseNameLabel.frame) + 5, self.courseNameLabel.hd_width - 30, 16.5)];
    self.contentLabel.font = kMainFont_12;
    self.contentLabel.textColor = UIColorFromRGB(0x999999);
    self.contentLabel.text = [UIUtility judgeStr:[info objectForKey:@"desc"]];
    [backView addSubview:self.contentLabel];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(backView.hd_width - 70, 20, 54, 24);
    [self.cancelBtn setTitle:@"关注" forState:UIControlStateNormal];
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
    if (self.attentionBlock) {
        self.attentionBlock(self.infoDic);
    }
}


@end
