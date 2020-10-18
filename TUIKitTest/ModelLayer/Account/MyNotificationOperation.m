//
//  MyNotificationOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/16.
//

#import "MyNotificationOperation.h"

@interface MyNotificationOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_NotificationList> notifiedObject;

@end
@implementation MyNotificationOperation

- (void)didRequestNotificationListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_NotificationList>)object;
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.list = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNotificationListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNotificationListFailed:failInfo];
    }
}

@end
