//
//  JoinAssociationHeadTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JoinAssociationHeadTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * groupIconImageView;

@property (nonatomic,strong) UILabel            *courseNameLabel;// 课程名

@property (nonatomic,strong) UILabel            *contentLabel;
@property (nonatomic, strong)UILabel            *descLB;

@property (nonatomic, strong)UIButton *cancelBtn;

@property (nonatomic, copy)void(^activeBlock)();

@property (nonatomic, copy)void(^cancelOrderLivingCourseBlock)(NSDictionary * info);

- (void)resetCellContent:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
