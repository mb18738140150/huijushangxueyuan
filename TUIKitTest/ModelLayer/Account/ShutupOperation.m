//
//  ShutupOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/13.
//

#import "ShutupOperation.h"


@interface ShutupOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_Shutup> notifiedObject;

@end
@implementation ShutupOperation

- (void)didRequestShutupWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_Shutup>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestShutupSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestShutupFailed:failInfo];
    }
}
@end
