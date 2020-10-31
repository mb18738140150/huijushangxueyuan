//
//  DeleteDynamicOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import "DeleteDynamicOperation.h"

@interface DeleteDynamicOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_deleteDynamic> notifiedObject;

@end

@implementation DeleteDynamicOperation


- (void)getdeleteDynamicWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_deleteDynamic>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didDeleteDynamicSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didDeleteDynamicFailed:failInfo];
    }
}

@end
