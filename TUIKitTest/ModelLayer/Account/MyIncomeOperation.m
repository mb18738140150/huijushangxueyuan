//
//  MyIncomeOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/26.
//

#import "MyIncomeOperation.h"

@interface MyIncomeOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_IncomeInfo> notifiedObject;

@end

@implementation MyIncomeOperation


- (void)getIncomeInfoWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_IncomeInfo>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didIncomeInfoSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didIncomeInfoFailed:failInfo];
    }
}
@end
