//
//  ArticleCategoryTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleCategoryTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^categoryClickBLock)(NSDictionary * info);
- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
