//
//  MyTeamInfoTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "MyTeamInfoTableViewCell.h"

@interface MyTeamInfoTableViewCell()

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *titleLB;
@property (nonatomic, strong)UILabel *timeLb;
@property (nonatomic, strong)UILabel *nameLB;
@property (nonatomic, strong)UILabel *contentLB;

@end

@implementation MyTeamInfoTableViewCell

- (void)refreshUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.contentView.frame = self.bounds;
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y, self.hd_width - 70, 15)];
    self.titleLB.font = kMainFont;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@  %@", [[info objectForKey:@"promoter"] objectForKey:@"real_name"], [[info objectForKey:@"promoter"] objectForKey:@"mobile"]];
    [self.contentView addSubview:self.titleLB];
    
    self.timeLb = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.titleLB.frame) + 5, _titleLB.hd_width, 15)];
    self.timeLb.font = kMainFont_12;
    self.timeLb.textColor = UIColorFromRGB(0x999999);
    self.timeLb.text = [NSString stringWithFormat:@"注册时间：%@", [info objectForKey:@"create_time"]];
    [self.contentView addSubview:self.timeLb];
    
    self.nameLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.iconImageView.frame) + 10, self.hd_width - 70, 15)];
    self.nameLB.textColor = UIColorFromRGB(0x333333);
    self.nameLB.font = kMainFont;
    self.nameLB.text = [NSString stringWithFormat:@"姓名：%@", [[info objectForKey:@"promoter"] objectForKey:@"real_name"]];
    self.nameLB.numberOfLines = 0;
    [self.contentView addSubview:self.nameLB];
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.nameLB.frame) + 10, self.hd_width - 70, 15)];
    self.contentLB.textColor = UIColorFromRGB(0x333333);
    self.contentLB.font = kMainFont;
    self.contentLB.text = [NSString stringWithFormat:@"消费：%@", [[info objectForKey:@"promoter"] objectForKey:@"all_pay"]];
    self.contentLB.numberOfLines = 0;
    [self.contentView addSubview:self.contentLB];
    
    
    UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(kScreenWidth  - 80, 40, 80, 30);
    checkBtn.backgroundColor = kCommonMainBlueColor;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:checkBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = checkBtn.bounds;
    layer.path = path.CGPath;
    [checkBtn.layer setMask:layer];
    
    [checkBtn setTitle:[[info objectForKey:@"promoter"] objectForKey:@"blocked_title"] forState:UIControlStateNormal];
    [checkBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    checkBtn.titleLabel.font = kMainFont_12;
    
    UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(checkBtn.hd_x, checkBtn.hd_y, checkBtn.hd_height, checkBtn.hd_height)];
    blueView.backgroundColor = UIColorFromRGB(0xffffff);
    blueView.layer.cornerRadius = checkBtn.hd_height / 2;
    blueView.layer.masksToBounds = false;
    blueView.layer.shadowColor = kCommonMainBlueColor.CGColor;
    blueView.layer.shadowOpacity = 3;
    blueView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIView * blueView1 = [[UIView alloc]initWithFrame:CGRectMake(checkBtn.hd_x + checkBtn.hd_height / 2, checkBtn.hd_y, checkBtn.hd_width, checkBtn.hd_height)];
    blueView1.backgroundColor = UIColorFromRGB(0xffffff);
    blueView1.layer.shadowColor = kCommonMainBlueColor.CGColor;
    blueView1.layer.shadowOpacity = 3;
    blueView1.layer.shadowOffset = CGSizeMake(0, 0);
    
    [self.contentView addSubview:blueView];
    [self.contentView addSubview:blueView1];
    [self.contentView addSubview:checkBtn];
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
