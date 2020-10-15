//
//  HomeCategoryCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeCategoryCollectionViewCell.h"
#import "MainViewMacro.h"
#import "UIMacro.h"
#import "CommonMacro.h"
#import "CategoryView.h"
#import "UIImage+Scale.h"

#define kspace 20

@interface HomeCategoryCollectionViewCell()
@property (nonatomic,strong) NSMutableArray         *categoryViews;
//@property (nonatomic,strong) UIView                 *bottomLineView;

@property (nonatomic, strong)UILabel * timeLB;
@end

@implementation HomeCategoryCollectionViewCell

- (void)resetWithCategoryInfos:(NSArray *)infoArray
{
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [self.contentView removeAllSubviews];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 98)];
    [self.contentView addSubview:self.topView];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    for (CategoryView *view in self.categoryViews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < infoArray.count; i++) {
        CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(i%4 * ((kScreenWidth)/4), i/4 * (kCellHeightOfCategoryView + kspace)+kspace, ((kScreenWidth)/4), kCellHeightOfCategoryView)];
        NSDictionary *cateInfo = [infoArray objectAtIndex:i];
        cateView.categoryId = [[cateInfo objectForKey:@"id"] intValue];
        cateView.pageType = self.pageType;
        cateView.categoryName = [cateInfo objectForKey:@"title"];
        cateView.categoryCoverUrl = [cateInfo objectForKey:@"img_url"];
        cateView.icon = [cateInfo objectForKey:@"icon"];
        cateView.color = [cateInfo objectForKey:@"color"];
        cateView.url_type = [cateInfo objectForKey:@"url_type"];
        cateView.icon_type = [cateInfo objectForKey:@"icon_type"];
        cateView.url = [cateInfo objectForKey:@"url"];
        cateView.need_redirect = [cateInfo objectForKey:@"need_redirect"];
        [cateView setupContents];
        [_topView addSubview:cateView];
        [self.categoryViews addObject:cateView];
    }
    
    self.topView.hd_height = (infoArray.count / 4 + 1) * (kCellHeightOfCategoryView + kspace) + kspace;
    
}

@end
