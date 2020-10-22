//
//  ArticleHeadTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleHeadTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *titleLB;
@property (nonatomic, strong)UILabel * timeLB;

- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
