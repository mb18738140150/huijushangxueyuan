//
//  MainUserInfoTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import "MainUserInfoTableViewCell.h"

@implementation MainUserInfoTableViewCell

- (void)resetUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    // 72 + 20 + 15
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12.5, 20, 72, 72)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:kUserHeaderImageUrl]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_centerY - 10, 200, 20)];
    self.titleLB.font = [UIFont systemFontOfSize:18];
    self.titleLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:kUserNickName]];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    [self.titleLB sizeToFit];
    [self.contentView addSubview:self.titleLB];
    
    if ([UserManager sharedManager].isTeacher) {
        UILabel * teacherLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLB.frame) + 10, _titleLB.hd_y + 3, 30, 14)];
        teacherLB.backgroundColor = UIRGBColor(129, 148, 183);
        teacherLB.text = @"老师";
        teacherLB.textColor = UIColorFromRGB(0xffffff);
        teacherLB.font = kMainFont_10;
        teacherLB.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:teacherLB];
        teacherLB.layer.cornerRadius = teacherLB.hd_height / 2;
        teacherLB.layer.masksToBounds = YES;
        
        UIImageView * goImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.hd_width - 30, self.titleLB.hd_centerY - 6, 12, 12)];
        goImage.image = [UIImage imageNamed:@"living_编组3"];
        [self.contentView addSubview:goImage];
        
        self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(goImage.hd_x - 60, _titleLB.hd_y, 60, _titleLB.hd_height)];
        self.countLB.textColor = kCommonMainBlueColor;
        self.countLB.text = @"进入课程";
        self.countLB.textAlignment = NSTextAlignmentRight;
        self.countLB.font = kMainFont_12;
        [self.contentView addSubview:self.countLB];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(_countLB.hd_x, _countLB.hd_y, 130, _countLB.hd_width + 20);
        [btn addTarget:self action:@selector(checkDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
    }
    
}

- (void)checkDetail
{
    if (self.joinCourseBlock) {
        self.joinCourseBlock([[[[UserManager sharedManager] getUserInfo] objectForKey:@"teacher"] objectForKey:@"data"]);
    }
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
