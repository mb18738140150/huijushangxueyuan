//
//  MyTeamInfoMemberTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "MyTeamInfoMemberTableViewCell.h"

@interface MyTeamInfoMemberTableViewCell()

@property (nonatomic, strong)UILabel * mySubordinateLB;
@property (nonatomic, strong)UILabel * makeSubordinateLB;

@property (nonatomic, strong)UILabel * todayNewSubordinateLB;
@property (nonatomic, strong)UILabel * todayMakeSubordinateLB;

@property (nonatomic, strong)UILabel * monthNewSubordinateLB;
@property (nonatomic, strong)UILabel * monthMakeSubordinateLB;

@property (nonatomic, strong)UILabel * firstTeamLB;
@property (nonatomic, strong)UILabel * secondLB;
@property (nonatomic, strong)UILabel * thirdLB;

@property (nonatomic, strong)UIButton * checkDetailBtn;

@end

@implementation MyTeamInfoMemberTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    NSDictionary * todayInfo = [infoDic objectForKey:@"today"];
    NSDictionary * monthInfo = [infoDic objectForKey:@"same_month"];
    NSDictionary * teamInfo = [infoDic objectForKey:@"team"];
    
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    contentView.backgroundColor = kCommonMainBlueColor;
    [self.contentView addSubview:contentView];
    
    float contentHeight = 100;
    float separateHeight = 10;
    
    self.mySubordinateLB = [[UILabel alloc]initWithFrame:CGRectMake(0, separateHeight, kScreenWidth / 2 - 1, (contentHeight - 2 * separateHeight))];
    _mySubordinateLB.textColor = UIColorFromRGB(0xffffff);
    _mySubordinateLB.font = kMainFont;
    _mySubordinateLB.textAlignment = NSTextAlignmentCenter;
    _mySubordinateLB.numberOfLines = 0;
    [contentView addSubview:_mySubordinateLB];
    
    UIView * topSeparateView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth / 2, 30, 1, 40)];
    topSeparateView.backgroundColor = UIColorFromRGB(0xffffff);
    [contentView addSubview:topSeparateView];
    
    self.makeSubordinateLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 1, separateHeight, kScreenWidth / 2, (contentHeight - 2 * separateHeight))];
    _makeSubordinateLB.textColor = UIColorFromRGB(0xffffff);
    _makeSubordinateLB.font = kMainFont;
    _makeSubordinateLB.textAlignment = NSTextAlignmentCenter;
    _makeSubordinateLB.numberOfLines = 0;
    [contentView addSubview:_makeSubordinateLB];
 
    NSString * keyongStr = [NSString stringWithFormat:@"%@\n我的下级", [infoDic objectForKey:@"member_num"]];
    NSMutableAttributedString * mKeyongStr = [[NSMutableAttributedString alloc]initWithString:keyongStr];
    NSDictionary * attribute_keyong = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]};
    [mKeyongStr setAttributes:attribute_keyong range:NSMakeRange(0, [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"member_num"]] length])];
    _mySubordinateLB.attributedText = mKeyongStr;
    
    NSString * dailingquStr = [NSString stringWithFormat:@"%@\n成交下级", [infoDic objectForKey:@"deal_member_num"]];
    NSMutableAttributedString * mdailingquStr = [[NSMutableAttributedString alloc]initWithString:dailingquStr];
    NSDictionary * attribute_dailingqu = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]};
    [mdailingquStr setAttributes:attribute_dailingqu range:NSMakeRange(0, [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"deal_member_num"]] length])];
    _makeSubordinateLB.attributedText = mdailingquStr;
    
    
    // 今日
    UILabel * todayLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(contentView.frame) + 15, 40, 20)];
    todayLB.text = @"今天";
    todayLB.textAlignment = NSTextAlignmentCenter;
    todayLB.font = [UIFont boldSystemFontOfSize:16];
    todayLB.textColor = UIColorFromRGB(0x000000);
    [todayLB sizeToFit];
    [self.contentView addSubview:todayLB];
    
    UIImageView * todayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(todayLB.frame) + 5, todayLB.hd_y + 2, 16, 16)];
    todayImageView.image = [UIImage imageNamed:@"MyTeamzengchang"];
    [self.contentView addSubview:todayImageView];
    
    // 今日新增
    UIView * todayNewSubordinateView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(todayLB.frame) + 15, kScreenWidth / 2 - 20, 60)];
    todayNewSubordinateView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:todayNewSubordinateView];
    todayNewSubordinateView.layer.cornerRadius = 5;
    todayNewSubordinateView.layer.shadowColor = UIColorFromRGB(0xf1f1f1).CGColor;
    todayNewSubordinateView.layer.shadowOpacity = 3;
    todayNewSubordinateView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UILabel * todayLB1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 100, 20)];
    todayLB1.text = @"新增下级";
    todayLB1.font = kMainFont;
    todayLB1.textColor = UIColorFromRGB(0x999999);
    [todayNewSubordinateView addSubview:todayLB1];
    
    self.todayNewSubordinateLB = [[UILabel alloc]initWithFrame:CGRectMake(todayNewSubordinateView.hd_width - 100, 20, 70, 20)];
    _todayNewSubordinateLB.text = [NSString stringWithFormat:@"%@", [todayInfo objectForKey:@"new_team"]];
    _todayNewSubordinateLB.font = kMainFont;
    _todayNewSubordinateLB.textColor = UIColorFromRGB(0x333333);
    _todayNewSubordinateLB.textAlignment = NSTextAlignmentRight;
    [todayNewSubordinateView addSubview:_todayNewSubordinateLB];
    
    // 今日成交
    UIView * todayMakeSubordinateView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 5, CGRectGetMaxY(todayLB.frame) + 15, kScreenWidth / 2 - 20, 60)];
    todayMakeSubordinateView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:todayMakeSubordinateView];
    todayMakeSubordinateView.layer.cornerRadius = 5;
    todayMakeSubordinateView.layer.shadowColor = UIColorFromRGB(0xf1f1f1).CGColor;
    todayMakeSubordinateView.layer.shadowOpacity = 3;
    todayMakeSubordinateView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UILabel * todayMakeLB1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 100, 20)];
    todayMakeLB1.text = @"成交下级";
    todayMakeLB1.font = kMainFont;
    todayMakeLB1.textColor = UIColorFromRGB(0x999999);
    [todayMakeSubordinateView addSubview:todayMakeLB1];
    
    self.todayMakeSubordinateLB = [[UILabel alloc]initWithFrame:CGRectMake(todayNewSubordinateView.hd_width - 100, 20, 70, 20)];
    _todayMakeSubordinateLB.text = [NSString stringWithFormat:@"%@", [todayInfo objectForKey:@"new_team_paid"]];
    _todayMakeSubordinateLB.font = kMainFont;
    _todayMakeSubordinateLB.textColor = UIColorFromRGB(0x333333);
    _todayMakeSubordinateLB.textAlignment = NSTextAlignmentRight;
    [todayMakeSubordinateView addSubview:_todayMakeSubordinateLB];
    
    
    // 当月
    UILabel * monthLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(todayNewSubordinateView.frame) + 15, 40, 20)];
    monthLB.text = @"本月";
    monthLB.textAlignment = NSTextAlignmentCenter;
    monthLB.font = [UIFont boldSystemFontOfSize:16];
    monthLB.textColor = UIColorFromRGB(0x000000);
    [monthLB sizeToFit];
    [self.contentView addSubview:monthLB];
    
    UIImageView * monthImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(todayLB.frame) + 5, monthLB.hd_y + 2, 15, 15)];
    monthImageView.image = [UIImage imageNamed:@"MyTeamzengchang"];
    [self.contentView addSubview:monthImageView];
    
    // 本月新增
    UIView * monthNewSubordinateView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(monthLB.frame) + 15, kScreenWidth / 2 - 20, 60)];
    monthNewSubordinateView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:monthNewSubordinateView];
    monthNewSubordinateView.layer.cornerRadius = 5;
    monthNewSubordinateView.layer.shadowColor = UIColorFromRGB(0xf1f1f1).CGColor;
    monthNewSubordinateView.layer.shadowOpacity = 3;
    monthNewSubordinateView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UILabel * monthLB1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 100, 20)];
    monthLB1.text = @"新增下级";
    monthLB1.font = kMainFont;
    monthLB1.textColor = UIColorFromRGB(0x999999);
    [monthNewSubordinateView addSubview:monthLB1];
    
    self.monthNewSubordinateLB = [[UILabel alloc]initWithFrame:CGRectMake(monthNewSubordinateView.hd_width - 100, 20, 70, 20)];
    _monthNewSubordinateLB.text = [NSString stringWithFormat:@"%@", [monthInfo objectForKey:@"new_team"]];
    _monthNewSubordinateLB.font = kMainFont;
    _monthNewSubordinateLB.textColor = UIColorFromRGB(0x333333);
    _monthNewSubordinateLB.textAlignment = NSTextAlignmentRight;
    [monthNewSubordinateView addSubview:_monthNewSubordinateLB];
    
    // 本月成交
    UIView * monthMakeSubordinateView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 5, CGRectGetMaxY(monthLB.frame) + 15, kScreenWidth / 2 - 20, 60)];
    monthMakeSubordinateView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:monthMakeSubordinateView];
    monthMakeSubordinateView.layer.cornerRadius = 5;
    monthMakeSubordinateView.layer.shadowColor = UIColorFromRGB(0xf1f1f1).CGColor;
    monthMakeSubordinateView.layer.shadowOpacity = 3;
    monthMakeSubordinateView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UILabel * monthMakeLB1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 100, 20)];
    monthMakeLB1.text = @"成交下级";
    monthMakeLB1.font = kMainFont;
    monthMakeLB1.textColor = UIColorFromRGB(0x999999);
    [monthMakeSubordinateView addSubview:monthMakeLB1];
    
    self.monthMakeSubordinateLB = [[UILabel alloc]initWithFrame:CGRectMake(monthMakeSubordinateView.hd_width - 100, 20, 70, 20)];
    _monthMakeSubordinateLB.text = [NSString stringWithFormat:@"%@", [monthInfo objectForKey:@"new_team_paid"]];
    _monthMakeSubordinateLB.font = kMainFont;
    _monthMakeSubordinateLB.textColor = UIColorFromRGB(0x333333);
    _monthMakeSubordinateLB.textAlignment = NSTextAlignmentRight;
    [monthMakeSubordinateView addSubview:_monthMakeSubordinateLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(monthNewSubordinateView.frame) + 15, kScreenWidth, 10)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:separateView];
    
    
    self.firstTeamLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 20 + CGRectGetMaxY(separateView.frame), 100, 100)];
    self.firstTeamLB.backgroundColor = kCommonMainBlueColor;
    self.firstTeamLB.font = kMainFont_10;
    self.firstTeamLB.textAlignment = NSTextAlignmentCenter;
    self.firstTeamLB.numberOfLines = 0;
    self.firstTeamLB.layer.cornerRadius = _firstTeamLB.hd_height / 2 ;
    self.firstTeamLB.layer.masksToBounds = YES;
    self.firstTeamLB.textColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:self.firstTeamLB];
    
    NSString * firstStr = [NSString stringWithFormat:@"%@\n直属团队", [teamInfo objectForKey:@"one"]];
    NSMutableAttributedString * mFirstStr = [[NSMutableAttributedString alloc]initWithString:firstStr];
    NSDictionary * attribute_First = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]};
    NSDictionary * attribute_First1 = @{NSFontAttributeName:kMainFont};
    [mFirstStr setAttributes:attribute_First range:NSMakeRange(0, [[NSString stringWithFormat:@"%@", [teamInfo objectForKey:@"one"]] length])];
    [mFirstStr setAttributes:attribute_First1 range:NSMakeRange(firstStr.length - 4, 4)];
    _firstTeamLB.attributedText = mFirstStr;
    
    self.secondLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_firstTeamLB.frame), kScreenWidth / 2, 80)];
    self.secondLB.backgroundColor = UIColorFromRGB(0xffffff);
    self.secondLB.font = kMainFont_10;
    self.secondLB.numberOfLines = 0;
    self.secondLB.textColor = UIColorFromRGB(0x999999);
    _secondLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.secondLB];
    
    NSString * secondStr = [NSString stringWithFormat:@"%@\n\n二级团队", [teamInfo objectForKey:@"two"]];
    NSMutableAttributedString * mSecondStr = [[NSMutableAttributedString alloc]initWithString:secondStr];
    NSDictionary * attribute_Second = @{NSForegroundColorAttributeName:UIColorFromRGB(0x333333),NSFontAttributeName:kMainFont};
    NSDictionary * attribute_Second1 = @{NSFontAttributeName:kMainFont};
    [mSecondStr setAttributes:attribute_Second range:NSMakeRange(0, [[NSString stringWithFormat:@"%@", [teamInfo objectForKey:@"two"]] length])];
    [mSecondStr setAttributes:attribute_Second1 range:NSMakeRange(secondStr.length - 4, 4)];
    _secondLB.attributedText = mSecondStr;
    
    self.thirdLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2, CGRectGetMaxY(_firstTeamLB.frame), kScreenWidth / 2, 80)];
    self.thirdLB.backgroundColor = UIColorFromRGB(0xffffff);
    self.thirdLB.font = kMainFont_10;
    self.thirdLB.numberOfLines = 0;
    self.thirdLB.textColor = UIColorFromRGB(0x999999);
    _thirdLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.thirdLB];
    
    NSString * thirdStr = [NSString stringWithFormat:@"%@\n\n三级团队", [teamInfo objectForKey:@"three"]];
    NSMutableAttributedString * mThirdStr = [[NSMutableAttributedString alloc]initWithString:thirdStr];
    NSDictionary * attribute_Third = @{NSForegroundColorAttributeName:UIColorFromRGB(0x333333),NSFontAttributeName:kMainFont};
    NSDictionary * attribute_Third1 = @{NSFontAttributeName:kMainFont};
    [mThirdStr setAttributes:attribute_Third range:NSMakeRange(0, [[NSString stringWithFormat:@"%@", [teamInfo objectForKey:@"three"]] length])];
    [mThirdStr setAttributes:attribute_Third1 range:NSMakeRange(thirdStr.length - 4, 4)];
    _thirdLB.attributedText = mThirdStr;
    
    
    self.checkDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkDetailBtn.frame = CGRectMake(80, CGRectGetMaxY(_thirdLB.frame), kScreenWidth - 160, 40);
    _checkDetailBtn.layer.cornerRadius = 5;
    _checkDetailBtn.layer.masksToBounds = YES;
    _checkDetailBtn.layer.borderColor = kCommonMainBlueColor.CGColor;
    _checkDetailBtn.layer.borderWidth = 1;
    [self.checkDetailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.checkDetailBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    _checkDetailBtn.titleLabel.font = kMainFont;
    [self.contentView addSubview:_checkDetailBtn];
    
    [_checkDetailBtn addTarget:self action:@selector(checkDetailAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)checkDetailAction
{
    if (self.checkDetailBlock) {
        self.checkDetailBlock(@{});
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
