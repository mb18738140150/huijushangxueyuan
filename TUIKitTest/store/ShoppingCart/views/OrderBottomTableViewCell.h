//
//  OrderBottomTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderBottomTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^buyBlock)(NSDictionary *info);
@property (nonatomic, copy)void (^deleteBlock)(NSDictionary *info);
@property (nonatomic, copy)void (^detailBlock)(NSDictionary *info);
@property (nonatomic, strong)NSDictionary * info;

- (void)refreshUIWith:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
