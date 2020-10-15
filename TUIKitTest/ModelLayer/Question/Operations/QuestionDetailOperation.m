//
//  QuestionDetailOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/7.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionDetailOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface QuestionDetailOperation ()<HttpRequestProtocol>

@end

@implementation QuestionDetailOperation

- (void)didRequestQuestionDetailWithQuestionId:(NSDictionary *)infoDic andNotifiedObject:(id<QuestionModule_QuestionDetailProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestQuestionDetailWithQuestionId:infoDic withProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.detailModel removeAllReplys];
    [self.detailModel removeAllImages];
    
    self.infoDic = [successInfo objectForKey:@"result"];
    
//    NSDictionary *data = [successInfo objectForKey:@"data"];
//    NSArray *imgs = [data objectForKey:@"imgStr"];
//    if ([imgs class] != [NSNull class]) {
//        for (NSString *imgStr in imgs) {
//            if (imgStr != nil && ![imgStr isEqualToString:@""]) {
//                [self.detailModel addImageUrl:imgStr];
//            }
//        }
//    }
//
//    self.detailModel.questionQuizzerHeaderImageUrl = [data objectForKey:@"avatar"];
//    self.detailModel.questionContent = [data objectForKey:@"questionMsg"];
//    self.detailModel.questionTime = [data objectForKey:@"questionTime"];
//    self.detailModel.questionReplyCount = [[UIUtility judgeStr:[data objectForKey:@"replyNum"]] intValue];
//    self.detailModel.questionSeeCount = [[UIUtility judgeStr:[data objectForKey:@"seeNum"]] intValue];
//    self.detailModel.questionQuizzerUserName = [UIUtility judgeStr:[data objectForKey:@"userName"]];
//
//    for (int i = 0; i < 1; i++) {
//        QuestionReplyModel *model = [[QuestionReplyModel alloc] init];
//        model.replyContent = [UIUtility judgeStr:[data objectForKey:@"replyCon"]];
//        model.replyTime = [UIUtility judgeStr:[data objectForKey:@"replyTime"]];
//        model.replierUserName = [UIUtility judgeStr:[data objectForKey:@"coachName"]];
//        model.replierHeaderImageUrl = [UIUtility judgeStr:[data objectForKey:@"coachImg"]];
//        model.replayId = [[UIUtility judgeStr:[data objectForKey:@"coachId"]] intValue];
//        for (NSDictionary *askedDic in [data objectForKey:@"askedList"]) {
//            [model.askedArray addObject:askedDic];
//        }
//        if (model.replayId != 0) {
//            [self.detailModel addQuestionReply:model];
//        }
//    }
    
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didQuestionRequestSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didQuestionRequestFailed:failInfo];
    }
}

@end
