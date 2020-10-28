//
//  PromotionApplyTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromotionApplyTableViewCell : UITableViewCell

@property (nonatomic, copy)void (^getVerifyACodeBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^promotionApplyBlock)(NSDictionary *info);

@property (nonatomic, copy)void (^CheckRulerBlock)(NSDictionary *info);


@property (nonatomic, strong, readonly)UITextField * nameTF;
@property (nonatomic, strong, readonly)UITextField * phoneTF;
@property (nonatomic, strong, readonly)UITextField *verifyTF;

- (void)refreshApplyUIWithInfo:(NSDictionary *)infoDic;
- (void)refreshCheckUIWithInfo:(NSDictionary *)infoDic;


@end

NS_ASSUME_NONNULL_END
