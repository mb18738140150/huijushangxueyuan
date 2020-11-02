//
//  AssociationRelevanceCourseTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociationRelevanceCourseTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView        *courseImageView;

@property (nonatomic, strong)UILabel *courseChapterNameLabel;// 课程所属分类名
@property (nonatomic,strong) UILabel            *priceLabel;

- (void)resetCellContent:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
