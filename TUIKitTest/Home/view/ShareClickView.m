//
//  ShareClickView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/23.
//

#import "ShareClickView.h"

@interface ShareClickView()

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * titleLB;


@end

@implementation ShareClickView

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
    
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(3, 3, self.width - 3, self.hd_height - 6)];
    self.backView.backgroundColor = UIColorFromRGB(0xffffff);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(_backView.hd_height / 2, _backView.hd_height / 2)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = _backView.bounds;
    layer.path = path.CGPath;
    [self.backView.layer setMask:layer];
    
    
    UIView * shadowView = [[UIView alloc]initWithFrame:CGRectMake(_backView.hd_height / 2 + 3, 3, self.hd_width - _backView.hd_height / 2 - 3, _backView.hd_height)];
    shadowView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shadowView];
    shadowView.layer.shadowColor = UIColorFromRGB(0xaaaaaa).CGColor;
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowOffset = CGSizeMake(0, 1);
    shadowView.layer.shadowRadius = 3;
    
    [self addSubview:_backView];
    
    UIView * imageBack = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, _backView.hd_height, _backView.hd_height)];
    imageBack.layer.cornerRadius = _backView.hd_height / 2;
    imageBack.layer.masksToBounds = YES;
    imageBack.backgroundColor = kCommonMainBlueColor;
    [_backView addSubview:imageBack];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, imageBack.hd_height - 10, imageBack.hd_height - 10)];
    self.imageView.image = [UIImage imageNamed:@"fenxiang"];
    [imageBack addSubview:self.imageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(imageBack.hd_width, 0, _backView.hd_width - imageBack.hd_width, _backView.hd_height)];
    self.titleLB.text = @"分享";
    self.titleLB.font = kMainFont;
    self.titleLB.textColor = kCommonMainBlueColor;
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:self.titleLB];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = _backView.bounds;
    [btn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:btn];
}

- (void)shareAction
{
    if (self.shareBlock) {
        self.shareBlock(@{});
    }
}

@end
