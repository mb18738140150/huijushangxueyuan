//
//  MyPromotionOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import "MyPromotionOperation.h"

@interface MyPromotionOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_Promotion> notifiedObject;

@end

@implementation MyPromotionOperation


- (void)getPromotionWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_Promotion>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didPromotionSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didPromotionFailed:failInfo];
    }
}
@end
