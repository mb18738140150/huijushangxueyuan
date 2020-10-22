//
//  CommodityBannerTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommodityBannerTableViewCell : UITableViewCell

@property (nonatomic,strong) NSArray *bannerImgUrlArray;
@property (nonatomic, copy)void (^bannerClickBlock)(NSDictionary * info);

- (void)resetCornerRadius:(CGFloat)radius;

- (void)resetSubviews;

@end

NS_ASSUME_NONNULL_END
