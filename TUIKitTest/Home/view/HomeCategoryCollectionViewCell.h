//
//  HomeCategoryCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeCategoryCollectionViewCell : UICollectionViewCell

- (void)resetWithCategoryInfos:(NSArray *)infoArray;

@property (nonatomic,assign) PageType            pageType;

@property (nonatomic, strong)UIImageView *backImageView;

@property (nonatomic, strong)UIView *topView;

@end

NS_ASSUME_NONNULL_END
