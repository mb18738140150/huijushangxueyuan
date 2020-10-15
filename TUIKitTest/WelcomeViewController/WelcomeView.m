//
//  WelcomeView.m
//  TeamsHit
//
//  Created by 仙林 on 16/10/25.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "WelcomeView.h"
#define kPageControlHeioght 30
@implementation WelcomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.myScrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    
    //给ScrollView添加图片
    for (int i = 1; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d.png" , i]];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * (i - 1), self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        imageView.image = image;
        [self.myScrollView addSubview:imageView];
        if (i == 4) {
            self.experiencebutton = [UIButton buttonWithType:UIButtonTypeCustom];
            _experiencebutton.frame = CGRectMake(0 , 0, kScreenWidth, kScreenHeight);
            [_experiencebutton setImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            _experiencebutton.hd_centerX = imageView.hd_centerX;
            [self.myScrollView addSubview:_experiencebutton];
        }
        
    }
    
    //给ScrollView设置contentSize
    self.myScrollView.contentSize = CGSizeMake(self.frame.size.width * 4, self.frame.size.height);
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    // 整页翻动
    self.myScrollView.pagingEnabled = YES;
    
    //给scrollView添加代理对象
    self.myScrollView.delegate = self;
    self.myScrollView.bounces = NO;
    
    [self addSubview:self.myScrollView];
    //创建UIPageControl
    self.myPageControl = [[WelPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - kPageControlHeioght, self.frame.size.width, kPageControlHeioght)];
    self.myPageControl.numberOfPages = 2;
    
    [_myPageControl setImagePageStateNormal:[UIImage imageNamed:@""]];
    [_myPageControl setImagePageStateHighlighted:[UIImage imageNamed:@""]];
   // [self addSubview:self.myPageControl];
}

#pragma mark - UIScrollVirew Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //先找到偏移量，再根据偏移量设置currentPage
    self.myPageControl.currentPage = self.myScrollView.contentOffset.x / self.frame.size.width;

    NSLog(@"end减速");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"began减速");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrol");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖拽");
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"将要结束拖拽");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"完成拖拽");
}

@end
