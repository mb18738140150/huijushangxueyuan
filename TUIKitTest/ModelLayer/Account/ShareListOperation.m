//
//  ShareListOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import "ShareListOperation.h"

@interface ShareListOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_ShareList> notifiedObject;

@end
@implementation ShareListOperation

- (void)didRequestShareListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ShareList>)object;
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.shareList = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestShareListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestShareListFailed:failInfo];
    }
}

@end
