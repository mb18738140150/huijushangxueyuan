//
//  CommodityInfoTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommodityInfoTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * contentLB;
@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UILabel * saleCountLB;

- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
