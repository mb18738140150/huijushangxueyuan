//
//  OrderHeaderStateTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderHeaderStateTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^complateBlock)(NSDictionary *info);

@property (nonatomic, copy)void (^buyBlock)(NSDictionary *info);
@property (nonatomic, strong)NSDictionary * info;
-(void)refreshUIWithInfo:(NSDictionary *)info andOrderState:(OrderState)orderState;

@end

NS_ASSUME_NONNULL_END
