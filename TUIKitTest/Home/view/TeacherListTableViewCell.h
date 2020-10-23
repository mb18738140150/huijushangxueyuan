//
//  TeacherListTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface TeacherListTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^checkDetailBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^shareBlock)(NSDictionary * info);

@property (nonatomic, strong)NSDictionary * infoDic;
- (void)refreshUIWith:(NSDictionary *)info andCornerType:(CellCornerType)cornertype;

- (void)refreshHeadUIWith:(NSDictionary *)info andCornerType:(CellCornerType)cornertype;


@end

NS_ASSUME_NONNULL_END
