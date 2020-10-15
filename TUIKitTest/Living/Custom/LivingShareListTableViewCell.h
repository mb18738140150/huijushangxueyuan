//
//  LivingShareListTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivingShareListTableViewCell : UITableViewCell

@property (nonatomic, strong)UIButton * numberBtn;
@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * contentLB;

- (void)resetUIWithInfo:(NSDictionary *)info;
- (void)setSort:(int)sort;


@end

NS_ASSUME_NONNULL_END
