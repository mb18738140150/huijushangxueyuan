//
//  MyVIPCardCollectionViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import "MyVIPCardCollectionViewCell.h"

@implementation MyVIPCardCollectionViewCell
- (void)refreshUIWith:(NSDictionary *)infoDic
{
    if (![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self.contentView removeAllSubviews];
    self.infoDic = infoDic;
    self.backgroundColor = [UIColor whiteColor];
    // (self.hd_width - 35) / 3 + 67.5
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, self.hd_width - 30, (self.hd_width - 30) / 3 + 50)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    self.backView.layer.cornerRadius = 5;
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.shadowColor = UIColorFromRGB(0xf1f1f1).CGColor;
    self.backView.layer.shadowOpacity = 1;
    self.backView.layer.shadowOffset = CGSizeMake(0, 3);
    self.backView.layer.shadowRadius = 3;
    
    
    // 直播大图
    self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 30, (self.hd_width - 30) / 3)];
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.iconImageVIew.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = self.iconImageVIew.bounds;
    shapLayer.path = bezierpath.CGPath;
    [self.iconImageVIew.layer setMask: shapLayer];
    [self.backView addSubview:self.iconImageVIew];
    
    self.xufeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xufeiBtn.frame = CGRectMake(_iconImageVIew.hd_width - 40, 0, 40, 20);
    
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.xufeiBtn.bounds;
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.xufeiBtn.bounds;
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0xEBD5C0) CGColor],(id)[UIColorFromRGB(0xDBB293) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0, @0.5, @1]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0.5)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 0.5)];
    [gradientLayer addSublayer:gradientLayer1];
    
    UIBezierPath * xufeibezierpath = [UIBezierPath bezierPathWithRoundedRect:self.xufeiBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * xufeishapLayer = [[CAShapeLayer alloc]init];
    xufeishapLayer.frame = self.xufeiBtn.bounds;
    xufeishapLayer.path = xufeibezierpath.CGPath;
    
    [gradientLayer setMask:xufeishapLayer];
    [self.xufeiBtn.layer addSublayer:gradientLayer];
    
    [self.xufeiBtn setTitle:@"续费" forState:UIControlStateNormal];
    [self.xufeiBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    self.xufeiBtn.titleLabel.font = kMainFont_12;
    [self.iconImageVIew addSubview:self.xufeiBtn];
    self.xufeiBtn.enabled = NO;
    
    CGFloat seperateWidth = 5;
    
    // title
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageVIew.hd_x + 10, CGRectGetMaxY(self.iconImageVIew.frame) + seperateWidth, self.backView.hd_width - 30, 15)];
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = kMainFont_12;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    [self.backView addSubview:self.titleLB];
    
//    CGFloat bachWidth = width + 24 + 20;
    
    // price
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.titleLB.frame) + seperateWidth, 180, 15)];
    self.priceLB.font = kMainFont_10;
    self.priceLB.textColor = UIColorFromRGB(0xC2905B);
    NSString * timeStr = [infoDic objectForKey:@"end_time"];
    timeStr = [[timeStr componentsSeparatedByString:@" "] firstObject];
    self.priceLB.text = [NSString stringWithFormat:@"到期时间：%@",  timeStr];
    [self.backView addSubview:self.priceLB];
    
}

@end
