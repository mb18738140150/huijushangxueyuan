//
//  MockVIPBuyOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/13.
//

#import "MockVIPBuyOperation.h"

@interface MockVIPBuyOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_MockVIPBuy> notifiedObject;

@end
@implementation MockVIPBuyOperation

- (void)didRequestMockVIPBuyWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MockVIPBuy>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.vipBuyInfo = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMockVIPBuySuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMockVIPBuyFailed:failInfo];
    }
}
@end
