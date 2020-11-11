//
//  OrderSendInfoTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderSendInfoTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^connectBlock)(NSDictionary *info);

@property (nonatomic, strong)NSDictionary * info;
-(void)refreshUIWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
