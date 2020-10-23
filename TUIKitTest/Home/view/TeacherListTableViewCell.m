//
//  TeacherListTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import "TeacherListTableViewCell.h"

@interface TeacherListTableViewCell()

@property (nonatomic, strong)UIImageView * courseCover;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, strong)UIImageView * goImage;

@end

@implementation TeacherListTableViewCell

- (void)refreshUIWith:(NSDictionary *)info andCornerType:(CellCornerType)cornertype;
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.infoDic = info;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.hd_width - 20, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    if (cornertype == CellCornerType_top) {
        UIBezierPath * topBPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer * layer = [[CAShapeLayer alloc]init];
        layer.frame = backView.bounds;
        layer.path = topBPath.CGPath;
        [backView.layer setMask:layer];
    }else if (cornertype == CellCornerType_bottom)
    {
        UIBezierPath * topBPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer * layer = [[CAShapeLayer alloc]init];
        layer.frame = backView.bounds;
        layer.path = topBPath.CGPath;
        [backView.layer setMask:layer];
    }
    
    
    self.courseCover = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, backView.hd_height - 30, backView.hd_height - 30)];
    [self.courseCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseCover.layer.cornerRadius = self.courseCover.hd_height / 2;
    self.courseCover.layer.masksToBounds = YES;
    [backView addSubview:self.courseCover];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCover.frame) + 15, self.courseCover.hd_y, self.hd_width - 30, self.courseCover.hd_height)];
    self.titleLB.text = [info objectForKey:@"nickname"];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.numberOfLines = 0;
    [backView addSubview:self.titleLB];
    
    
    _goImage = [[UIImageView alloc]initWithFrame:CGRectMake(backView.hd_width - 30, backView.hd_height / 2 - 6, 12, 12)];
    _goImage.image = [UIImage imageNamed:@"living_编组3"];
    [backView addSubview:_goImage];
    
    self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(self.goImage.hd_x - 120, _titleLB.hd_y, 110, _titleLB.hd_height)];
    self.countLB.textColor = kCommonMainBlueColor;
    self.countLB.text = @"进入主页";
    self.countLB.textAlignment = NSTextAlignmentRight;
    self.countLB.font = kMainFont_12;
    [backView addSubview:self.countLB];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_countLB.hd_x, 0, 130, backView.hd_height);
    [btn addTarget:self action:@selector(checkDetail) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 1, backView.hd_width, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
}

- (void)checkDetail{
    if (self.checkDetailBlock) {
        self.checkDetailBlock(self.infoDic);
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
