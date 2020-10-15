//
//  QuestionReplayOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/25.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "QuestionReplayOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface QuestionReplayOperation ()<HttpRequestProtocol>

@end

@implementation QuestionReplayOperation

- (void)didReplayQuestion:(NSDictionary *)questionInfo withNotifiedObject:(id<QuestionModule_ReplayQuestion>)object{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestReplayQuestionWithInfo:questionInfo andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didReplayQuestionRequestSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didReplayQuestionRequestFailed:failInfo];
    }
}
@end
