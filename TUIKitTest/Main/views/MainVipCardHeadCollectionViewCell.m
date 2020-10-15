//
//  MainVipCardHeadCollectionViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import "MainVipCardHeadCollectionViewCell.h"

@interface MainVipCardHeadCollectionViewCell()

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * titleLB;

@end

@implementation MainVipCardHeadCollectionViewCell

- (void)resetUIWith:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    
    // 90 + 40
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.hd_width, self.contentView.hd_height)];
    self.backView.backgroundColor = UIColorFromRGB(0x2B2D36);
    [self.contentView addSubview:self.backView];
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, self.contentView.hd_width - 30, self.contentView.hd_height - 40)];
    self.backImageView.image = [UIImage imageNamed:@"main_会员中心头部卡片"];
    [self.contentView addSubview:self.backImageView];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 20, self.backImageView.hd_height - 40, self.backImageView.hd_height - 40)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:kUserHeaderImageUrl]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    [self.backImageView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y, 200, self.iconImageView.hd_height / 2)];
    self.titleLB.font = [UIFont systemFontOfSize:16];
    self.titleLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:kUserNickName]];
    self.titleLB.textColor = UIColorFromRGB(0x3D3731);
    [self.backImageView addSubview:self.titleLB];
    
    UIImageView * huangguanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y + self.iconImageView.hd_height / 4 * 3 - 4, 8, 8)];
    huangguanImageView.image = [UIImage imageNamed:@"huiyuan-2"];
    [self.backImageView addSubview:huangguanImageView];
    
    UILabel * contentLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(huangguanImageView.frame) + 10, self.iconImageView.hd_y + self.iconImageView.hd_height / 2, 200, self.iconImageView.hd_height / 2)];
    contentLB.font = kMainFont_12;
    contentLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:kUserNickName]];
    contentLB.textColor = UIColorFromRGB(0x3D3731);
    [self.backImageView addSubview:contentLB];
    
    
//#2B2D36
//    self.backGroundColor = uicolo
}

@end
