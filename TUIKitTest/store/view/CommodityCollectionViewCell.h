//
//  CommodityCollectionViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommodityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView * iconImageVIew;
@property (nonatomic, strong)LivingStateView * livingStateView;

@property (nonatomic, strong)UILabel * titleLB;

@property (nonatomic, strong)UILabel * priceLB;

@property (nonatomic, strong)UIButton * applyBtn;

@property (nonatomic, assign)BOOL isOneCourse;
@property (nonatomic, copy)void(^applyBlock)(NSDictionary * info);
@property (nonatomic, strong)NSDictionary * infoDic;
- (void)refreshUIWith:(NSDictionary *)infoDic andItem:(int)item;


@end

NS_ASSUME_NONNULL_END
