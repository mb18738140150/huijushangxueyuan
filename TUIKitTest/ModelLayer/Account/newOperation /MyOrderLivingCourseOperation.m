//
//  MyOrderLivingCourseOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/19.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "MyOrderLivingCourseOperation.h"

@interface MyOrderLivingCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_MyOrderLivingCourse> notifiedObject;

@end

@implementation MyOrderLivingCourseOperation

- (NSMutableArray *)courseNoteList
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)getMyOrderLivingCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyOrderLivingCourse>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = successInfo;
    self.list = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyOrderLivingCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyOrderLivingCourseFailed:failInfo];
    }
}
@end
