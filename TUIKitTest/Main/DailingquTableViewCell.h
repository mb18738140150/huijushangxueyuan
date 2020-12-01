//
//  DailingquTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailingquTableViewCell : UITableViewCell

@property (nonatomic, strong)UIView * backView;

@property (nonatomic, strong)UIImageView * iconImageVIew;
@property (nonatomic, strong)UILabel * teacherNameLB;
@property (nonatomic, strong)UILabel * titleLB;

@property (nonatomic, strong)UILabel * priceLB;

@property (nonatomic, strong)UIButton * applyBtn;


@property (nonatomic, copy)void(^applyBlock)(NSDictionary * info);
@property (nonatomic, strong)NSDictionary * infoDic;

@property (nonatomic, copy)void (^livingCourseStartBlock)(NSDictionary *info);

- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
