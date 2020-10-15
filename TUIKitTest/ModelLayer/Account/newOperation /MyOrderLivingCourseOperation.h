//
//  MyOrderLivingCourseOperation.h
//  zhongxin
//
//  Created by aaa on 2020/6/19.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderLivingCourseOperation : NSObject

- (void)getMyOrderLivingCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyOrderLivingCourse>)object;

@property (nonatomic, strong)NSMutableArray * list;
@property (nonatomic, strong)NSDictionary * info;
@end

NS_ASSUME_NONNULL_END
