//
//  ArticleCommentTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleCommentTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * nameLB;
@property (nonatomic, strong)UILabel * timeLB;
@property (nonatomic, strong)UILabel * contentLB;
@property (nonatomic, strong)UILabel * replayLB;

@property (nonatomic, strong)UIButton * zanBtn;
@property (nonatomic, strong)NSDictionary * info;
@property (nonatomic, copy)void (^zanBlock)(NSDictionary * info);
- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
