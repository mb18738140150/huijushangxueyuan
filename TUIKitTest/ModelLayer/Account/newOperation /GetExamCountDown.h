//
//  GetExamCountDown.h
//  zhongxin
//
//  Created by aaa on 2020/7/10.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetExamCountDown : NSObject

- (void)getExamCountDownWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_GetExamCountDown>)object;

@property (nonatomic, strong)NSDictionary * info;

@end

NS_ASSUME_NONNULL_END
