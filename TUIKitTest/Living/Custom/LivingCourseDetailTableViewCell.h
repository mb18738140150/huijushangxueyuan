//
//  LivingCourseDetailTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivingCourseDetailTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^subscribBlock)(BOOL isSubscrib);
- (void)refreshUIWithInfo:(NSDictionary *)info;

- (void)showSubscribLB;

@end

NS_ASSUME_NONNULL_END
