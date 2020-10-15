//
//  UIImage+TBCityIconFont.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBCityIconInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TBCityIconFont)

+ (UIImage *)iconWithInfo:(TBCityIconInfo *)info;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;
@end

NS_ASSUME_NONNULL_END
