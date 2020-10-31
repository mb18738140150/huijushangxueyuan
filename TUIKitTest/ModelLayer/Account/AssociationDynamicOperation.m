//
//  AssociationDynamicOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import "AssociationDynamicOperation.h"

@interface AssociationDynamicOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AssociationDynamic> notifiedObject;

@end

@implementation AssociationDynamicOperation


- (void)getAssociationDynamicWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AssociationDynamic>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.list = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAssociationDynamicSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAssociationDynamicFailed:failInfo];
    }
}
@end
