//
//  GiftCollectionViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIView * boardView;
@property (nonatomic, strong)UIImageView * contentImageView;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * priceLB;

- (void)resetWithInfo:(NSDictionary *)info;
- (void)resetSelect;

@end

NS_ASSUME_NONNULL_END
