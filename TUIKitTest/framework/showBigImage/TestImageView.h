//
//  TestImageView.h
//  DragGesture-OC
//
//  Created by 杜奎 on 2019/4/28.
//  Copyright © 2019 du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestImageView : UIView

@property (nonatomic, assign) CGRect outsideFrame;
@property (nonatomic, assign) CGRect insideFrame;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *nextOrPreviousImageView;


@property (nonatomic, strong)UIScrollView * scrollView;

- (instancetype)initWithFrame:(CGRect)frame andImageList:(NSArray *)imageArray;
- (instancetype)initWithFrame:(CGRect)frame andImageList:(NSArray *)imageArray andCurrentIndex:(int)index;


- (void)show;

@end

