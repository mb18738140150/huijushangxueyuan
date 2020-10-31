//
//  AssociationAdminInfoTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociationAdminInfoTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^joinBlock)(NSDictionary * info);

- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
