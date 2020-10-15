//
//  TikuMainOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/27.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "TikuMainOperation.h"

#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface TikuMainOperation ()<HttpRequestProtocol>

@end

@implementation TikuMainOperation

- (void)didTikuMain:(NSDictionary *)questionInfo withNotifiedObject:(id<TestModule_TikuMain>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestTikuMainWithInfo:questionInfo andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.infoDic = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestTikuMainSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestTikuMainFailed:failInfo];
    }
}
@end
