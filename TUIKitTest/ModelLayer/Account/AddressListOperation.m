//
//  AddressListOperation.m
//  lanhailieren
//
//  Created by aaa on 2020/3/16.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "AddressListOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface AddressListOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_AddressListProtocol> notifiedObject;

@end

@implementation AddressListOperation


- (void)didRequestAddressListWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AddressListProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.addressList = [successInfo objectForKey:@"data"] ;
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAddressListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAddressListFailed:failInfo];
    }
}
@end
