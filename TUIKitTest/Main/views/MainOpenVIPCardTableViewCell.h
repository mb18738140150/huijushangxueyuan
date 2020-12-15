//
//  MainOpenVIPCardTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainOpenVIPCardTableViewCell : UITableViewCell

@property (nonatomic,strong)UIView * backView;
@property (nonatomic, strong)UIImageView * vipImageView;
@property (nonatomic, strong)UILabel * vipTitleView;
@property (nonatomic, strong)UIButton * openBtn;
@property (nonatomic, copy)void (^openVIPBlock)(NSDictionary * info);

- (void)resetUIWithInfo:(NSDictionary *)info;
- (void)resetContent:(NSDictionary *)info;
- (void)hiddenAllSubView;

@end

NS_ASSUME_NONNULL_END
