//
//  UserInfoOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/28.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "UserInfoOperation.h"

@interface UserInfoOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_GetUserInfo> notifiedObject;

@end

@implementation UserInfoOperation

- (void)didRequestGetUserInfoWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_GetUserInfo>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetUserInfoWithDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    NSDictionary * courseInfo = [successInfo objectForKey:@"data"];
    self.infoDic = courseInfo;
    
    NSString * customStr =  [UIUtility judgeStr:[courseInfo objectForKey:@"custom_name"]];
    customStr = customStr.length > 0 ? customStr : [[UserManager sharedManager] getUserNickName];
     
    [[UserManager sharedManager] refreshUserInfoWith:@{@"nickName":customStr,@"icon":[UIUtility judgeStr:[courseInfo objectForKey:@"avatar"]]}];
    
    [UserManager sharedManager].isTeacher = NO;
    
    if (![[self.infoDic objectForKey:@"teacher"] isKindOfClass:[NSNull class]]) {
        NSDictionary * teacherInfo = [[self.infoDic objectForKey:@"teacher"] objectForKey:@"data"];
        if (![teacherInfo isKindOfClass:[NSNull class]]) {
            if ([[UserManager sharedManager] getUserId] == [[teacherInfo objectForKey:@"user_id"] intValue]) {
                [UserManager sharedManager].isTeacher = YES;
            }
        }
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didGetUserInfoSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didGetUserInfolFailed:failInfo];
    }
}
@end
