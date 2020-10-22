//
//  CategoryView.m
//  Accountant
//
//  Created by aaa on 2017/3/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CategoryView.h"
#import "MainViewMacro.h"
#import "UIImageView+WebCache.h"
#import "CommonMacro.h"
#import "NotificaitonMacro.h"

@implementation CategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-frame.size.height / 4 - 3.5, 0, frame.size.height / 2 + 7, frame.size.height / 2 + 7)];
        
        
        self.categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.coverImageView.frame), frame.size.width, frame.size.height - self.coverImageView.frame.size.height)];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame), 0, self.coverImageView.frame.size.height / 3, self.coverImageView.frame.size.height / 3)];
    }
    return self;
}

- (void)setupContents
{
    self.categoryNameLabel.text = self.categoryName;
    self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryNameLabel.font = [UIFont systemFontOfSize:12];
    self.categoryNameLabel.textColor = kMainTextColor;
    
    if ([self.icon_type isEqualToString:@"icon"]) {
        UIColor * color = [UIColor redColor];
        if ([self.color length] > 0) {
            color =  [UIUtility colorWithHexString:self.color alpha:1];
        }
        self.coverImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake([UIUtility getUnicodeStr:[UIUtility judgeStr:self.icon]], self.coverImageView.hd_width, color)];
    }else
    {
        
        NSString * imageStr = [[NSString stringWithFormat:@"%@",[UIUtility judgeStr:self.categoryCoverUrl]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

        }];
        
    }
    
    
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = 1;
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    self.numberLabel.text = @"8";
    self.numberLabel.backgroundColor = kCommonMainColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.coverImageView];
    [self addSubview:self.categoryNameLabel];
    //    [self addSubview:self.numberLabel];
}
- (void)setupNaviContents
{
    self.categoryNameLabel.text = self.categoryName;
    self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryNameLabel.font = [UIFont systemFontOfSize:12];
    self.categoryNameLabel.textColor = kMainTextColor;
    
    self.coverImageView.image = [UIImage imageNamed:self.categoryCoverUrl];
    
    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImageView.frame), 0, self.coverImageView.frame.size.height / 2, self.coverImageView.frame.size.height / 2);
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = 1;
    self.numberLabel.font = [UIFont systemFontOfSize:9];
    self.numberLabel.text = @"8";
    self.numberLabel.backgroundColor = [UIColor redColor];
    self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.height / 2;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.coverImageView];
    [self addSubview:self.categoryNameLabel];
    [self addSubview:self.numberLabel];
}

- (void)setupSmallContent
{
    self.coverImageView.frame = CGRectMake(self.frame.size.width/2-self.frame.size.height / 4 , 0, self.frame.size.height / 2, self.frame.size.height / 2 );
    self.categoryNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.coverImageView.frame), self.frame.size.width, self.frame.size.height - self.coverImageView.frame.size.height);
    
    self.categoryNameLabel.text = self.categoryName;
    self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryNameLabel.font = [UIFont systemFontOfSize:12];
    self.categoryNameLabel.textColor = kMainTextColor;
    
    self.coverImageView.image = [UIImage imageNamed:self.categoryCoverUrl];
    
    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImageView.frame), 0, self.coverImageView.frame.size.height / 2, self.coverImageView.frame.size.height / 2);
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = 1;
    self.numberLabel.font = [UIFont systemFontOfSize:9];
    self.numberLabel.text = @"8";
    self.numberLabel.backgroundColor = [UIColor redColor];
    self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.height / 2;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.coverImageView];
    [self addSubview:self.categoryNameLabel];
    [self addSubview:self.numberLabel];
}

- (void)resetImageSize:(CGSize)size
{
    self.coverImageView.frame = CGRectMake(self.hd_width / 2 - size.width / 2, 5, size.width, size.height);
}

- (void)resetNumber:(NSString *)number
{
    self.numberLabel.hidden = NO;
    self.numberLabel.text = [NSString stringWithFormat:@"%@",number];
}

- (void)click
{
    NSDictionary *dic = @{kCourseCategoryName:self.categoryName,
                          kCourseCategoryId:@(self.categoryId)};
    if (self.pageType == PageCategory) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfCategoryPageCategoryClick object:dic];
    }
    if (self.pageType == PageMain) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMainPageCategoryClick object:self.info];
    }
    if (self.pageType == PageMessage) {
        NSLog(@"点击了消息中心");
    }
    if (self.pageType == PageLeft) {
        NSLog(@"点击了左上角");
    }
    if (self.pageType == Page_Home) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfHomePageCategoryClick object:dic];
    }
    if (self.pageType == Page_getIntegral) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfGetIntegralClick object:dic];
    }
    if (self.pageType == page_MyNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMainMyCategory object:dic];
    }

    if (self.pageType == Page_MyOrderState) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMainMyOrderState object:dic];
    }
    
    if (self.pageType == Page_Store) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfStoreAction object:self.info];
    }
    
}

@end
