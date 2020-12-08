//
//  HomeVIPCardCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeVIPCardCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * iconImageVIew;

@property (nonatomic, strong)UILabel * titleLB;

@property (nonatomic, strong)UILabel * priceLB;

@property (nonatomic, strong)UIButton * applyBtn;

@property (nonatomic, copy)void(^applyBlock)(NSDictionary * info);
@property (nonatomic, strong)NSDictionary * infoDic;
- (void)refreshUIWith:(NSDictionary *)infoDic;


- (void)hiddenApplayBtn;

@end

NS_ASSUME_NONNULL_END
