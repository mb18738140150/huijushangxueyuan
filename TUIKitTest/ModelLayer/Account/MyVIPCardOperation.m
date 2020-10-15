//
//  MyVIPCardOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import "MyVIPCardOperation.h"

@interface MyVIPCardOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_MyVIPCardInfo> notifiedObject;

@end
@implementation MyVIPCardOperation

- (void)didRequestMyVIPCardWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyVIPCardInfo>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.vipCardInfo = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyVIPCardInfoSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyVIPCardInfoFailed:failInfo];
    }
}

@end
