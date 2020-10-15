//
//  HomeBannerCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeBannerCollectionViewCell.h"
#import "UIMacro.h"
#import "MainViewMacro.h"
#import "SDCycleScrollView.h"

@interface HomeBannerCollectionViewCell()

@property (nonatomic,strong) SDCycleScrollView          *bannerScrollView;
@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * titleImageView;
@property (nonatomic, strong)UILabel * detailsLB;
@property (nonatomic, strong)UIImageView *backimageView;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic,assign)CGFloat height;

@end

@implementation HomeBannerCollectionViewCell

- (void)resetSubviews
{
    [self.contentView removeAllSubviews];
    [self.backView removeFromSuperview];
    [self.titleImageView removeFromSuperview];
    [self.detailsLB removeFromSuperview];
    [self.bannerScrollView removeFromSuperview];
    
    
    self.y = 0;
    self.height = 125;
//    if (kTabBarHeight == 83) {
//        self.y = -20;
//        self.height = 145;
//    }
    
    self.bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 17.5, self.y, self.hd_width - 35 , (self.hd_width - 35) * 0.45) imageNamesGroup:self.bannerImgUrlArray];
    self.bannerScrollView.autoScrollTimeInterval = 10;
    self.bannerScrollView.layer.cornerRadius = 5;
    self.bannerScrollView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bannerScrollView];
    
     self.backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.y, kScreenWidth, self.height)];
    self.backimageView.image = [UIImage imageNamed:@"zw_pic"];
    
    if (self.bannerImgUrlArray.count == 0) {
        [self.contentView addSubview:self.backimageView];
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)resetCornerRadius:(CGFloat)radius
{
    self.bannerScrollView.layer.cornerRadius = radius;
    self.bannerScrollView.layer.masksToBounds = YES;
}

- (void)setupView
{
    self.bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, self.y, kScreenWidth, self.height) imageNamesGroup:self.bannerImgUrlArray];
    self.bannerScrollView.autoScrollTimeInterval = 10;
    [self addSubview:self.bannerScrollView];
}


@end
