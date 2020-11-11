//
//  AssociationListTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociationListTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * groupIconImageView;

@property (nonatomic,strong) UILabel            *courseNameLabel;// 课程名

@property (nonatomic,strong) UILabel            *contentLabel;

@property (nonatomic, strong)UIButton *cancelBtn;

@property (nonatomic, copy)void(^mainCountDownFinishBlock)();

@property (nonatomic, copy)void(^cancelOrderLivingCourseBlock)(NSDictionary * info);
@property (nonatomic, strong)NSDictionary * info;

- (void)resetCellContent:(NSDictionary *)info;
- (void)resetTitle;
@end

NS_ASSUME_NONNULL_END
