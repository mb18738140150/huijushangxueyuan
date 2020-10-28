//
//  MyTeamInfoMemberTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTeamInfoMemberTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^checkDetailBlock)(NSDictionary *info);
- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
