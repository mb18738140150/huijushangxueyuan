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
@property (nonatomic, strong)UIImageView * backImageView;

@property (nonatomic,strong) UILabel            *courseNameLabel;// 课程名

@property (nonatomic,strong) UILabel            *contentLabel;
@property (nonatomic, strong)UILabel            *descLB;

@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *storeBtn;

@property (nonatomic, strong)ZWMSegmentView * zixunSegment;

@property (nonatomic, copy)void(^activeBlock)();

@property (nonatomic, copy)void(^centerBlock)(NSDictionary * info);
@property (nonatomic, copy)void(^storeBlock)(NSDictionary * info);

@property (nonatomic, strong)NSDictionary * info;

- (void)resetCellContent:(NSDictionary *)info;
- (void)resetDetailCellContent:(NSDictionary *)info;


@end

NS_ASSUME_NONNULL_END
