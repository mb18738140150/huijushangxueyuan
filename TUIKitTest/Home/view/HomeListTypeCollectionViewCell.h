//
//  HomeListTypeCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeListTypeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView        *courseImageView;
@property (nonatomic, strong)LivingStateView * livingStateView;


@property (nonatomic, strong)UILabel *courseChapterNameLabel;// 课程所属分类名

@property (nonatomic,strong) UILabel            *priceLabel;

@property (nonatomic, strong)UILabel *payCountLabel;
@property (nonatomic, assign)BOOL isOneCourse;
@property (nonatomic, copy)void(^mainCountDownFinishBlock)();

@property (nonatomic, copy)void(^buyCourseBlock)();

- (void)resetCellContent:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
