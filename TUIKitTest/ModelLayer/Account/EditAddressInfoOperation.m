//
//  EditAddressInfoOperation.m
//  lanhailieren
//
//  Created by aaa on 2020/3/16.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "EditAddressInfoOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface EditAddressInfoOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_EditAddressProtocol> notifiedObject;

@end

@implementation EditAddressInfoOperation


- (void)didRequestEditAddressWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_EditAddressProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didEditAddressSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didEditAddressFailed:failInfo];
    }
}

@end
