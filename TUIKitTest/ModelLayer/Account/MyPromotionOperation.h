//
//  MyPromotionOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPromotionOperation : NSObject

@property(nonatomic, strong)NSDictionary * info;

- (void)getPromotionWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_Promotion>)object;


@end

NS_ASSUME_NONNULL_END
