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
    UILabel * hzuanshuLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 55, 15)];
    hzuanshuLB.backgroundColor = UIRGBColor(228, 69, 41);
    hzuanshuLB.font = kMainFont_12;
    hzuanshuLB.textColor = UIColorFromRGB(0xffffff);
    hzuanshuLB.textAlignment = NSTextAlignmentCenter;
    hzuanshuLB.text = @"会员专属";
    UIBezierPath * huiyuanPath = [UIBezierPath bezierPathWithRoundedRect:hzuanshuLB.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(7.5, 7.5)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = hzuanshuLB.bounds;
    layer.path = huiyuanPath.CGPath;
    [hzuanshuLB.layer setMask:layer];
    [self.courseImageView addSubview:hzuanshuLB];
    
    if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled])
    {
        
    }else
    {
        hzuanshuLB.hidden = YES;
    }
    
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
    
    
    BOOL vip_exclusive = [[info objectForKey:@"vip_exclusive"] boolValue];
    if (vip_exclusive) {
        hzuanshuLB.hidden = NO;
        self.livingStateView.hidden = YES;
        self.priceLabel.textColor = UIColorFromRGB(0xCCA95D);
        self.priceLabel.attributedText = NewStr;
    }else
    {
        hzuanshuLB.hidden = YES;
        self.livingStateView.hidden = NO;
    }
    
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
    }else if ([info objectForKey:@"topic_style"])
    {
        int topic_style = [[info objectForKey:@"topic_style"] intValue];
        // topic_style 为1 或者2 时候才显示直播状态
        if (topic_style == 1 || topic_style == 2) {
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
        }else
        {
            self.livingStateView.frame = CGRectMake(5, self.courseImageView.hd_height - 25, 100, 20);
            self.livingStateView.livingState = HomeLivingStateType_living;
            self.priceLabel.text = @"进入";
            self.priceLabel.textColor = UIRGBColor(110, 203, 139);
            self.livingStateView.hidden = YES;
        }
        
    }
    
}


- (void)resetPromotionCellContent:(NSDictionary *)info
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
    UILabel * hzuanshuLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 55, 15)];
    hzuanshuLB.backgroundColor = UIRGBColor(228, 69, 41);
    hzuanshuLB.font = kMainFont_12;
    hzuanshuLB.textColor = UIColorFromRGB(0xffffff);
    hzuanshuLB.textAlignment = NSTextAlignmentCenter;
    hzuanshuLB.text = @"会员专属";
    UIBezierPath * huiyuanPath = [UIBezierPath bezierPathWithRoundedRect:hzuanshuLB.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(7.5, 7.5)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = hzuanshuLB.bounds;
    layer.path = huiyuanPath.CGPath;
    [hzuanshuLB.layer setMask:layer];
//    [self.courseImageView addSubview:hzuanshuLB];
    
    if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled])
    {
        
    }else
    {
        hzuanshuLB.hidden = YES;
    }
    
    // 直播状态
    self.livingStateView = [[LivingStateView alloc]initWithFrame:CGRectMake(0, self.courseImageView.hd_height - 20, 100, 20)];
    [self.courseImageView addSubview:self.livingStateView];
    
    
    // 课程名称
    self.courseChapterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.courseImageView.frame) + 12, topSpace, self.hd_width - 185, 20)];
    self.courseChapterNameLabel.font = kMainFont;
    self.courseChapterNameLabel.numberOfLines = 0;
    self.courseChapterNameLabel.textColor = UIColorFromRGB(0x666666);
    [self.contentView addSubview:self.courseChapterNameLabel];
    self.courseChapterNameLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"title"]];
    
    // 价格
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseChapterNameLabel.hd_x, CGRectGetMaxY(self.courseChapterNameLabel.frame), 100, 20)];
    self.priceLabel.font = [UIFont boldSystemFontOfSize:12];
    self.priceLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.priceLabel];
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, [info objectForKey:@"show_paymoney"]];
    
    
    // 返佣label
    NSString * comeStr = [NSString stringWithFormat:@"最高可获佣金:"];
    CGFloat width = [comeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.width;
    
    UILabel* payCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(_courseChapterNameLabel.hd_x, CGRectGetMaxY(self.courseImageView.frame) - 20, width + 5, 20)];
    payCountLabel.font = kMainFont_12;
    payCountLabel.textAlignment = NSTextAlignmentCenter;
    payCountLabel.textColor = UIRGBColor(149, 128, 106);
    [self.contentView addSubview:payCountLabel];
    
    CALayer *comeGradientLayer = [CALayer layer];
    comeGradientLayer.frame = payCountLabel.bounds;
    
    CAGradientLayer * comeGradientLayer1 = [CAGradientLayer layer];
    comeGradientLayer1.frame = payCountLabel.bounds;// UIRGBColor(237, 233, 225)
    [comeGradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIRGBColor(254, 247, 239) CGColor],(id)[UIRGBColor(237, 233, 225) CGColor], nil]];
    [comeGradientLayer1 setLocations:@[@0, @0.5, @1]];
    [comeGradientLayer1 setStartPoint:CGPointMake(0, 0.5)];
    [comeGradientLayer1 setEndPoint:CGPointMake(1, 0.5)];
    [comeGradientLayer addSublayer:comeGradientLayer1];
    [payCountLabel.layer addSublayer:comeGradientLayer];
    
    UIBezierPath * bezierParth = [UIBezierPath bezierPathWithRoundedRect:payCountLabel.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = payCountLabel.bounds;
    shapLayer.path = bezierParth.CGPath;
    [payCountLabel.layer setMask:shapLayer];
    payCountLabel.layer.borderColor = UIRGBColor(74, 44, 16).CGColor;
    payCountLabel.layer.borderWidth = 1;
    payCountLabel.text = comeStr;
    
    
    NSString * moneyStr = [NSString stringWithFormat:@"%@%@", [SoftManager shareSoftManager].coinName,[info objectForKey:@"divide_money"]];
    CGFloat width1 = [moneyStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.width;
    self.payCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(payCountLabel.frame) - 1, payCountLabel.hd_y, width1 + 5, payCountLabel.hd_height)];
    _payCountLabel.backgroundColor = UIRGBColor(74, 44, 16);
    _payCountLabel.text = moneyStr;
    _payCountLabel.textColor = UIColorFromRGB(0xffffff);
    _payCountLabel.font = kMainFont_12;
    _payCountLabel.textAlignment = NSTextAlignmentCenter;

    UIBezierPath * bezierParth1 = [UIBezierPath bezierPathWithRoundedRect:_payCountLabel.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer * shapLayer1 = [[CAShapeLayer alloc]init];
    shapLayer1.frame = _payCountLabel.bounds;
    shapLayer1.path = bezierParth1.CGPath;
    [_payCountLabel.layer setMask:shapLayer1];
    [self.contentView addSubview:_payCountLabel];
    
    // 推广btn
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(self.contentView.hd_width - 77.5, CGRectGetMaxY(self.courseImageView.frame)  - 30, 60, 30);
    
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.applyBtn.bounds;
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.applyBtn.bounds;
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0xEBD5C0) CGColor],(id)[UIColorFromRGB(0xDBB293) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0, @0.5, @1]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0.5)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 0.5)];
    [gradientLayer addSublayer:gradientLayer1];
    [self.applyBtn.layer addSublayer:gradientLayer];
    
    [self.applyBtn setTitle:@"推广" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0x55310A) forState:UIControlStateNormal];
    self.applyBtn.layer.cornerRadius = self.applyBtn.hd_height / 2;
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.titleLabel.font = kMainFont_12;
    [self.contentView addSubview:self.applyBtn];
    
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
//    BOOL vip_exclusive = [[info objectForKey:@"vip_exclusive"] boolValue];
//    if (vip_exclusive) {
//        hzuanshuLB.hidden = NO;
//        self.livingStateView.hidden = YES;
//        self.priceLabel.textColor = UIColorFromRGB(0xCCA95D);
//    }else
//    {
//        hzuanshuLB.hidden = YES;
//        self.livingStateView.hidden = NO;
//    }
    
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
    }else if ([info objectForKey:@"topic_style"])
    {
        int topic_style = [[info objectForKey:@"topic_style"] intValue];
        // topic_style 为1 或者2 时候才显示直播状态
        if (topic_style == 1 || topic_style == 2) {
            // topic_status 1.直播中 2.未开始 3.已结束
            int livingStatus = [[info objectForKey:@"topic_status"] intValue];
            switch (livingStatus) {
                case 1:
                {
                    self.livingStateView.frame = CGRectMake(5, self.courseImageView.hd_height - 25, 100, 20);
                    self.livingStateView.livingState = HomeLivingStateType_living;
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
        }else
        {
            self.livingStateView.frame = CGRectMake(5, self.courseImageView.hd_height - 25, 100, 20);
            self.livingStateView.livingState = HomeLivingStateType_living;
        }
        
    }
    
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

- (void)applyAction
{
    if (self.promotionBlock) {
        self.promotionBlock(self.info);
    }
}

@end
