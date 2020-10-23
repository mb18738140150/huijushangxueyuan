//
//  TeacherArticleTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeacherArticleTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView        *courseImageView;
@property (nonatomic, strong)UILabel *courseChapterNameLabel;// 课程所属分类名
@property (nonatomic, strong)UILabel *typeLabel;// 课程类型
@property (nonatomic, strong)UILabel *descLabel;// 课程描述
@property (nonatomic, strong)UILabel *timeLabel;// 时间

@property (nonatomic,strong) UILabel            *priceLabel;



@property (nonatomic, strong)NSDictionary * info;
- (void)refreshUIWith:(NSDictionary *)info andCornerType:(CellCornerType)cornertype;

@end

NS_ASSUME_NONNULL_END
