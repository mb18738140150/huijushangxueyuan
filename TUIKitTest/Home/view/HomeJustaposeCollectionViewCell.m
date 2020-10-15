//
//  HomeJustaposeCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeJustaposeCollectionViewCell.h"

@implementation HomeJustaposeCollectionViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic andItem:(int)item
{
    [self.contentView removeAllSubviews];
    self.infoDic = infoDic;
    
    // (self.hd_width - 22.5) / 2 + 86.5
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, (self.hd_width - 22.5) / 2 + 86.5)];
    
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    CGFloat leftWidth = 0;
    CGFloat topSpace = 0;
    if (self.isOneCourse) {
        topSpace = 20;
    }
    
    
    // 直播大图
    if (item % 2 != 0) {
        leftWidth = 5;
        self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(5, topSpace, self.hd_width - 22.5, (self.hd_width - 22.5) / 2 )];
    }else
    {
        leftWidth = 17.5;
        self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, topSpace, self.hd_width - 22.5, (self.hd_width - 22.5) / 2 )];
    }
    
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@"placeholdImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    [self.backView addSubview:self.iconImageVIew];
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.iconImageVIew.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = self.iconImageVIew.bounds;
    shapLayer.path = bezierpath.CGPath;
    [self.iconImageVIew.layer setMask: shapLayer];
    
    // 直播状态
    self.livingStateView = [[LivingStateView alloc]initWithFrame:CGRectMake(0, self.iconImageVIew.hd_height - 20, 100, 20)];
    
    NSString * types = [infoDic objectForKey:@"types"];
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
    [self.iconImageVIew addSubview:self.livingStateView];
    
    CGFloat seperateWidth = 10;
    
    // title
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageVIew.hd_x , CGRectGetMaxY(self.iconImageVIew.frame) + seperateWidth, self.backView.hd_width - 22.5, 40)];
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = kMainFont;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    [self.backView addSubview:self.titleLB];
    
    
    // price
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.titleLB.frame) + seperateWidth / 2, 120, 16.5)];
    self.priceLB.font = kMainFont_12;
    self.priceLB.textColor = UIColorFromRGB(0xCCA95D);
    NSString * oldStr = [self getOldStrWithSource1:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] andSource2:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"off_paymoney"]]];
    [self.backView addSubview:self.priceLB];
    
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    NSMutableAttributedString * NewStr = [[NSMutableAttributedString alloc]initWithString:oldStr];
    [NewStr addAttributes:attribute range:NSMakeRange([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] length]+ 1, oldStr.length - [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] length] - 1)];
    self.priceLB.attributedText = NewStr;
    
    // joinBtn
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(self.backView.hd_width - 120, CGRectGetMaxY(self.iconImageVIew.frame) + 57, 120 - leftWidth, 13);
    self.applyBtn.hd_centerY = self.priceLB.hd_centerY;
    [self.backView addSubview:self.applyBtn];
    
    [self.applyBtn setTitle:[NSString stringWithFormat:@"%@人已看过", [infoDic objectForKey:@"look_num"]] forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    self.applyBtn.backgroundColor = [UIColor whiteColor];
    self.applyBtn.titleLabel.font = kMainFont_10;
    self.applyBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    
//    if ([[infoDic objectForKey:@"is_pay"] intValue] == 1) {
//        [self.applyBtn setTitle:@"免费" forState:UIControlStateNormal];
//        [self.applyBtn setTitleColor:UIColorFromRGB(0xCCA95D) forState:UIControlStateNormal];
//    }else
//    {
//        [self.applyBtn setTitle:@"去购买" forState:UIControlStateNormal];
//        self.applyBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//        [self.applyBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
//        self.applyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    }
    
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
}


- (NSMutableAttributedString *)getAttributeStringWithBegainStr:(NSString *)begainStr andContent:(NSString *)content
{
    NSString * str = [NSString stringWithFormat:@"%@%@", begainStr, content];
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont_12,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)};
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mStr addAttributes:attribute range:NSMakeRange(0, begainStr.length)];
    return mStr;
}

- (void)applyAction
{
    if (self.applyBlock) {
        self.applyBlock(self.infoDic);
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
