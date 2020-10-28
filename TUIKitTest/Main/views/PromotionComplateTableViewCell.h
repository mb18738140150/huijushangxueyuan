//
//  PromotionComplateTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromotionComplateTableViewCell : UITableViewCell

@property (nonatomic, strong)void (^YueBlock)(NSDictionary * info);
@property (nonatomic, strong)void (^reciveBlock)(NSDictionary * info);
@property (nonatomic, strong)void (^teamBlock)(NSDictionary * info);
@property (nonatomic, strong)void (^courseBlock)(NSDictionary * info);

- (void)refreshUIWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
