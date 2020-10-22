//
//  DeleteAddressOperation.m
//  lanhailieren
//
//  Created by aaa on 2020/3/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "DeleteAddressOperation.h"


#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface DeleteAddressOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_DeleteAddressProtocol> notifiedObject;
@end

@implementation DeleteAddressOperation

- (void)didRequestDeleteAddressWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_DeleteAddressProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestOrderListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDeleteAddressSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDeleteAddressFailed:failInfo];
    }
}

@end
