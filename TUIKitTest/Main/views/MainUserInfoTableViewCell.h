//
//  MainUserInfoTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainUserInfoTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, copy)void (^joinCourseBlock)(NSDictionary * info);

- (void)resetUIWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
