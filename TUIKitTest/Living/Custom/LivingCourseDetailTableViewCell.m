//
//  LivingCourseDetailTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/11.
//

#import "LivingCourseDetailTableViewCell.h"

@interface LivingCourseDetailTableViewCell()

@property (nonatomic, strong)UIImageView * courseCover;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, strong)UILabel * startTimeLB;

@end

@implementation LivingCourseDetailTableViewCell

- (void)refreshUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    self.courseCover = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2)];
    [self.courseCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    [self.contentView addSubview:self.courseCover];
    
    NSString * titleStr = [info objectForKey:@"title"];
    CGFloat height = [titleStr boundingRectWithSize:CGSizeMake(self.hd_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_18} context:nil].size.height;
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.courseCover.frame) + 10, self.hd_width - 30, height)];
    self.titleLB.text = titleStr;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont_18;
    self.titleLB.numberOfLines = 0;
    [self.contentView addSubview:self.titleLB];
    
    self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.titleLB.frame) + 10, self.titleLB.hd_width, 15)];
    self.countLB.textColor = UIColorFromRGB(0x666666);
    self.countLB.text = [DateUtility time_timestampToString:[[info objectForKey:@"remaining_time"] longValue]];
    self.countLB.font = kMainFont_12;
    [self.contentView addSubview:self.countLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.countLB.frame) + 10, self.hd_width, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:separateView];
    
    UIImageView * timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(separateView.frame) + 16, 13, 13)];
    timeImageView.image = [UIImage imageNamed:@"livingTime"];
    [self.contentView addSubview:timeImageView];
    
    self.startTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeImageView.frame) + 5, CGRectGetMaxY(separateView.frame) +15, 240, 15)];
    _startTimeLB.textColor = UIColorFromRGB(0x333333);
    _startTimeLB.font = kMainFont;
    _startTimeLB.text = [NSString stringWithFormat:@"开始时间：%@", [info objectForKey:@"begin_time"]];
    [self.contentView addSubview:_startTimeLB];
    
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
