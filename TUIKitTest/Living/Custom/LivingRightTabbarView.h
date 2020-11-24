//
//  LivingRightTabbarView.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RightTabbarOperationType_shutUp,
    RightTabbarOperationType_moniV,
    RightTabbarOperationType_moniP,
    RightTabbarOperationType_invite,
    RightTabbarOperationType_VIP,
    RightTabbarOperationType_Hehuoren,
    RightTabbarOperationType_publicNumber,
    RightTabbarOperationType_service,
    RightTabbarOperationType_store,
} RightTabbarOperationType;

NS_ASSUME_NONNULL_BEGIN

@interface LivingRightTabbarView : UIView


- (instancetype)initWithFrame:(CGRect)frame andIsTeacher:(BOOL)isTeacher andInfo:(NSDictionary *)info;

@property (nonatomic, copy)void (^rightTabbarActionBlock)(NSDictionary *info);

@end

NS_ASSUME_NONNULL_END
