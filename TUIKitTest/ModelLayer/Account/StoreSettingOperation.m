//
//  StoreSettingOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/3.
//

#import "StoreSettingOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface StoreSettingOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_StoreSetting> notifiedObject;

@end

@implementation StoreSettingOperation

- (void)didRequestStoreSettingWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_StoreSetting>)object;
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustRegistWithdic:infoDic andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didStoreSettingSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didStoreSettingFailed:failInfo];
    }
}
@end
