//
//  AssociationDetailOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import "AssociationDetailOperation.h"

@interface AssociationDetailOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AssociationDetail> notifiedObject;

@end

@implementation AssociationDetailOperation


- (void)getAssociationDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AssociationDetail>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAssociationDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didAssociationDetailFailed:failInfo];
    }
}
@end
