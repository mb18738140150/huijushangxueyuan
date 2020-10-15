//
//  GetExamCountDown.m
//  zhongxin
//
//  Created by aaa on 2020/7/10.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "GetExamCountDown.h"

@interface GetExamCountDown ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_GetExamCountDown> notifiedObject;

@end

@implementation GetExamCountDown



- (void)getExamCountDownWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_GetExamCountDown>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = successInfo;
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestGetExamCountDownSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestGetExamCountDownFailed:failInfo];
    }
}
@end
