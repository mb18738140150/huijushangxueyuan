//
//  TestErrorQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestErrorQuestionOperation.h"
#import "HttpRequestManager.h"
#import "TestChapterModel.h"
#import "CommonMacro.h"
#import "TestAnswerModel.h"

@interface TestErrorQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestErrorQuestionOperation

- (void)didRequestErrorQuestionWithSectionId:(NSDictionary *)sectionInfo andNotifiedObject:(id<TestModule_ErrorQuestionProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustTestErrorQuesitonWithSectionId:sectionInfo andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSArray *data = [successInfo objectForKey:@"data"];
    [self.currentTestSection removeAllQuestion];
    for (NSDictionary *dic in data) {
        TestQuestionModel *questionModel = [[TestQuestionModel alloc] init];
        questionModel.lid = [[dic objectForKey:@"directionId"] intValue];
        questionModel.kid = [[dic objectForKey:@"subjectId"] intValue];
        questionModel.cid = [[dic objectForKey:@"chapterId"] intValue];
        questionModel.uid = [[dic objectForKey:@"unitId"] intValue];
        questionModel.sid = [[dic objectForKey:@"simulationId"] intValue];
        questionModel.isEasyWrong = [[dic objectForKey:@"isEasyWrong"] intValue];
        questionModel.questionId = [[dic objectForKey:@"id"] intValue];
        questionModel.questionType = [dic objectForKey:@"questionType"];
        
        questionModel.questionTypeId = [[dic objectForKey:@"questionTypeId"] intValue];
        questionModel.lastLogId = [[successInfo objectForKey:@"lastLogId"] longValue];
        questionModel.selectArray = [self selectArrayWith:[dic objectForKey:@"myAnswers"]];
        if (questionModel.selectArray.count > 0) {
            questionModel.questionIsAnswered = YES;
        }
        
        questionModel.questionContent = [self replaceOtherString:[dic objectForKey:@"question"]];
        questionModel.questionComplain = [self replaceOtherString1:[dic objectForKey:@"analysis"]];
        questionModel.correctAnswerIds = [dic objectForKey:@"answer"];
        questionModel.questionIsCollected = [[dic objectForKey:@"isCollect"] boolValue];
        questionModel.caseInfo = [UIUtility judgeStr:[dic objectForKey:@"caseInfo"]];
        NSString *a = [dic objectForKey:@"answer"];
        NSString *str = [dic objectForKey:@"items"];
        NSArray *array = [str componentsSeparatedByString:@"|"];
        
        for (int i = 0; i < array.count; i++) {
            NSString * answerStr = [array objectAtIndex:i];
            if ([answerStr class] != [NSNull class] && answerStr != nil && ![answerStr isEqualToString:@""]) {
                TestAnswerModel *answer = [[TestAnswerModel alloc] init];
                answer.answerContent = answerStr;
                unichar c = [answerStr characterAtIndex:0];
                answer.answerId = [NSString stringWithFormat:@"%c",c];
                if ([a containsString:answer.answerId]) {
                    answer.isCorrectAnswer = YES;
                }else{
                    answer.isCorrectAnswer = NO;
                }
                if ([questionModel.questionType isEqualToString:@"判断题"]  ) {
                    if (i < 2) {
                        [questionModel.answers addObject:answer];
                    }
                }else
                {
                    [questionModel.answers addObject:answer];
                }
                
            }
        }
        
//        for (NSString *str1 in array) {
//            NSArray *subArray = [str1 componentsSeparatedByString:@"</p>"];
//            for (NSString *answerStr in subArray) {
//                if ([answerStr class] != [NSNull class] && answerStr != nil && ![answerStr isEqualToString:@""]) {
//                    TestAnswerModel *answer = [[TestAnswerModel alloc] init];
//                    answer.answerContent = answerStr;
//                    unichar c = [answerStr characterAtIndex:0];
//                    answer.answerId = [NSString stringWithFormat:@"%c",c];
//                    if ([a containsString:answer.answerId]) {
//                        answer.isCorrectAnswer = YES;
//                    }else{
//                        answer.isCorrectAnswer = NO;
//                    }
//                    [questionModel.answers addObject:answer];
//                    
//                }
//            }
//        }
        [self.currentTestSection addQuestion:questionModel];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestErrorQuestionSuccess];
    }
}

- (NSArray *)selectArrayWith:(NSString *)selectStr
{
    NSMutableArray * dataArr = [NSMutableArray array];
    if (selectStr.length == 0) {
        return dataArr;
    }
    if (selectStr.length > 4) {
        [dataArr addObject:selectStr];
    }else
    {
        
        for (int i = 0; i< selectStr.length; i++) {
            NSString * selectAnswer = [selectStr substringWithRange:NSMakeRange(i, 1)];
            [dataArr addObject:selectAnswer];
            
        }
    }
    
    return dataArr;
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestErrorQuestionFailed:failInfo];
    }
}

- (NSString * )replaceOtherString:(NSString *)string
{
    NSString * answerStr1 = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    answerStr1 = [answerStr1 stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    answerStr1 = [answerStr1 stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    return answerStr1;
}

- (NSString * )replaceOtherString1:(NSString *)string
{
    NSString * answerStr1 = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    answerStr1 = [answerStr1 stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    answerStr1 = [answerStr1 stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    answerStr1 = [answerStr1 stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    answerStr1 = [answerStr1 stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    return answerStr1;
}

@end
