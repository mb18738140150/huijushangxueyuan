//
//  HomeBigImageTypeCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeBigImageTypeCollectionViewCell.h"

@implementation HomeBigImageTypeCollectionViewCell


- (void)refreshUIWith:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    self.infoDic = infoDic;
    
    // (self.hd_width - 35) / 2 + 126
    CGFloat topSpace = 0;
    if (self.isOneCourse) {
        topSpace = 20;
    }
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, (self.hd_width - 35) / 2 + 126 + topSpace)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    // 直播大图
    self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, topSpace, self.hd_width - 35, (self.hd_width - 35) / 2)];
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@"placeholdImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    [self.backView addSubview:self.iconImageVIew];
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.iconImageVIew.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = self.iconImageVIew.bounds;
    shapLayer.path = bezierpath.CGPath;
    [self.iconImageVIew.layer setMask: shapLayer];
    
    // 直播状态
    self.livingStateView = [[LivingStateView alloc]initWithFrame:CGRectMake(5, self.iconImageVIew.hd_height - 25, 100, 20)];
    if ([infoDic objectForKey:@"topic_status"])
    {
        // topic_status 1.直播中 2.未开始 3.已结束
        int livingStatus = [[infoDic objectForKey:@"topic_status"] intValue];
        switch (livingStatus) {
            case 1:
            {
                self.livingStateView.frame = CGRectMake(5, self.iconImageVIew.hd_height - 25, 100, 20);
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
    }
    [self.iconImageVIew addSubview:self.livingStateView];
    
    CGFloat seperateWidth = 10;
    
    // title
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageVIew.hd_x , CGRectGetMaxY(self.iconImageVIew.frame) + seperateWidth, self.backView.hd_width - 35, 22.5)];
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = [UIFont boldSystemFontOfSize:16];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    [self.backView addSubview:self.titleLB];
    
    // teacher info
    NSDictionary * teacherInfo = [infoDic objectForKey:@"author"];
    
    NSString * teacherStr = [NSString stringWithFormat:@"讲师：%@",[teacherInfo objectForKey:@"nickname"]];
    CGFloat width = [teacherStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.width;
    
    CGFloat bachWidth = width + 24 + 20;
    
    UIView * teacherBackView = [[UIView alloc]initWithFrame:CGRectMake(17.5, CGRectGetMaxY(self.titleLB.frame) + seperateWidth, bachWidth, 24)];
    teacherBackView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    teacherBackView.layer.cornerRadius = teacherBackView.hd_height / 2;
    teacherBackView.layer.masksToBounds = YES;
    [self.backView addSubview:teacherBackView];
    
    self.teacherIconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.teacherIconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[teacherInfo objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    self.teacherIconImageVIew.layer.cornerRadius = self.teacherIconImageVIew.hd_height / 2;
    self.teacherIconImageVIew.layer.masksToBounds = YES;
    [teacherBackView addSubview:self.teacherIconImageVIew];
    
    self.teacherNameLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherIconImageVIew.frame) + 10, 0, width + 5, 24)];
    self.teacherNameLB.text = teacherStr;
    self.teacherNameLB.textColor = UIColorFromRGB(0x666666);
    self.teacherNameLB.font = kMainFont_12;
    [teacherBackView addSubview:self.teacherNameLB];
    
    // price
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(teacherBackView.frame) + seperateWidth, 150, 20)];
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
    self.applyBtn.frame = CGRectMake(self.backView.hd_width - 97.5, CGRectGetMaxY(self.iconImageVIew.frame) + 66.5, 80, 30);
    [self.applyBtn setTitle:@"立即进入" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0x2A75ED) forState:UIControlStateNormal];
    self.applyBtn.backgroundColor = [UIColor whiteColor];
    self.applyBtn.layer.cornerRadius = self.applyBtn.hd_height / 2;
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.borderColor = UIColorFromRGB(0x2A75ED).CGColor;
    self.applyBtn.layer.borderWidth = 1;
    self.applyBtn.titleLabel.font = kMainFont_12;
    [self.backView addSubview:self.applyBtn];
    
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
        return [NSString stringWithFormat:@"￥%@￥%@", str1,str2];
    }
}

@end
