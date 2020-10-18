//
//  MyNotificationTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/16.
//

#import "MyNotificationTableViewCell.h"

@interface MyNotificationTableViewCell()

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * timeLB;
@property (nonatomic, strong)UILabel * contentLB;
@property (nonatomic, strong)UILabel * tipLB;
@property (nonatomic, strong)UIButton * lookBtn;

@end

@implementation MyNotificationTableViewCell

- (void)refreshUIWith:(NSDictionary *)info
{
    self.info = info;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    NSString * titleStr = [info objectForKey:@"content"];
    CGFloat titleHeight = [titleStr boundingRectWithSize:CGSizeMake(self.hd_width - 30 - 30 - 140, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    CGFloat contentHeight = [titleStr boundingRectWithSize:CGSizeMake(self.hd_width - 30 - 30 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(15, 5, self.hd_width - 30, 10 + titleHeight + 10 + contentHeight + 10 + 40)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, backView.hd_width - 30 - 140, titleHeight + 5)];
    _titleLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"content"]];
    _titleLB.font = [UIFont boldSystemFontOfSize:14];
    _titleLB.textColor = UIColorFromRGB(0x000000);
    _titleLB.numberOfLines = 0;
    [backView addSubview:_titleLB];
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(backView.hd_width - 155, 7, 140, titleHeight + 5)];
    _timeLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"time"]];
    _timeLB.font = kMainFont_12;
    _timeLB.textAlignment = NSTextAlignmentRight;
    _timeLB.textColor = UIColorFromRGB(0x999999);
    [backView addSubview:_timeLB];
    
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_titleLB.frame) + 8, backView.hd_width - 30, contentHeight + 5)];
    _contentLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"content"]];
    _contentLB.font = kMainFont;
    _contentLB.textColor = UIColorFromRGB(0x666666);
    _contentLB.numberOfLines = 0;
    [backView addSubview:_contentLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_contentLB.frame) + 8, backView.hd_width - 30, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
    self.tipLB = [[UILabel alloc]initWithFrame:CGRectMake( 15, CGRectGetMaxY(separateView.frame) + 10, 100, 20)];
    _tipLB.text = @"通知";
    _tipLB.font = kMainFont;
    _tipLB.textColor = UIColorFromRGB(0x333333);
    [backView addSubview:_tipLB];
    
    self.lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookBtn.frame = CGRectMake(backView.hd_width - 80, CGRectGetMaxY(separateView.frame), 80, 40);
    [_lookBtn setTitle:@"点击进入" forState:UIControlStateNormal];
    [_lookBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    _lookBtn.titleLabel.font = kMainFont_12;
    [backView addSubview:_lookBtn];
    
    [_lookBtn addTarget:self action:@selector(lookAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)lookAction
{
    if (self.lookNotificationBlock) {
        self.lookNotificationBlock(self.info);
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
