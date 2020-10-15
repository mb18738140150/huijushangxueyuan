//
//  SendMessageOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/7.
//

#import "SendMessageOperation.h"

@interface SendMessageOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_SendMessage> notifiedObject;

@end
@implementation SendMessageOperation

- (void)didRequestSendMessageWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_SendMessage>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustRegistWithdic:infoDic andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didSendMessageSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didSendMessageFailed:failInfo];
    }
}
@end
