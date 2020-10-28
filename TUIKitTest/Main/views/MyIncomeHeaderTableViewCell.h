//
//  MyIncomeHeaderTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyIncomeHeaderTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^promisionBlock)(NSDictionary * info);
@property (nonatomic, copy)void(^teacherBlock)(NSDictionary * info);
@property (nonatomic, copy)void(^tixianBlock)(NSDictionary * info);
@property (nonatomic, copy)void(^sortBlock)(BOOL isAsc);


@property (nonatomic, strong)ZWMSegmentView * zixunSegment;
- (void)refreshUIWithInfo:(NSDictionary *)infoDic;

- (void)resetSort:(NSString *)sort;

- (void)resetIsTeacher:(BOOL )isTeacher;
- (void)resetSegmentView:(ZWMSegmentView *)segmentView;

@end

NS_ASSUME_NONNULL_END
