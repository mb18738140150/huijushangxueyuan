//
//  DeleteDynamicComment.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/31.
//

#import "DeleteDynamicComment.h"

@interface DeleteDynamicComment ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_DeleteDynamicComment> notifiedObject;

@end

@implementation DeleteDynamicComment


- (void)getDeleteDynamicCommentWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_DeleteDynamicComment>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didDeleteDynamicCommentSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didDeleteDynamicCommentFailed:failInfo];
    }
}
@end
