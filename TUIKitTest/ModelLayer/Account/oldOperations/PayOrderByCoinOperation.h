//
//  PayOrderByCoinOperation.h
//  zhongxin
//
//  Created by aaa on 2020/7/7.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayOrderByCoinOperation : NSObject

@property (nonatomic, strong)NSDictionary *payOrderDetailInfo;

- (void)didRequestPayOrderByCoinWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_PayOrderByCoinProtocol>)object;

@end

NS_ASSUME_NONNULL_END
