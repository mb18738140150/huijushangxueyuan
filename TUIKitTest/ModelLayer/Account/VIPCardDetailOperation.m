//
//  VIPCardDetailOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/15.
//

#import "VIPCardDetailOperation.h"

@interface VIPCardDetailOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_MyVIPCardDetailInfo> notifiedObject;

@end
@implementation VIPCardDetailOperation

- (void)didRequestMyVIPCardDetailWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyVIPCardDetailInfo>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.vipCardDetailInfo = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyVIPCardDetailInfoSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyVIPCardDetailInfoFailed:failInfo];
    }
}

@end
