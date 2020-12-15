//
//  MainOpenVIPCardTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import "MainOpenVIPCardTableViewCell.h"

@implementation MainOpenVIPCardTableViewCell


- (void)resetUIWithInfo:(NSDictionary *)info
{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 60
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 10, self.hd_width - 35, 40)];
    CAGradientLayer *paylayer = [[CAGradientLayer alloc]init];
    paylayer.frame = self.backView.bounds;
    paylayer.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xF4E0A6) CGColor],(id)[UIColorFromRGB(0xE2C27E) CGColor], nil];
    paylayer.startPoint = CGPointMake(0, 0.5);
    paylayer.endPoint = CGPointMake(1, 0.5);
    [self.backView.layer addSublayer:paylayer];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.backView];
    
    self.vipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 14, 18, 13)];
    self.vipImageView.image = [UIImage imageNamed:@"huiyuan1-01"];
    [self.backView addSubview:self.vipImageView];
    
    self.vipTitleView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.vipImageView.frame) + 10, 0, 120, self.backView.hd_height)];
    self.vipTitleView.text = @"略知课堂会员";
    self.vipTitleView.font = kMainFont;
    self.vipTitleView.textColor = UIColorFromRGB(0x3D3731);
    [self.backView addSubview:self.vipTitleView];
    
    self.openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openBtn.frame = CGRectMake(self.backView.hd_width - 120, 10, 110, 20);
    [self.openBtn setTitle:@"尊享专属会员权益" forState:UIControlStateNormal];
    [self.openBtn setTitleColor:UIColorFromRGB(0x3D3731) forState:UIControlStateNormal];
    [self.openBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    self.openBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.openBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, -100);
    self.openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self.backView addSubview:self.openBtn];
    
    [self.openBtn addTarget:self action:@selector(openVipAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)resetContent:(NSDictionary *)info
{
    self.vipTitleView.text = [info objectForKey:@"title"];
    
    if([info objectForKey:@"image"])
    {
        self.vipImageView.image = [UIImage imageNamed:@"image"];
    }
    
    NSString * btnStr = [info objectForKey:@"btn"];
    CGFloat width = [btnStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.width;
    [self.openBtn setTitle:[info objectForKey:@"btn"] forState:UIControlStateNormal];
    [self.openBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    self.openBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.openBtn.imageEdgeInsets = UIEdgeInsetsMake(0, width + 5, 0, -width - 5);
    self.openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
}

- (void)hiddenAllSubView
{
    self.contentView.hidden = YES;
}

- (void)openVipAction
{
    if (self.openVIPBlock) {
        self.openVIPBlock(@{});
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
