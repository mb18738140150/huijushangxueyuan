//
//  MockPartnerBuyOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/13.
//

#import "MockPartnerBuyOperation.h"

@interface MockPartnerBuyOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_MockPartnerBuy> notifiedObject;

@end
@implementation MockPartnerBuyOperation

- (void)didRequestMockPartnerBuyWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MockPartnerBuy>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.partnerBuyInfo = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMockPartnerBuySuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMockPartnerBuyFailed:failInfo];
    }
}
@end
