//
//  LivingTeacherIntroTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/11.
//

#import "LivingTeacherIntroTableViewCell.h"

@interface LivingTeacherIntroTableViewCell()

@property (nonatomic, strong)UIImageView * courseCover;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, strong)UIImageView * goImage;

@end

@implementation LivingTeacherIntroTableViewCell

- (void)refreshUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    self.courseCover = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 44, 44)];
    [self.courseCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseCover.layer.cornerRadius = self.courseCover.hd_height / 2;
    self.courseCover.layer.masksToBounds = YES;
    [self.contentView addSubview:self.courseCover];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCover.frame) + 15, self.courseCover.hd_y, self.hd_width - 30, 22)];
    self.titleLB.text = [info objectForKey:@"nickname"];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.numberOfLines = 0;
    [self.contentView addSubview:self.titleLB];
    
    self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.titleLB.frame), self.titleLB.hd_width, 22)];
    self.countLB.textColor = UIColorFromRGB(0x666666);
    self.countLB.text = [info objectForKey:@"desc"];
    self.countLB.font = kMainFont_12;
    [self.contentView addSubview:self.countLB];
    
    _goImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width - 30, self.hd_height / 2 - 6, 12, 12)];
    _goImage.image = [UIImage imageNamed:@"living_编组3"];
    [self.contentView addSubview:_goImage];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
