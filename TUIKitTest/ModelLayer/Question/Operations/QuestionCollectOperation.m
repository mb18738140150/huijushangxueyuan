//
//  QuestionCollectOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/24.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "QuestionCollectOperation.h"

#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface QuestionCollectOperation ()<HttpRequestProtocol>

@end

@implementation QuestionCollectOperation

- (void)didCollectQuestion:(NSDictionary *)questionInfo withNotifiedObject:(id<QuestionModule_CollectQuestion>)object{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestCollectQuestionWithInfo:questionInfo andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCollectQuestionRequestSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCollectQuestionRequestFailed:failInfo];
    }
}
@end
