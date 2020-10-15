//
//  UIImage+Scale.m
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (CGFloat)imageGetHeight:(UIImage *)image
{
    CGSize  imageSize = image.size;
    CGFloat height = 0;
    height = imageSize.height * [UIScreen mainScreen].bounds.size.width / imageSize.width;
    
    return height;
}

- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength {
    UIImage *resultImage = self;
       NSData *data = UIImageJPEGRepresentation(resultImage, 1);
       NSUInteger lastDataLength = 0;
       while (data.length > maxLength && data.length != lastDataLength) {
           lastDataLength = data.length;
           CGFloat ratio = (CGFloat)maxLength / data.length;
           CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                    (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
           UIGraphicsBeginImageContext(size);
           // Use image to draw (drawInRect:), image is larger but more compression time
           // Use result image to draw, image is smaller but less compression time
           [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
           resultImage = UIGraphicsGetImageFromCurrentImageContext();
           UIGraphicsEndImageContext();
           data = UIImageJPEGRepresentation(resultImage, 1);
       }
       return data;
}

@end
