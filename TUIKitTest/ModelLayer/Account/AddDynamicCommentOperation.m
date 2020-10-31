//
//  AddDynamicCommentOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/31.
//

#import "AddDynamicCommentOperation.h"

@interface AddDynamicCommentOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AddDynamicComment> notifiedObject;

@end

@implementation AddDynamicCommentOperation


- (void)getAddDynamicCommentWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AddDynamicComment>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAddDynamicCommentSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAddDynamicCommentFailed:failInfo];
    }
}
@end
