//
//  MyNotificationOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyNotificationOperation : NSObject

@property (nonatomic, strong)NSArray * list;

- (void)didRequestNotificationListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_NotificationList>)object;


@end

NS_ASSUME_NONNULL_END
