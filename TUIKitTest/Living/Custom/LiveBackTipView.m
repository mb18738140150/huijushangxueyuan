//
//  LiveBackTipView.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/12.
//

#import "LiveBackTipView.h"

@implementation LiveBackTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
    [backView addGestureRecognizer:tap];
    
    CGFloat height = (kScreenWidth - 100) / 4.8 + 20 + 15 + 20 + 15 + 20 + 30 + 20;
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(50, kScreenHeight / 2  - height / 2, kScreenWidth - 100, height)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    
    UIImageView * topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentView.hd_width, (kScreenWidth - 100) / 4.8 )];
    topImageView.image = [UIImage imageNamed:@"alive_count_down"];
    [contentView addSubview:topImageView];
    
    UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame) + 10, contentView.hd_width, 15)];
    tipLB.text = @"直播已结束";
    tipLB.textColor = kCommonMainRedColor;
    tipLB.textAlignment = NSTextAlignmentCenter;
    tipLB.font = kMainFont_10;
    [contentView addSubview:tipLB];
    
    UILabel * tipLB1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLB.frame) + 10, contentView.hd_width, 15)];
    tipLB1.text = @"您可以回看全部内容";
    tipLB1.textColor = UIColorFromRGB(0x999999);
    tipLB1.textAlignment = NSTextAlignmentCenter;
    tipLB1.font = kMainFont;
    [contentView addSubview:tipLB1];
    
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(30, CGRectGetMaxY(tipLB1.frame) + 30, contentView.hd_width - 60, 30);
    playBtn.layer.cornerRadius = playBtn.hd_height / 2;
    playBtn.layer.masksToBounds = YES;
    
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = playBtn.bounds;
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = playBtn.bounds;
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIRGBColor(77, 201, 134) CGColor],(id)[UIRGBColor(80, 199, 170) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0, @0.5, @1]];
    [gradientLayer1 setStartPoint:CGPointMake(0, 0.5)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 0.5)];
    [gradientLayer addSublayer:gradientLayer1];
    [playBtn.layer addSublayer:gradientLayer];
    
    
    [playBtn setTitle:@"开始回看" forState:UIControlStateNormal];
    [playBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    playBtn.titleLabel.font = kMainFont;
    [playBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:playBtn];
}

- (void)dismissAction
{
    [self removeFromSuperview];
}

@end
