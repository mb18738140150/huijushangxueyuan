//
//  JingpinDynamicOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import "JingpinDynamicOperation.h"

@interface JingpinDynamicOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_jingpinDynamic> notifiedObject;

@end

@implementation JingpinDynamicOperation


- (void)getjingpinDynamicWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_jingpinDynamic>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didjingpinDynamicSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didjingpinDynamicFailed:failInfo];
    }
}

@end
