//
//  JudgmentOperation.m
//  zhongxin
//
//  Created by aaa on 2020/7/28.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "JudgmentOperation.h"

#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface JudgmentOperation ()<HttpRequestProtocol>

@end

@implementation JudgmentOperation

- (void)didJudgment:(NSDictionary *)questionInfo withNotifiedObject:(id<TestModule_judgmentProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestTikuMainWithInfo:questionInfo andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.infoDic = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didTestjudgmentSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didTestjudgmentFailed:failInfo];
    }
}

@end
