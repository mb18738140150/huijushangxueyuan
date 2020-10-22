//
//  CommodityBannerTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import "CommodityBannerTableViewCell.h"

#import "MainViewMacro.h"
#import "SDCycleScrollView.h"

@interface CommodityBannerTableViewCell()

@property (nonatomic,strong) SDCycleScrollView          *bannerScrollView;
@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * titleImageView;
@property (nonatomic, strong)UILabel * detailsLB;
@property (nonatomic, strong)UIImageView *backimageView;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic,assign)CGFloat height;

@end

@implementation CommodityBannerTableViewCell

- (void)resetSubviews
{
    [self.contentView removeAllSubviews];
    [self.backView removeFromSuperview];
    [self.titleImageView removeFromSuperview];
    [self.detailsLB removeFromSuperview];
    [self.bannerScrollView removeFromSuperview];
    
    self.bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 0, 0, self.hd_width , self.hd_width) imageNamesGroup:self.bannerImgUrlArray];
    self.bannerScrollView.autoScrollTimeInterval = 10;
    [self.contentView addSubview:self.bannerScrollView];
    __weak typeof(self)weakSelf = self;
    self.bannerScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        if (weakSelf.bannerClickBlock) {
            weakSelf.bannerClickBlock(@{@"index":@(currentIndex)});
        }
    };
    
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
