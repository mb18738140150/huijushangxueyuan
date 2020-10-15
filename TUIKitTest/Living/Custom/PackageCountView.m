//
//  PackageCountView.m
//  Accountant
//
//  Created by aaa on 2018/4/17.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "PackageCountView.h"

@implementation PackageCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.musBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.musBtn.frame = CGRectMake(0, 0, 23, 23);
//    [self.musBtn setImage:[UIImage imageNamed:@"count_minus"] forState:UIControlStateNormal];
    [self.musBtn setTitle:@"-" forState:UIControlStateNormal];
    self.musBtn.titleLabel.font = kMainFont_16;
    [self.musBtn setTitleColor:UIColorFromRGB(0xF19937) forState:UIControlStateNormal];
    self.musBtn.layer.borderWidth = 1;
    self.musBtn.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
    
    UIBezierPath *bezier1 = [UIBezierPath bezierPathWithRoundedRect:self.musBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer * layer1 = [[CAShapeLayer alloc]init];
    layer1.frame = self.musBtn.bounds;
    layer1.path = bezier1.CGPath;
    self.musBtn.layer.mask = layer1;
    [self addSubview:self.musBtn];
    
    
    self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.musBtn.frame) - 1, 0, 40, 23)];
    self.countLB.text = @"1";
    self.countLB.layer.borderWidth = 1;
    self.countLB.font = kMainFont;
    self.countLB.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
    self.countLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countLB];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(CGRectGetMaxX(self.countLB.frame) - 1, 0, 23, 23);
//    [self.addBtn setImage:[UIImage imageNamed:@"count_add"] forState:UIControlStateNormal];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    self.addBtn.titleLabel.font = kMainFont_16;
    [self.addBtn setTitleColor:UIColorFromRGB(0xF19937) forState:UIControlStateNormal];
    self.addBtn.layer.borderWidth = 1;
    self.addBtn.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
    UIBezierPath *bezier2 = [UIBezierPath bezierPathWithRoundedRect:self.musBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer * layer2 = [[CAShapeLayer alloc]init];
    layer2.frame = self.musBtn.bounds;
    layer2.path = bezier2.CGPath;
    self.addBtn.layer.mask = layer2;
    [self addSubview:self.addBtn];
    
    [self.musBtn addTarget:self action:@selector(musAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reset
{
    self.countLB.text = @"1";
}

- (void)musAction
{
    if (self.countLB.text.intValue >1) {
        int count = self.countLB.text.intValue - 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.countLB.text = [NSString stringWithFormat:@"%d", count];
            [self changeCount];
        });
    }
}

- (void)addAction
{
    int count = self.countLB.text.intValue + 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.countLB.text = [NSString stringWithFormat:@"%d", count];
        [self changeCount];
    });
}

- (void)changeCount
{
    if (self.countBlock) {
        self.countBlock(self.countLB.text.intValue);
    }
}

@end
