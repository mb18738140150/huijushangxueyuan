//
//  HomeAdverCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeAdverCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView * iconImageView;
- (void)refreshUIWith:(NSDictionary *)info;


@end

NS_ASSUME_NONNULL_END
