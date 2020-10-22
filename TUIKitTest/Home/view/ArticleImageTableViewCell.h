//
//  ArticleImageTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleImageTableViewCell : UITableViewCell

@property(nonatomic, strong)UIImageView * avaterImageView;
@property (nonatomic, assign)CGFloat imageHeight;
@property (nonatomic, copy)void (^getImageHeightBlock)(CGFloat height);

- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
