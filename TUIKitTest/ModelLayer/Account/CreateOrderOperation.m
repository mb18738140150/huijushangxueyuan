
//
//  CreateOrderOperation.m
//  lanhailieren
//
//  Created by aaa on 2020/3/19.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "CreateOrderOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface CreateOrderOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CreateOrderProtocol> notifiedObject;
@end

@implementation CreateOrderOperation


- (void)didRequestCreateOrderWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CreateOrderProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestOrderListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.orderInfo = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCreateOrderSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCreateOrderFailed:failInfo];
    }
}
@end
