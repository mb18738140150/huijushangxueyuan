//
//  AddCourseStudyRecordOperation.m
//  zhongxin
//
//  Created by aaa on 2020/7/3.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "AddCourseStudyRecordOperation.h"

@interface AddCourseStudyRecordOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AddCourseStudyRecord> notifiedObject;

@end

@implementation AddCourseStudyRecordOperation



- (void)getAddCourseStudyRecordListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AddCourseStudyRecord>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddCourseStudyRecordSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddCourseStudyRecordFailed:failInfo];
    }
}
@end
