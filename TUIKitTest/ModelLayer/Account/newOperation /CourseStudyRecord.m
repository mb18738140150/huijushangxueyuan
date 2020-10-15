//
//  CourseStudyRecord.m
//  zhongxin
//
//  Created by aaa on 2020/6/29.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "CourseStudyRecord.h"

@interface CourseStudyRecord ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CourseStudyRecord> notifiedObject;

@end

@implementation CourseStudyRecord

- (NSMutableArray *)courseNoteList
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)getCourseStudyRecordListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseStudyRecord>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.list = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCourseStudyRecordSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCourseStudyRecordFailed:failInfo];
    }
}
@end
