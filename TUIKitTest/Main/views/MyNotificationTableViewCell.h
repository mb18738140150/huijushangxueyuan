//
//  MyNotificationTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyNotificationTableViewCell : UITableViewCell

@property (nonatomic, strong)NSDictionary * info;
@property (nonatomic, copy)void (^lookNotificationBlock)(NSDictionary * info);
- (void)refreshUIWith:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
