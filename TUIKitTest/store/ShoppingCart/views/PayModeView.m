//
//  payModeView.m
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "PayModeView.h"

@implementation PayModeView

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
    self.selectStateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 5, 23, 23)];;
    self.selectStateImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.selectStateImageView];
    
    self.modeStrLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectStateImageView.frame) + 5, self.selectStateImageView.hd_y, 200, 23)];
    self.modeStrLB.textColor = UIColorFromRGB(0x000000);
    self.modeStrLB.font = kMainFont_12;
    [self addSubview:self.modeStrLB];
    
    self.selectStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectStateBtn.frame = CGRectMake(self.hd_width - 37, self.selectStateImageView.hd_y + 1, 16, 16);
    self.selectStateBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.selectStateBtn];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = self.bounds;
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backBtn];
}

- (void)refreshContentWithModeImage:(UIImage *)modeImage andModeStr:(NSString *)modeStr andSelectNomalImage:(UIImage *)nomalImage andSelect_selectesImage:(UIImage *)selectImage
{
    self.selectStateImageView.image = modeImage;
    self.modeStrLB.text = modeStr;
    
    [self.selectStateBtn setImage:nomalImage forState:UIControlStateNormal];
    [self.selectStateBtn setImage:selectImage forState:UIControlStateSelected];
}
- (void)refreshContentWithModeImage:(UIImage *)modeImage andModeAttributeStr:(NSMutableAttributedString *)modeStr andSelectNomalImage:(UIImage *)nomalImage andSelect_selectesImage:(UIImage *)selectImage
{
    self.selectStateImageView.image = modeImage;
    self.modeStrLB.attributedText = modeStr;
    
    [self.selectStateBtn setImage:nomalImage forState:UIControlStateNormal];
    [self.selectStateBtn setImage:selectImage forState:UIControlStateSelected];
}

@end
