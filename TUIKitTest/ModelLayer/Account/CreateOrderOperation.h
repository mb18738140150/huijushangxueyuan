//
//  CreateOrderOperation.h
//  lanhailieren
//
//  Created by aaa on 2020/3/19.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateOrderOperation : NSObject
- (void)didRequestCreateOrderWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CreateOrderProtocol>)object;
@end

NS_ASSUME_NONNULL_END
