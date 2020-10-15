//
//  TestImageView.m
//  DragGesture-OC
//
//  Created by 杜奎 on 2019/4/28.
//  Copyright © 2019 du. All rights reserved.
//

#import "TestImageView.h"
#import "DragGestureHandler.h"

@interface TestImageView ()

@property (nonatomic, strong) DragGestureHandler *gesture;
@property (nonatomic, strong) UIView             *blackBgView;

@property (nonatomic, strong)NSArray * imageArray;

@end

@implementation TestImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.blackBgView];
        [self addSubview:self.imageView];
        
        __weak typeof(self) weakSelf = self;
        self.gesture = [[DragGestureHandler alloc] initWithGestureView:self.imageView bgView:self.blackBgView];
        self.gesture.completeBlock = ^(BOOL finish) {
            if (finish) {
                [weakSelf hide];
            }
        };
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andImageList:(NSArray *)imageArray
{
    if (self = [super initWithFrame:frame]) {
        self.imageArray = imageArray;
        [self addSubview:self.blackBgView];
        [self addSubview:self.imageView];
        
        
        NSDictionary * imageInfo = [imageArray objectAtIndex:0];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[UIUtility judgeStr:[imageInfo objectForKey:@"content"]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            ;
        }];
        
        __weak typeof(self) weakSelf = self;
        self.gesture = [[DragGestureHandler alloc] initWithGestureView:_imageView bgView:self.blackBgView];
        self.gesture.completeBlock = ^(BOOL finish) {
            if (finish) {
                [weakSelf hide];
            }
        };
//        for (int i = 0 ; i < imageArray.count; i++) {
//
//            [self.scrollView addSubview:imageView];
//        }
        
//        __weak typeof(self) weakSelf = self;
//        self.gesture = [[DragGestureHandler alloc] initWithGestureView:self.imageView bgView:self.blackBgView];
//        self.gesture.completeBlock = ^(BOOL finish) {
//            if (finish) {
//                [weakSelf hide];
//            }
//        };
    }
    return self;
}

#pragma mark - action

- (void)show {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.blackBgView.alpha = 0;
    self.imageView.frame = self.outsideFrame;
    self.blackBgView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = self.insideFrame;
        self.blackBgView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.blackBgView.userInteractionEnabled = YES;
    }];
}

- (void)hide {
    self.blackBgView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = self.outsideFrame;
        self.blackBgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.blackBgView.userInteractionEnabled = YES;
        [self removeFromSuperview];
    }];
}

- (void)tapAction {
    [self hide];
}

#pragma mark - setter & getter
- (UIView *)blackBgView {
    if (!_blackBgView) {
        _blackBgView = [[UIView alloc] initWithFrame:self.bounds];
        _blackBgView.backgroundColor = UIColor.blackColor;
        _blackBgView.userInteractionEnabled = NO;
        [_blackBgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    }
    return _blackBgView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * self.imageArray.count, kScreenHeight);
    }
    return _scrollView;
}

@end
