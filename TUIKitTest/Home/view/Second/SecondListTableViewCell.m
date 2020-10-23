//
//  SecondListTableViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "SecondListTableViewCell.h"

#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"
#import "UIUtility.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"
@implementation SecondListTableViewCell



- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.info = info;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    float cellWidth = self.hd_width;
    
    // 90
    CGFloat topSpace = 10;

    // teacher
    self.courseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, topSpace, 140, 70)];
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[info objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseImageView.layer.cornerRadius = kMainCornerRadius;
    self.courseImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.courseImageView];
    [self.courseImageView addSubview:self.payCountLabel];
    
    // 会员专属 228 69 41
    UILabel * hzuanshuLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 60, 15)];
    hzuanshuLB.backgroundColor = UIRGBColor(228, 69, 41);
    hzuanshuLB.font = kMainFont;
    hzuanshuLB.textColor = UIColorFromRGB(0xffffff);
    hzuanshuLB.textAlignment = NSTextAlignmentCenter;
    hzuanshuLB.text = @"会员专属";
    UIBezierPath * huiyuanPath = [UIBezierPath bezierPathWithRoundedRect:hzuanshuLB.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(7.5, 7.5)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = hzuanshuLB.bounds;
    layer.path = huiyuanPath.CGPath;
    [hzuanshuLB.layer setMask:layer];
    [self.courseImageView addSubview:self.courseChapterNameLabel];
    
    
    // 直播状态
    self.livingStateView = [[LivingStateView alloc]initWithFrame:CGRectMake(0, self.courseImageView.hd_height - 20, 100, 20)];
    [self.courseImageView addSubview:self.livingStateView];
    
    
    // 课程名称
    self.courseChapterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.courseImageView.frame) + 12, topSpace, self.hd_width - 185, 35)];
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
    
    if ([info objectForKey:@"type"]) {
        NSString * type = [info objectForKey:@"type"];
        if ([type isEqualToString:@"article"]) {
            self.livingStateView.livingState = HomeLivingStateType_imageAndText;
        }else if ([type isEqualToString:@"image"])
        {
            self.livingStateView.livingState = HomeLivingStateType_image;

        }else if ([type isEqualToString:@"audio"])
        {
            self.livingStateView.livingState = HomeLivingStateType_audio;

        }else if ([type isEqualToString:@"video"])
        {
            self.livingStateView.livingState = HomeLivingStateType_video;

        }
    }else if ([info objectForKey:@"topic_status"])
    {
        // topic_status 1.直播中 2.未开始 3.已结束
        int livingStatus = [[info objectForKey:@"topic_status"] intValue];
        switch (livingStatus) {
            case 1:
            {
                self.livingStateView.frame = CGRectMake(5, self.courseImageView.hd_height - 25, 100, 20);
                self.livingStateView.livingState = HomeLivingStateType_living;
                self.priceLabel.text = @"进入";
                self.priceLabel.textColor = UIRGBColor(110, 203, 139);
            }
                break;
            case 2:
            {
                self.livingStateView.livingState = HomeLivingStateType_noStart;
            }
                break;
            case 3:
            {
                self.livingStateView.livingState = HomeLivingStateType_end;
            }
                break;
                
            default:
                break;
        }
    }
    
    BOOL vip_exclusive = [[info objectForKey:@"vip_exclusive"] boolValue];
    if (vip_exclusive) {
        hzuanshuLB.hidden = NO;
        self.livingStateView.hidden = YES;
    }else
    {
        hzuanshuLB.hidden = YES;
        self.livingStateView.hidden = NO;
    }
    
}

- (NSString *)getOldStrWithSource1:(NSString *)str1 andSource2:(NSString *)str2
{
    if (str2.length == 0) {
        return [NSString stringWithFormat:@"￥%@", str1];
    }else
    {
        return [NSString stringWithFormat:@"￥%@ ￥%@", str1,str2];
    }
}

@end
