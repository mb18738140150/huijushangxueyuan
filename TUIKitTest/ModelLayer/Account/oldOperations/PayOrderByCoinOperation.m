//
//  PayOrderByCoinOperation.m
//  zhongxin
//
//  Created by aaa on 2020/7/7.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "PayOrderByCoinOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface PayOrderByCoinOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_PayOrderByCoinProtocol> notifiedObject;
@end

@implementation PayOrderByCoinOperation

- (void)didRequestPayOrderByCoinWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_PayOrderByCoinProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestPayOrderWith:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.payOrderDetailInfo = successInfo;
    
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestPayOrderByCoinSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestPayOrderByCoinFailed:failInfo];
    }
}

@end
