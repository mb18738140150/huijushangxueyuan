//
//  AssociationCommentTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociationCommentTableViewCell : UITableViewCell

@property (nonatomic, strong)NSDictionary * infoDic;

- (void)refreshUIWith:(NSDictionary *)info andIsCanOperation:(BOOL)canOperation;

@end

NS_ASSUME_NONNULL_END
