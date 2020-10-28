//
//  AssociationCommentTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "AssociationCommentTableViewCell.h"

@interface AssociationCommentTableViewCell()

@property (nonatomic, strong)UIImageView * courseCover;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * qunzhuLB;
@property (nonatomic, strong)UILabel * jingpinLB;

@property (nonatomic, strong)UILabel * timeLB;

@property (nonatomic, strong)UILabel * contentLB;

@end

@implementation AssociationCommentTableViewCell

- (void)refreshUIWith:(NSDictionary *)info andIsCanOperation:(BOOL)canOperation
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.infoDic = info;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 0, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    
    self.courseCover = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30,  30)];
    [self.courseCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseCover.layer.cornerRadius = self.courseCover.hd_height / 2;
    self.courseCover.layer.masksToBounds = YES;
    [backView addSubview:self.courseCover];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCover.frame) + 10, self.courseCover.hd_y, self.hd_width - 30, 15)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.numberOfLines = 0;
    self.titleLB.text = [NSString stringWithFormat:@"name"];
    [backView addSubview:self.titleLB];
    [self.titleLB sizeToFit];
    
    self.qunzhuLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLB.frame) + 5, 15, 30, 15)];
    self.qunzhuLB.text = @"群主";
    _qunzhuLB.textColor = UIColorFromRGB(0xffffff);
    _qunzhuLB.textAlignment = NSTextAlignmentCenter;
    _qunzhuLB.font = kMainFont_12;
    _qunzhuLB.backgroundColor = kCommonMainOringeColor;
    [backView addSubview:_qunzhuLB];
    
    self.jingpinLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_qunzhuLB.frame) + 5, 15, 30, 15)];
    self.jingpinLB.text = @"精品";
    _jingpinLB.textColor = UIColorFromRGB(0xffffff);
    _jingpinLB.textAlignment = NSTextAlignmentCenter;
    _jingpinLB.font = kMainFont_12;
    _jingpinLB.backgroundColor = kCommonMainOringeColor;
    [backView addSubview:_jingpinLB];
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_courseCover.frame) + 10, CGRectGetMaxY(_titleLB.frame), 200, 15)];
    _timeLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"time"]];
    _timeLB.textColor = UIColorFromRGB(0x999999);
    _timeLB.font = kMainFont_12;
    [backView addSubview:_timeLB];
    
    
    NSString * contentStr = [info objectForKey:@"content"];
    CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(self.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x , CGRectGetMaxY(_courseCover.frame) + 10, self.hd_width - 70, height)];
    _contentLB.textColor = UIColorFromRGB(0x666666);
    _contentLB.text = [info objectForKey:@"content"];
    _contentLB.numberOfLines = 0;
    _contentLB.font = kMainFont;
    [backView addSubview:_contentLB];
    
    CGFloat spase = 5;
    for (int i = 0; i < [[info objectForKey:@"images"] count]; i++) {
        NSString * imageUrl = [[info objectForKey:@"images"] objectAtIndex:i];
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kCellHeightOfCategoryView + spase) * (i % 3) + 55, CGRectGetMaxY(_contentLB.frame) + 5 + (kCellHeightOfCategoryView + spase) * (i / 3), kCellHeightOfCategoryView, kCellHeightOfCategoryView)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
        [self.contentView addSubview:imageView];
        
    }
    
    
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(_contentLB.hd_x, 0, 130, backView.hd_height);
//    [btn addTarget:self action:@selector(checkDetail) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:btn];
    
    
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 1, backView.hd_width, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
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
