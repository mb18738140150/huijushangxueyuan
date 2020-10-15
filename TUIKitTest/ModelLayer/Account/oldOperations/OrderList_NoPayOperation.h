//
//  OrderList_NoPayOperation.h
//  zhongxin
//
//  Created by aaa on 2020/6/30.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderList_NoPayOperation : NSObject
@property (nonatomic, strong)NSMutableArray *orderList;
@property (nonatomic, strong)NSDictionary *orderListInfo;
- (void)didRequestOrderList_NoPayWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_OrderList_NoPayProtocol>)object;
@end

NS_ASSUME_NONNULL_END
