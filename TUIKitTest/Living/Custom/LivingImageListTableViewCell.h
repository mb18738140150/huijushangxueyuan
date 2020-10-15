//
//  LivingImageListTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivingImageListTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * iconImageView;

@property (nonatomic, copy)void (^loadImageSuccessBlock)(CGSize size);
- (void)resetUIWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
