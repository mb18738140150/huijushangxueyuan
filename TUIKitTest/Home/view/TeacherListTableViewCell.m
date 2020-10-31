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
@property (nonatomic, strong)UIButton *blackBtn;
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
    self.titleLB.textColor = UIColorFromRGB(0x666666);
    self.titleLB.font = kMainFont_10;
    self.titleLB.numberOfLines = 0;
    
    NSString * nameStr = [NSString stringWithFormat:@"%@\n%@", [info objectForKey:@"nickname"],[UIUtility judgeStr:[info objectForKey:@"title"]]];
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:nameStr];
    NSDictionary* attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
    [mStr setAttributes:attribute range:NSMakeRange(0, [[info objectForKey:@"nickname"] length])];
    self.titleLB.attributedText = mStr;
    
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

- (void)refreshHeadUIWith:(NSDictionary *)info andCornerType:(CellCornerType)cornertype
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.infoDic = info;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    
    self.courseCover = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 70, 70)];
    [self.courseCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseCover.layer.cornerRadius = self.courseCover.hd_height / 2;
    self.courseCover.layer.masksToBounds = YES;
    [backView addSubview:self.courseCover];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCover.frame) + 15, self.courseCover.hd_y, self.hd_width - 30, self.courseCover.hd_height)];
    self.titleLB.textColor = UIColorFromRGB(0x666666);
    self.titleLB.font = kMainFont_10;
    self.titleLB.numberOfLines = 0;
    
    NSString * nameStr = [NSString stringWithFormat:@"%@\n%@", [info objectForKey:@"nickname"],[info objectForKey:@"title"]];
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:nameStr];
    NSDictionary* attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
    [mStr setAttributes:attribute range:NSMakeRange(0, [[info objectForKey:@"nickname"] length])];
    self.titleLB.attributedText = mStr;
    
    [backView addSubview:self.titleLB];
    
    UIView * shoppingCarView = [[UIView alloc]initWithFrame:CGRectMake( backView.hd_width - 60, _courseCover.hd_centerY - 24, 49, 49)];
       shoppingCarView.backgroundColor = [UIColor whiteColor];
       [backView addSubview:shoppingCarView];
    
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake( 0, 10, 45, 30);
    shareBtn.center = shoppingCarView.center;
    
    shareBtn.backgroundColor = [UIColor whiteColor];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shareBtn setImage:[UIImage imageNamed:@"blackShare"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:kMainTextColor_100 forState:UIControlStateNormal];
    [self clicked:shareBtn];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:shareBtn];
    
    NSString * htmlString = [UIUtility judgeStr:[info objectForKey:@"desc"]];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ,NSFontAttributeName:kMainFont} documentAttributes:nil error:nil];
    
    if ([attrStr length] > 0) {
        
        CGFloat height = [attrStr boundingRectWithSize:CGSizeMake(backView.hd_width - 45, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        if (height > 35) {
            height = 35;
        }
        
        UILabel * descLB = [[UILabel alloc]initWithFrame:CGRectMake(_courseCover.hd_x, CGRectGetMaxY(_courseCover.frame) + 15, backView.hd_width - 45, height)];
        descLB.attributedText = attrStr;
        descLB.font = kMainFont;
        descLB.numberOfLines = 0;
        descLB.textColor = UIColorFromRGB(0x666666);
        [backView addSubview:descLB];
        
        _goImage = [[UIImageView alloc]initWithFrame:CGRectMake(backView.hd_width - 30, descLB.hd_centerY - 6, 12, 12)];
        _goImage.image = [UIImage imageNamed:@"living_编组3"];
        [backView addSubview:_goImage];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(backView.hd_width - 40, _goImage.hd_y - 10 , 30, _goImage.hd_height + 20);
        [btn addTarget:self action:@selector(checkDetail) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        
    }
}

- (void)refreshMemberUIWith:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.infoDic = info;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 0, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    self.courseCover = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, backView.hd_height - 20, backView.hd_height - 20)];
    [self.courseCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseCover.layer.cornerRadius = self.courseCover.hd_height / 2;
    self.courseCover.layer.masksToBounds = YES;
    [backView addSubview:self.courseCover];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCover.frame) + 15, self.courseCover.hd_y, self.hd_width - 30, self.courseCover.hd_height)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.text = [NSString stringWithFormat:@"%@", [UIUtility judgeStr:[info objectForKey:@"c_name"]]];
    
    [backView addSubview:self.titleLB];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth - 100, 0, 80, self.hd_height);
    if ([[info objectForKey:@"is_black"] intValue] == 1) {
        [button setTitle:@"加入黑名单" forState:UIControlStateNormal];
    }else
    {
        [button setTitle:@"移出黑名单" forState:UIControlStateNormal];
    }
    button.titleLabel.font = kMainFont;
    [button setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(blackAction) forControlEvents:UIControlEventTouchUpInside];
    button.hidden = YES;
    self.blackBtn = button;
    [self.contentView addSubview:button];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(15, self.hd_height - 1, backView.hd_width - 30, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
}

- (void)resetEditBtn:(BOOL)canEdit
{
    if (canEdit) {
        self.blackBtn.hidden = NO;
    }else
    {
        self.blackBtn.hidden = YES;
    }
}

- (void)blackAction{
    if (self.blackBlock) {
        self.blackBlock(self.infoDic);
    }
}

- (void)clicked:(UIButton *)btn3
{
    CGPoint center = btn3.center;
    [btn3 sizeToFit];
    btn3.center = center;
    
    float titleXOffset = btn3.imageView.frame.size.width/2;
    float titleYOffset = btn3.imageView.frame.size.height/2;
    btn3.titleEdgeInsets = UIEdgeInsetsMake(titleYOffset, -titleXOffset, -titleYOffset, titleXOffset);
    float imageXoffset = btn3.titleLabel.frame.size.width/2;
    float imageYoffset = btn3.titleLabel.frame.size.height/2;
    btn3.imageEdgeInsets = UIEdgeInsetsMake(-imageYoffset, imageXoffset, imageYoffset, -imageXoffset);

}

- (void)shareAction
{
    if (self.shareBlock) {
        self.shareBlock(self.infoDic);
    }
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
