//
//  LivingStateView.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "LivingStateView.h"

@interface LivingStateView()

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIButton * stateBtn;

@end

@implementation LivingStateView

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
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.backView];
    
    self.stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stateBtn.frame = CGRectMake(0, 0, 100, 20);
    

}

- (void)setLivingState:(HomeLivingStateType)livingState
{
    _livingState = livingState;
    
    switch (livingState) {
        case HomeLivingStateType_living:
        {
            self.backView.frame = CGRectMake(0, 0, 78, 20);
            self.backView.layer.cornerRadius = 2;
            self.backView.layer.masksToBounds = YES;
            self.stateBtn.frame = self.backView.bounds;
            
            self.stateBtn.frame = CGRectMake(0, 0, 78, 20);
            self.stateBtn.backgroundColor = UIColorFromRGB(0x2A75ED);
            [self.stateBtn setImage:[UIImage imageNamed:@"homeLivingTipImage"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"直播中" forState:UIControlStateNormal];
            [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            self.stateBtn.titleLabel.font = kMainFont_12;
        }
            break;
        case HomeLivingStateType_end:
        {
            self.backView.frame = CGRectMake(0, 0, 53, 20);
            self.backView.layer.cornerRadius = 2;
            self.backView.layer.masksToBounds = YES;
            self.stateBtn.frame = self.backView.bounds;
            
            self.stateBtn.backgroundColor = UIColorFromRGB(0x000000);
            [self.stateBtn setImage:[UIImage imageNamed:@"homeLivingTipImage"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"已结束" forState:UIControlStateNormal];
            [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            self.stateBtn.titleLabel.font = kMainFont_12;
            
        }
            break;
        case HomeLivingStateType_noStart:
        {
            self.stateBtn.backgroundColor = [UIColor clearColor];
        }
            break;
        case HomeLivingStateType_video:
        {
            self.backView.frame = CGRectMake(0, 0, 53, 20);
            self.stateBtn.frame = self.backView.bounds;
            
            self.stateBtn.backgroundColor = [UIColor clearColor];
            UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
            shapLayer.frame = self.backView.bounds;
            shapLayer.path = bezierpath.CGPath;
            [self.backView.layer setMask: shapLayer];
            
            [self.stateBtn setImage:[UIImage imageNamed:@"home_video"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"视频" forState:UIControlStateNormal];
            [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            self.stateBtn.titleLabel.font = kMainFont_12;
        }
            break;
        case HomeLivingStateType_audio:
        {
            self.backView.frame = CGRectMake(0, 0, 53, 20);
            self.stateBtn.frame = self.backView.bounds;
            
            self.stateBtn.backgroundColor = [UIColor clearColor];
            UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
            shapLayer.frame = self.backView.bounds;
            shapLayer.path = bezierpath.CGPath;
            [self.backView.layer setMask: shapLayer];
            
            [self.stateBtn setImage:[UIImage imageNamed:@"home_audio"] forState:UIControlStateNormal];
            [self.stateBtn setTitle:@"音频" forState:UIControlStateNormal];
            [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            self.stateBtn.titleLabel.font = kMainFont_12;
        }
            break;
            case HomeLivingStateType_image:
            {
                self.backView.frame = CGRectMake(0, 0, 53, 20);
                self.stateBtn.frame = self.backView.bounds;
                
                self.stateBtn.backgroundColor = [UIColor clearColor];
                UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
                shapLayer.frame = self.backView.bounds;
                shapLayer.path = bezierpath.CGPath;
                [self.backView.layer setMask: shapLayer];
                
                [self.stateBtn setImage:[UIImage imageNamed:@"home_imageAndText"] forState:UIControlStateNormal];
                [self.stateBtn setTitle:@"图片" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                self.stateBtn.titleLabel.font = kMainFont_12;
            }
                break;
            case HomeLivingStateType_imageAndText:
            {
                self.backView.frame = CGRectMake(0, 0, 53, 20);
                self.stateBtn.frame = self.backView.bounds;
                
                self.stateBtn.backgroundColor = [UIColor clearColor];
                UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
                CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
                shapLayer.frame = self.backView.bounds;
                shapLayer.path = bezierpath.CGPath;
                [self.backView.layer setMask: shapLayer];
                
                [self.stateBtn setImage:[UIImage imageNamed:@"home_imageAndText"] forState:UIControlStateNormal];
                [self.stateBtn setTitle:@"图文" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                self.stateBtn.titleLabel.font = kMainFont_12;
            }
                break;
        case HomeLivingStateType_LivingList:
        {
            self.backView.frame = CGRectMake(0, 0, 53, 20);
            self.stateBtn.frame = self.backView.bounds;
            
            self.stateBtn.backgroundColor = [UIColor clearColor];
            UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
            shapLayer.frame = self.backView.bounds;
            shapLayer.path = bezierpath.CGPath;
            [self.backView.layer setMask: shapLayer];
        }
            break;
            case HomeLivingStateType_imageAndText_right:
            {
                self.backView.frame = CGRectMake(0, 0, 53, 20);
                self.stateBtn.frame = self.backView.bounds;
                self.backView.layer.cornerRadius = 2;
                self.backView.layer.masksToBounds = YES;
                
                [self.stateBtn setImage:[UIImage imageNamed:@"home_imageAndText"] forState:UIControlStateNormal];
                [self.stateBtn setTitle:@"图文" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                self.stateBtn.titleLabel.font = kMainFont_12;
            }
                break;
            case HomeLivingStateType_image_right:
            {
                self.backView.frame = CGRectMake(0, 0, 53, 20);
                self.stateBtn.frame = self.backView.bounds;
                self.backView.layer.cornerRadius = 2;
                self.backView.layer.masksToBounds = YES;
                
                [self.stateBtn setImage:[UIImage imageNamed:@"home_imageAndText"] forState:UIControlStateNormal];
                [self.stateBtn setTitle:@"图片" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                self.stateBtn.titleLabel.font = kMainFont_12;
            }
                break;
            case HomeLivingStateType_audio_right:
            {
                self.backView.frame = CGRectMake(0, 0, 53, 20);
                self.stateBtn.frame = self.backView.bounds;
                self.backView.layer.cornerRadius = 2;
                self.backView.layer.masksToBounds = YES;
                
                [self.stateBtn setImage:[UIImage imageNamed:@"home_audio"] forState:UIControlStateNormal];
                [self.stateBtn setTitle:@"音频" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                self.stateBtn.titleLabel.font = kMainFont_12;
            }
                break;
            case HomeLivingStateType_video_right:
            {
                self.backView.frame = CGRectMake(0, 0, 53, 20);
                self.stateBtn.frame = self.backView.bounds;
                self.backView.layer.cornerRadius = 2;
                self.backView.layer.masksToBounds = YES;
                
                [self.stateBtn setImage:[UIImage imageNamed:@"home_video"] forState:UIControlStateNormal];
                [self.stateBtn setTitle:@"视频" forState:UIControlStateNormal];
                
                [self.stateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                self.stateBtn.titleLabel.font = kMainFont_12;
            }
                break;
        default:
            break;
    }
    self.stateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [self.backView addSubview:self.stateBtn];
}

@end
