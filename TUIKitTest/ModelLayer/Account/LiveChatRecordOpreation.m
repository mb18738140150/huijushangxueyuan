//
//  LiveChatRecordOpreation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/7.
//

#import "LiveChatRecordOpreation.h"
@interface LiveChatRecordOpreation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_LiveChatRecord> notifiedObject;

@end
@implementation LiveChatRecordOpreation

- (void)didRequestLiveChatRecordWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_LiveChatRecord>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustRegistWithdic:infoDic andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    self.list = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didLiveChatRecordSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didLiveChatRecordFailed:failInfo];
    }
}

@end
