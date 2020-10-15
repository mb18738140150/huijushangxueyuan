//
//  TeacherCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeacherCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * titleLB;

- (void)refreshWithInfo:(NSDictionary*)info;

@end

NS_ASSUME_NONNULL_END
