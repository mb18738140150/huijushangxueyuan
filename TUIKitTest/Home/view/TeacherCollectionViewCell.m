//
//  TeacherCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "TeacherCollectionViewCell.h"

@implementation TeacherCollectionViewCell

- (void)refreshWithInfo:(NSDictionary*)info
{
    [self.contentView removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
//    70 + 46
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_width)];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[info objectForKey:@"avatar"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.iconImageView.layer.cornerRadius = kMainCornerRadius;
    self.iconImageView.layer.masksToBounds = YES;
    
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame) + 17, self.hd_width, 16.5)];
    self.titleLB.text = [info objectForKey:@"nickname"];
    self.titleLB.font = kMainFont_12;
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.titleLB];
}

@end
