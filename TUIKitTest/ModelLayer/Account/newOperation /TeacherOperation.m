//
//  TeacherOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/15.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "TeacherOperation.h"

@interface TeacherOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CourseTeacherProtocol> notifiedObject;

@end

@implementation TeacherOperation

- (NSMutableArray *)courseNoteList
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)getCourseTeacherWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseTeacherProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.list = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCourseTeacherSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCourseTeacherFailed:failInfo];
    }
}
@end
