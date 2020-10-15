//
//  ShowQRCodeView.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ShowQRCodeView.h"

@implementation ShowQRCodeView

- (instancetype)initWithFrame:(CGRect)frame andUrl:(NSString *)imageUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageUrl = imageUrl;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor clearColor];
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:backView];
    
    UIView * qrCodeView = [[UIView alloc]initWithFrame:CGRectMake(self.hd_width / 4, self.hd_height / 3 , self.hd_width / 2, self.hd_height / 3)];
    qrCodeView.backgroundColor = UIColorFromRGB(0xffffff);
    qrCodeView.layer.cornerRadius = 5;
    qrCodeView.layer.masksToBounds = YES;
    [self addSubview:qrCodeView];
    
    UIImageView * qrCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, qrCodeView.hd_width - 40, qrCodeView.hd_width - 40)];
    [qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[[UIImage imageNamed:@"img_km0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] options:SDWebImageAllowInvalidSSLCertificates];
    [qrCodeView addSubview:qrCodeImageView];
    
    UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(qrCodeImageView.frame), qrCodeView.hd_width, qrCodeView.hd_height - CGRectGetMaxY(qrCodeImageView.frame))];
    tipLB.text = @"长按识别二维码";
    tipLB.textColor = UIColorFromRGB(0x666666);
    tipLB.font = kMainFont;
    [qrCodeView addSubview:tipLB];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.hd_width / 2 - 20, CGRectGetMaxY(qrCodeView.frame) + 10, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    closeBtn.backgroundColor = UIColorFromRGB(0x999999);
    [self addSubview:closeBtn];
    
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)closeAction
{
    [self removeFromSuperview];
}

@end
