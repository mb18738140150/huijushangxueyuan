//
//  AssociationListOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/29.
//

#import "AssociationListOperation.h"

@interface AssociationListOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AssociationList> notifiedObject;

@end

@implementation AssociationListOperation


- (void)getAssociationListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AssociationList>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.list = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAssociationListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAssociationListFailed:failInfo];
    }
}

@end
