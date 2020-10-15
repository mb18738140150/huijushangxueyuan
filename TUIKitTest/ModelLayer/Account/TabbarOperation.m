//
//  TabbarOperation.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "TabbarOperation.h"
@interface TabbarOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<UserModule_TabbarList> notifiedObject;

@end
@implementation TabbarOperation

- (void)didRequestTabbarWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_TabbarList>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustRegistWithdic:infoDic andProcessDelegate:self];
}

#pragma mark - http request
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    self.list = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didTabbarListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didTabbarListFailed:failInfo];
    }
}

@end
