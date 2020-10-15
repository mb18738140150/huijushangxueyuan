//
//  LivingCourseOperation.h
//  zhongxin
//
//  Created by aaa on 2020/6/2.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivingCourseOperation : NSObject

- (void)didRequestLivingCourseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LivingCourseProtocol>)object;
@property (nonatomic, strong)NSMutableArray * livingCourseList;
@property (nonatomic, strong)NSDictionary * livinghCourseCountInfo;

@end

NS_ASSUME_NONNULL_END
