//
//  PromotionComplateTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import "PromotionComplateTableViewCell.h"

@interface PromotionComplateTableViewCell()

@property (nonatomic, strong)UILabel * totalInComeLB;
@property (nonatomic, strong)UILabel * yueLB;
@property (nonatomic, strong)UILabel * teamMenberCountLB;

@end

@implementation PromotionComplateTableViewCell

- (void)refreshUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    topView.backgroundColor = kCommonMainBlueColor;
    [self.contentView addSubview:topView];
    
    self.totalInComeLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    self.totalInComeLB.textColor = UIColorFromRGB(0xffffff);
    self.totalInComeLB.font = [UIFont systemFontOfSize:20];
    self.totalInComeLB.textAlignment = NSTextAlignmentCenter;
    self.totalInComeLB.numberOfLines = 0;
    [topView addSubview:_totalInComeLB];
    NSString * keyongStr = [NSString stringWithFormat:@"累计收入(元)\n\n%@", [info objectForKey:@"income_sum"]];
    NSMutableAttributedString * mKeyongStr = [[NSMutableAttributedString alloc]initWithString:keyongStr];
    NSDictionary * attribute_keyong = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0xeeeeee)};
    [mKeyongStr setAttributes:attribute_keyong range:NSMakeRange(0, 7)];
    _totalInComeLB.attributedText = mKeyongStr;
    
    // yu e
    UIView * yueView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(topView.frame) - 20, kScreenWidth - 30, 50)];
    yueView.backgroundColor = UIColorFromRGB(0xffffff);
    yueView.layer.cornerRadius = 5;
    yueView.layer.masksToBounds = YES;
    [self.contentView addSubview:yueView];
    
    UIImageView * yueImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 13, 22, 24)];
    yueImageView.image = [UIImage imageNamed:@"PromotionYue"];
    [yueView addSubview:yueImageView];
    
    self.yueLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yueImageView.frame) + 10, 0, 200, yueView.hd_height)];
    self.yueLB.textColor = UIColorFromRGB(0x333333);
    self.yueLB.font = kMainFont;
    [yueView addSubview:_yueLB];
    NSString * yueStr = [NSString stringWithFormat:@"可提现余额:%@", [info objectForKey:@"balance"]];
    NSMutableAttributedString * mYueStr = [[NSMutableAttributedString alloc]initWithString:yueStr];
    NSDictionary * attribute_yue = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)};
    [mYueStr setAttributes:attribute_yue range:NSMakeRange(0, 6)];
    _yueLB.attributedText = mYueStr;
    
    UIImageView * goImage = [[UIImageView alloc]initWithFrame:CGRectMake(yueView.hd_width - 30, yueView.hd_height / 2 - 6, 12, 12)];
    goImage.image = [UIImage imageNamed:@"箭头"];
    [yueView addSubview:goImage];
    
    UIButton * yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yueBtn.frame = yueView.bounds;
    [yueView addSubview:yueBtn];
    [yueBtn addTarget:self action:@selector(yueAction) forControlEvents:UIControlEventTouchUpInside];
    
    // team
    UIView * teamView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(yueView.frame) + 10, kScreenWidth - 30, 100)];
    teamView.backgroundColor = UIColorFromRGB(0xffffff);
    teamView.layer.cornerRadius = 5;
    teamView.layer.masksToBounds = YES;
    [self.contentView addSubview:teamView];
    
    UILabel*teamLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 40)];
    teamLB.textColor = UIColorFromRGB(0x333333);
    teamLB.font = kMainFont_16;
    teamLB.text = @"我的团队";
    [teamView addSubview:teamLB];
    
    self.teamMenberCountLB = [[UILabel alloc]initWithFrame:CGRectMake(teamView.hd_width - 150, 0, 115, 40)];
    _teamMenberCountLB.textColor = UIColorFromRGB(0x999999);
    _teamMenberCountLB.font = kMainFont_10;
    _teamMenberCountLB.text = [NSString stringWithFormat:@"%@个成员", [info objectForKey:@"team_num"]];// team_num
    _teamMenberCountLB.textAlignment = NSTextAlignmentRight;
    [teamView addSubview:_teamMenberCountLB];
    
    UIImageView * goImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(teamView.hd_width - 30, 20 - 6, 12, 12)];
    goImage1.image = [UIImage imageNamed:@"箭头"];
    [teamView addSubview:goImage1];
    
    UIButton * teamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    teamBtn.frame = CGRectMake(0, 0, teamView.hd_width, 40);
    [teamView addSubview:teamBtn];
    [teamBtn addTarget:self action:@selector(teamAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * reciveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reciveBtn.frame = CGRectMake(15, 50, teamView.hd_width - 30, 40);
    reciveBtn.backgroundColor = kCommonMainBlueColor;
    reciveBtn.layer.cornerRadius = 5;
    reciveBtn.layer.masksToBounds = YES;
    [reciveBtn setTitle:@"邀请更多人加入团队" forState:UIControlStateNormal];
    [reciveBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    reciveBtn.titleLabel.font = kMainFont_12;
    [teamView addSubview:reciveBtn];
    [reciveBtn addTarget:self action:@selector(reciveAction) forControlEvents:UIControlEventTouchUpInside];
    
    // promotion course
    UIView * courseView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(teamView.frame) + 10 , kScreenWidth - 30, 70)];
    courseView.backgroundColor = UIColorFromRGB(0xffffff);
    courseView.layer.cornerRadius = 5;
    courseView.layer.masksToBounds = YES;
    [self.contentView addSubview:courseView];
    
    UIImageView * courseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, courseView.hd_height - 30, courseView.hd_height - 30)];
    courseImageView.image = [UIImage imageNamed:@"PromotionCourse"];
    [courseView addSubview:courseImageView];
    
    UILabel*courseLB = [[UILabel alloc]initWithFrame:CGRectMake(15 + CGRectGetMaxX(courseImageView.frame), 15, 100, 20)];
    courseLB.textColor = UIColorFromRGB(0x333333);
    courseLB.font = kMainFont_16;
    courseLB.text = @"课程推广";
    [courseView addSubview:courseLB];
    
    UILabel*courseLB1 = [[UILabel alloc]initWithFrame:CGRectMake(15 + CGRectGetMaxX(courseImageView.frame), CGRectGetMaxY(courseLB.frame), 200, 20)];
    courseLB1.textColor = UIColorFromRGB(0x999999);
    courseLB1.font = kMainFont_12;
    courseLB1.text = @"分享课程有机会获得更多收益";
    [courseView addSubview:courseLB1];
    
    UIImageView * courseImage = [[UIImageView alloc]initWithFrame:CGRectMake(yueView.hd_width - 30, courseView.hd_height / 2 - 6, 12, 12)];
    courseImage.image = [UIImage imageNamed:@"箭头"];
    [courseView addSubview:courseImage];
    
    UIButton * courseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    courseBtn.frame = courseView.bounds;
    [courseView addSubview:courseBtn];
    [courseBtn addTarget:self action:@selector(courseAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)courseAction
{
    if (self.courseBlock) {
        self.courseBlock(@{});
    }
}

- (void)teamAction
{
    if (self.teamBlock) {
        self.teamBlock(@{});
    }
}

- (void)reciveAction
{
    if (self.reciveBlock) {
        self.reciveBlock(@{});
    }
}

- (void)yueAction
{
    if (self.YueBlock) {
        self.YueBlock(@{});
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
