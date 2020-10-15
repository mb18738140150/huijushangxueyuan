//
//  MyCourseOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/29.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "MyCourseOperation.h"

@interface MyCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_MyCourse> notifiedObject;

@end

@implementation MyCourseOperation

- (void)didRequestGetMyCourseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyCourse>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.infoDic = successInfo;
    self.list = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didGetMyCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didGetMyCourseFailed:failInfo];
    }
}
@end
