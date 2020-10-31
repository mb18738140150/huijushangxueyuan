//
//  JoinAssociationOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import "JoinAssociationOperation.h"

@interface JoinAssociationOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_JoinAssociation> notifiedObject;

@end

@implementation JoinAssociationOperation


- (void)getJoinAssociationWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_JoinAssociation>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didJoinAssociationSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didJoinAssociationFailed:failInfo];
    }
}

@end
