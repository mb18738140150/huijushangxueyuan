//
//  HomeCommunityCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCommunityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView * groupIconImageView;

@property (nonatomic,strong) UILabel            *courseNameLabel;// 课程名

@property (nonatomic,strong) UILabel            *contentLabel;

@property (nonatomic, strong)UIButton *cancelBtn;

@property (nonatomic, copy)void(^mainCountDownFinishBlock)();

@property (nonatomic, copy)void(^cancelOrderLivingCourseBlock)(NSDictionary * info);

- (void)resetCellContent:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
