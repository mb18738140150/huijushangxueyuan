//
//  HomeOpenVIPCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeOpenVIPCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIView * backView;
@property (nonatomic, strong)UIImageView * vipImageView;
@property (nonatomic, strong)UILabel * vipTitleView;
@property (nonatomic, strong)UIButton * openBtn;
@property (nonatomic, copy)void (^openVIPBlock)(NSDictionary * info);

- (void)resetUIWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
