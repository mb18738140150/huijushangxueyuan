//
//  UserInfoOperation.h
//  zhongxin
//
//  Created by aaa on 2019/10/28.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoOperation : NSObject

- (void)didRequestGetUserInfoWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_GetUserInfo>)object;

@property (nonatomic, strong)NSDictionary * infoDic;

@end

NS_ASSUME_NONNULL_END
