//
//  JoinAssociationHeadTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "JoinAssociationHeadTableViewCell.h"

@implementation JoinAssociationHeadTableViewCell

- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    float cellWidth = self.contentView.hd_width;
    self.info = info;
    // 100
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    // teacher
    self.groupIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.hd_width / 2 - 50, 15, 100, 100)];
    [self.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"thumb"]] placeholderImage:[[UIImage imageNamed:@"courseDefaultImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
    self.groupIconImageView.layer.cornerRadius = kMainCornerRadius * 2;
    self.groupIconImageView.layer.masksToBounds = YES;
    [backView addSubview:self.groupIconImageView];
    
    // 课程名称
    self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_groupIconImageView.frame) + 15, backView.hd_width , 20)];
    self.courseNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.courseNameLabel.textColor = UIColorFromRGB(0x000000);
    self.courseNameLabel.text = [info objectForKey:@"title"];
    self.courseNameLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.courseNameLabel];
    
    // content
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseNameLabel.hd_x, CGRectGetMaxY(self.courseNameLabel.frame) + 10, self.courseNameLabel.hd_width , 20)];
    self.contentLabel.font = kMainFont_12;
    self.contentLabel.textColor = UIColorFromRGB(0x999999);
    self.contentLabel.text = [NSString stringWithFormat:@"%@人加入",[info objectForKey:@"user_num"]];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.contentLabel];
    
    
    NSString * descStr = [info objectForKey:@"description"]!= nil ? [info objectForKey:@"description"] : @"";
    self.descLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) + 10, self.courseNameLabel.hd_width- 20 , 30)];
    self.descLB.font = kMainFont_12;
    self.descLB.textColor = UIColorFromRGB(0x333333);
    self.descLB.text = descStr;
    self.descLB.numberOfLines = 0;
    self.descLB.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.descLB];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(backView.hd_width / 2 - 60, CGRectGetMaxY(_descLB.frame) + 10, 120, 30);
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderColor = kCommonMainBlueColor.CGColor;
    _cancelBtn.layer.borderWidth = 1;
    [self.cancelBtn setTitle:@"邀请好友加入" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = kMainFont;
    
    [self.cancelBtn addTarget:self action:@selector(cancelOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.cancelBtn];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 10, backView.hd_width , 10)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
}
    
- (void)resetDetailCellContent:(NSDictionary *)info
{
    self.info = info;
    if (!self.zixunSegment) {
    
        [self.contentView removeAllSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        float cellWidth = self.contentView.hd_width;
        
        // 100
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 54)];
        [self.contentView addSubview:imageView];
        self.backImageView = imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"back_img"]] placeholderImage:[[UIImage imageNamed:@"courseDefaultImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
        effectView.alpha = 0.9;
        [imageView addSubview:effectView];
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height - 54)];
        backView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:backView];
        
        
        // teacher
        self.groupIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.hd_width / 2 - 35, 15, 70, 70)];
        [self.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"thumb"]] placeholderImage:[[UIImage imageNamed:@"courseDefaultImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
        self.groupIconImageView.layer.cornerRadius = kMainCornerRadius * 2;
        self.groupIconImageView.layer.masksToBounds = YES;
        [backView addSubview:self.groupIconImageView];
        
        // 课程名称
        self.courseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_groupIconImageView.frame) + 15, backView.hd_width , 20)];
        self.courseNameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.courseNameLabel.textColor = UIColorFromRGB(0xffffff);
        self.courseNameLabel.text = [info objectForKey:@"title"];
        self.courseNameLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:self.courseNameLabel];
        
        // content
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseNameLabel.hd_x, CGRectGetMaxY(self.courseNameLabel.frame) + 10, self.courseNameLabel.hd_width , 20)];
        self.contentLabel.font = kMainFont_12;
        self.contentLabel.textColor = UIColorFromRGB(0xffffff);
        self.contentLabel.text = [NSString stringWithFormat:@"%@人加入",[info objectForKey:@"user_num"]];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:self.contentLabel];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(backView.hd_width / 2 - 85, CGRectGetMaxY(_contentLabel.frame) + 10, 75, 30);
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        _cancelBtn.layer.borderWidth = 1;
        [self.cancelBtn setTitle:@"社群中心" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = kMainFont;
        
        self.storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.storeBtn.frame = CGRectMake(backView.hd_width / 2 + 10, CGRectGetMaxY(_contentLabel.frame) + 10, 75, 30);
        _storeBtn.layer.cornerRadius = 5;
        _storeBtn.layer.masksToBounds = YES;
        _storeBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        _storeBtn.layer.borderWidth = 1;
        [self.storeBtn setTitle:@"知识店铺" forState:UIControlStateNormal];
        [self.storeBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        self.storeBtn.titleLabel.font = kMainFont;
        
        [self.cancelBtn addTarget:self action:@selector(centerAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:self.cancelBtn];
        [self.storeBtn addTarget:self action:@selector(storeAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:self.storeBtn];
        
        self.zixunSegment = [[ZWMSegmentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame), self.contentView.hd_width , 44) titles:@[@"全部动态",@"精选动态",@"群主动态"]];
        _zixunSegment.backgroundColor=[UIColor whiteColor];
        _zixunSegment.segmentTintColor = kCommonMainBlueColor;
        _zixunSegment.segmentNormalColor = UIColorFromRGB(0x333333);
        _zixunSegment.indicateColor = kCommonMainBlueColor;
        [self addSubview:_zixunSegment];
        
        UIView * sortView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_zixunSegment.frame), kScreenWidth, 10)];
        sortView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:sortView];
    }
    
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"back_img"]] placeholderImage:[[UIImage imageNamed:@"courseDefaultImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
    
    [self.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"thumb"]] placeholderImage:[[UIImage imageNamed:@"courseDefaultImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseNameLabel.text = [info objectForKey:@"title"];
    self.contentLabel.text = [NSString stringWithFormat:@"%@人加入",[info objectForKey:@"user_num"]];
    
//    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, self., backView.hd_width - 30, 1)];
//    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    [backView addSubview:separateView];
    
}


- (void)cancelOrderAction
{
    if (self.activeBlock) {
        self.activeBlock();
    }
}

- (void)centerAction
{
    if (self.centerBlock) {
        self.centerBlock(self.info);
    }
}

- (void)storeAction
{
    if (self.storeBlock) {
        self.storeBlock(self.info);
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
