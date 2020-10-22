//
//  MyPresentRecordTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPresentRecordTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView        *courseImageView;
@property (nonatomic, strong)LivingStateView * livingStateView;


@property (nonatomic, strong)UILabel *courseChapterNameLabel;// 课程所属分类名
@property (nonatomic,strong) UILabel            *priceLabel;
@property (nonatomic, strong)UILabel *payCountLabel;

@property (nonatomic, strong)UIButton * presentBtn;
@property (nonatomic, strong)UIImageView * presenteriConImage;
@property (nonatomic, strong)UILabel * presenteriName;


@property (nonatomic, assign)BOOL isOneCourse;
@property (nonatomic, copy)void(^mainCountDownFinishBlock)();

@property (nonatomic, copy)void(^presentBlock)();


@property (nonatomic, strong)NSDictionary * info;
- (void)resetCellContent:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
