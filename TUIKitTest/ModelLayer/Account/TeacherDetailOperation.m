//
//  TeacherDetailOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import "TeacherDetailOperation.h"

@interface TeacherDetailOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_TeacherDetailProtocol> notifiedObject;

@end

@implementation TeacherDetailOperation

- (void)getTeacherDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_TeacherDetailProtocol>)object;
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didTeacherDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didTeacherDetailFailed:failInfo];
    }
}
@end
