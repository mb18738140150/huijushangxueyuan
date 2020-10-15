//
//  HomeBannerCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeBannerCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSArray *bannerImgUrlArray;

- (void)resetCornerRadius:(CGFloat)radius;

- (void)resetSubviews;

@end

NS_ASSUME_NONNULL_END
