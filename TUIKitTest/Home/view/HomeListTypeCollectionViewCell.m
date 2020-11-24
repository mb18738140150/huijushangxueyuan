//
//  HomeListTypeCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeListTypeCollectionViewCell.h"
#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"
#import "UIUtility.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"
@implementation HomeListTypeCollectionViewCell



- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    
    float cellWidth = self.hd_width;
    
    // 90
    CGFloat topSpace = 0;
    if (self.isOneCourse) {
        topSpace = 20;
    }
    // teacher
    self.courseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, topSpace, 140, 70)];
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[info objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseImageView.layer.cornerRadius = kMainCornerRadius;
    self.courseImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.courseImageView];
    [self.courseImageView addSubview:self.payCountLabel];
    
    // 直播状态
    self.livingStateView = [[LivingStateView alloc]initWithFrame:CGRectMake(0, self.courseImageView.hd_height - 20, 100, 20)];
    NSString * types = [info objectForKey:@"types"];
    if ([types isEqualToString:@"article"]) {
        self.livingStateView.livingState = HomeLivingStateType_imageAndText_right;
    }else if ([types isEqualToString:@"image"])
    {
        self.livingStateView.livingState = HomeLivingStateType_image_right;
    }else if ([types isEqualToString:@"audio"])
    {
        self.livingStateView.livingState = HomeLivingStateType_audio_right;
    }else if ([types isEqualToString:@"video"])
    {
        self.livingStateView.livingState = HomeLivingStateType_video_right;
    }
    [self.courseImageView addSubview:self.livingStateView];
    
    
    // 课程名称
    self.courseChapterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.courseImageView.frame) + 12, topSpace, self.hd_width - 185, 35)];
    self.courseChapterNameLabel.text = [info objectForKey:kCourseName];
    self.courseChapterNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.courseChapterNameLabel.numberOfLines = 0;
    self.courseChapterNameLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.courseChapterNameLabel];
    self.courseChapterNameLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"title"]];
    
    // 价格
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseChapterNameLabel.hd_x, CGRectGetMaxY(self.courseImageView.frame) - 20, 100, 20)];
    self.priceLabel.font = kMainFont;
    self.priceLabel.textColor = UIColorFromRGB(0xCCA95D);
    NSString * oldStr = [self getOldStrWithSource1:[NSString stringWithFormat:@"%@", [info objectForKey:@"show_paymoney"]] andSource2:[NSString stringWithFormat:@"%@", [info objectForKey:@"off_paymoney"]]];
    [self.contentView addSubview:self.priceLabel];
    
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    NSMutableAttributedString * NewStr = [[NSMutableAttributedString alloc]initWithString:oldStr];
    
    [NewStr addAttributes:attribute range:NSMakeRange([[NSString stringWithFormat:@"%@", [info objectForKey:@"show_paymoney"]] length]+ 1, oldStr.length - [[NSString stringWithFormat:@"%@", [info objectForKey:@"show_paymoney"]] length] - 1)];
    self.priceLabel.attributedText = NewStr;
    
    // 观看人数
    self.payCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 117.5, CGRectGetMaxY(self.courseImageView.frame) - 20, 100, 20)];
    self.payCountLabel.font = [UIFont systemFontOfSize:10];
    self.payCountLabel.textColor = UIColorFromRGB(0x999999);
    self.payCountLabel.text = [NSString stringWithFormat:@"%@人已看过", [info objectForKey:@"look_num"]];
    self.payCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.payCountLabel];
    
    
}

- (NSString *)getOldStrWithSource1:(NSString *)str1 andSource2:(NSString *)str2
{
    if (str2.length == 0) {
        return [NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, str1];
    }else
    {
        return [NSString stringWithFormat:@"%@%@ %@%@",[SoftManager shareSoftManager].coinName, str1,[SoftManager shareSoftManager].coinName,str2];
    }
}


@end
