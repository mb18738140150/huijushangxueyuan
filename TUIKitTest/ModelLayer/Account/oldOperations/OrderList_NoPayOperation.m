//
//  OrderList_NoPayOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/30.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "OrderList_NoPayOperation.h"


#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface OrderList_NoPayOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_OrderList_NoPayProtocol> notifiedObject;
@end

@implementation OrderList_NoPayOperation

- (NSMutableArray *)orderList
{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}

- (void)didRequestOrderList_NoPayWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_OrderList_NoPayProtocol>)object{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestOrderListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.orderList removeAllObjects];
    self.orderListInfo = [successInfo objectForKey:@"result"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestOrderList_NoPaySuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestOrderList_NoPayFailed:failInfo];
    }
}

@end
