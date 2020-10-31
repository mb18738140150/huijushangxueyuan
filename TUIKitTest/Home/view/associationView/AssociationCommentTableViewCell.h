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

@property (nonatomic, copy)void(^zanBlock)(NSDictionary * info);
@property (nonatomic, copy)void(^commentBlock)(NSDictionary * info);

@property (nonatomic, copy)void(^deleteBlock)(NSDictionary * info);

- (void)refreshUIWith:(NSDictionary *)info andIsCanOperation:(BOOL)canOperation;

- (void)refresCommentDetailhUIWith:(NSDictionary *)info;


@end

NS_ASSUME_NONNULL_END
