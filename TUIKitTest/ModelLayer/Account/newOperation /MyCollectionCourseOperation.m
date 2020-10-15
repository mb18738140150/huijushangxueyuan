//
//  MyCollectionCourseOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/19.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "MyCollectionCourseOperation.h"

@interface MyCollectionCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_MyCollectionCourse> notifiedObject;

@end

@implementation MyCollectionCourseOperation

- (NSMutableArray *)courseNoteList
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)getMyCollectionCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyCollectionCourse>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = successInfo;
    self.list = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyCollectionCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyCollectionCourseFailed:failInfo];
    }
}
@end
