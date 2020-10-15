//
//  GiftCollectionViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/7.
//

#import "GiftCollectionViewCell.h"

@implementation GiftCollectionViewCell

- (void)resetWithInfo:(NSDictionary *)info
{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView removeAllSubviews];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_height - 20)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.boardView = [[UIView alloc]initWithFrame:self.backView.bounds];
    self.boardView.backgroundColor = [UIColor whiteColor];
    self.boardView.layer.cornerRadius = 5;
    self.boardView.layer.masksToBounds = YES;
    self.boardView.layer.borderColor = UIColorFromRGB(0xF19937).CGColor;
    self.boardView.layer.borderWidth = 1;
    [self.backView addSubview:self.boardView];
    self.boardView.hidden = YES;
    
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.backView.hd_width / 2 - 20, 10, 40, 40)];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    [self.backView addSubview:self.contentImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentImageView.frame) + 5, self.backView.hd_width, 20)];
    self.titleLB.text = [info objectForKey:@"name"];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    [self.backView addSubview:self.titleLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame) + 5, self.backView.hd_width, 15)];
    self.priceLB.text = [NSString stringWithFormat:@"￥%@", [info objectForKey:@"price"]];
    self.priceLB.textAlignment = NSTextAlignmentCenter;
    self.priceLB.textColor = UIColorFromRGB(0x333333);
    self.priceLB.font = kMainFont_10;
    [self.backView addSubview:self.priceLB];
}

- (void)resetSelect
{
    self.boardView.hidden = NO;
    self.priceLB.textColor = UIColorFromRGB(0xF19937);
}


@end
