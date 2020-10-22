//
//  ArticleVideoTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleVideoTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIButton * playBtn;
@property (nonatomic, copy)void (^playActionBlock)(NSDictionary *info);
- (void)refreshUIWith:(NSDictionary *)infoDic;
- (void)hideAllView;


@end

NS_ASSUME_NONNULL_END
