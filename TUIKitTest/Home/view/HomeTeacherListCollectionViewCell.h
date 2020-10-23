//
//  HomeTeacherListCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTeacherListCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy)void (^teacherDetailBlock)(NSDictionary * info);
- (void)refreshWithinfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
