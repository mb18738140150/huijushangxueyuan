//
//  HomeOpenVIPCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeOpenVIPCollectionViewCell.h"

@implementation HomeOpenVIPCollectionViewCell

- (void)resetUIWithInfo:(NSDictionary *)info
{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView removeAllSubviews];
    
    // 60
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 0, self.hd_width - 35, 40)];
    CAGradientLayer *paylayer = [[CAGradientLayer alloc]init];
    paylayer.frame = self.backView.bounds;
    paylayer.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xFFF4E5) CGColor],(id)[UIColorFromRGB(0xEDDCCC) CGColor], nil];
    paylayer.startPoint = CGPointMake(0, 0.5);
    paylayer.endPoint = CGPointMake(1, 0.5);
    [self.backView.layer addSublayer:paylayer];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.backView];
    
    self.vipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 14, 18, 13)];
    self.vipImageView.image = [UIImage imageNamed:@"huiyuan-2"];
    [self.backView addSubview:self.vipImageView];
    
    self.vipTitleView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.vipImageView.frame) + 10, 12, 120, 16)];
    self.vipTitleView.text = @"尊享专属会员权益";
    self.vipTitleView.font = kMainFont;
    [self.vipTitleView sizeToFit];
    self.vipTitleView.textColor = UIColorFromRGB(0x3D3731);
    [self.backView addSubview:self.vipTitleView];
    
    self.openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openBtn.frame = CGRectMake(self.backView.hd_width - 60, 10, 50, 20);
    [self.openBtn setTitle:@"去开通" forState:UIControlStateNormal];
    [self.openBtn setTitleColor:UIColorFromRGB(0x3D3731) forState:UIControlStateNormal];
    [self.openBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    self.openBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.openBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, -40);
    self.openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self.contentView addSubview:self.openBtn];
    
    [self.openBtn addTarget:self action:@selector(openVipAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)resetContent:(NSDictionary *)info
{
    self.vipTitleView.text = [info objectForKey:@"title"];
    [self.vipTitleView sizeToFit];
    
    if ([info objectForKey:@"image"]) {
        self.vipImageView.image = [UIImage imageNamed:[info objectForKey:@"image"]];
        
        CGSize size = CGSizeMake(self.vipImageView.image.size.width, self.vipImageView.image.size.width);
        
        self.vipImageView.frame = CGRectMake(13, (40 - size.height * 18 / size.width) / 2, 18, size.height * 18 / size.width);
    }
    
    NSString * btnStr = [info objectForKey:@"btn"];
    CGFloat width = [btnStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.width;
    [self.openBtn setTitle:[info objectForKey:@"btn"] forState:UIControlStateNormal];
    [self.openBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    self.openBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.openBtn.imageEdgeInsets = UIEdgeInsetsMake(0, width + 5, 0, -width - 5);
    self.openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
}

- (void)openVipAction
{
    if (self.openVIPBlock) {
        self.openVIPBlock(@{});
    }
}
    
@end
