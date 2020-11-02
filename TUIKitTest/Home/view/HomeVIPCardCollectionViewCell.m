//
//  HomeVIPCardCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeVIPCardCollectionViewCell.h"

@implementation HomeVIPCardCollectionViewCell


- (void)refreshUIWith:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    self.infoDic = infoDic;
    self.backgroundColor = [UIColor whiteColor];
    // (self.hd_width - 35) / 3 + 67.5
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 20, self.hd_width - 35, (self.hd_width - 35) / 3 + 67.5)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    self.backView.layer.cornerRadius = 10;
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.shadowColor = UIColorFromRGB(0xf1f1f1).CGColor;
    self.backView.layer.shadowOpacity = 1;
    self.backView.layer.shadowOffset = CGSizeMake(0, 3);
    self.backView.layer.shadowRadius = 3;
    
    
    // 直播大图
    self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 35, (self.hd_width - 35) / 3)];
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    [self.backView addSubview:self.iconImageVIew];
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.iconImageVIew.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = self.iconImageVIew.bounds;
    shapLayer.path = bezierpath.CGPath;
    [self.iconImageVIew.layer setMask: shapLayer];
    
    CGFloat seperateWidth = 10;
    
    // title
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageVIew.hd_x , CGRectGetMaxY(self.iconImageVIew.frame) + seperateWidth, self.backView.hd_width - 35, 22.5)];
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = [UIFont boldSystemFontOfSize:16];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    [self.backView addSubview:self.titleLB];
    
//    CGFloat bachWidth = width + 24 + 20;
    
    // price
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.titleLB.frame) + seperateWidth, 180, 20)];
    self.priceLB.font = kMainFont_12;
    self.priceLB.textColor = UIColorFromRGB(0xCCA95D);
    
    NSString * oldStr = [NSString stringWithFormat:@"￥%@ 有效期：%@", [infoDic objectForKey:@"money"], [infoDic objectForKey:@"display_day"]];
    [self.backView addSubview:self.priceLB];
    
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont_10,NSForegroundColorAttributeName:UIColorFromRGB(0xC2905B)};
    NSMutableAttributedString * NewStr = [[NSMutableAttributedString alloc]initWithString:oldStr];
    [NewStr addAttributes:attribute range:NSMakeRange([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"money"]] length] + 1, oldStr.length - [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"money"]] length] - 1)];
    self.priceLB.attributedText = NewStr;
    
    // joinBtn
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(self.backView.hd_width - 97.5, CGRectGetMaxY(self.iconImageVIew.frame) + 66.5, 80, 30);
    self.applyBtn.hd_centerY = self.priceLB.hd_centerY - 10;
    
    
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
    
    [self.applyBtn setTitle:@"去购买" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0x55310A) forState:UIControlStateNormal];
    self.applyBtn.layer.cornerRadius = self.applyBtn.hd_height / 2;
    self.applyBtn.layer.masksToBounds = YES;
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

@end
