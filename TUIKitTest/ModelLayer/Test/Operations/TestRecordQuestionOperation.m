//
//  TestRecordQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2018/1/19.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "TestRecordQuestionOperation.h"

#import "HttpRequestManager.h"
#import "CommonMacro.h"
@interface TestRecordQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestRecordQuestionOperation

- (void)didRequestTestRecordQuestionWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_TestRecordQuestion>)object
{
    self.testRecordNotifiedObject = object;
    
    [[HttpRequestManager sharedManager] reqeustTestRecordQuestionWithInfo:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSDictionary *data = [successInfo objectForKey:@"data"];
    NSArray * shiTiArray = [data objectForKey:@"ShiTi"];
    NSMutableArray * questionArray = [NSMutableArray array];
    
    
    for (NSDictionary * questionTypeInfo in shiTiArray) {
        NSArray * questionTypeArray = [questionTypeInfo objectForKey:@"Data"];
        for (NSDictionary * questionInfo in questionTypeArray) {
            
            NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:questionInfo];
            
            NSString * contentStr = [questionInfo objectForKey:@"MinTGName"];
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"width:100%" withString:[NSString stringWithFormat:@"width:40%%"]];
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"width: 100%" withString:[NSString stringWithFormat:@"width:40%%"]];
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"width:  100%" withString:[NSString stringWithFormat:@"width:40%%"]];
            [mInfo setObject:contentStr forKey:@"MinTGName"];
            [mInfo setObject:[questionTypeInfo objectForKey:@"MaxTGName"] forKey:@"questionType"];
            
            [mInfo setObject:[data objectForKey:@"SJID"] forKey:@"SJID"];
            [mInfo setObject:[data objectForKey:@"Name"] forKey:@"NName"];
            [mInfo setObject:[data objectForKey:@"TkNo"] forKey:@"STNo"];
            [mInfo setObject:[data objectForKey:@"Ztishu"] forKey:@"zong"];
            [mInfo setObject:[data objectForKey:@"KSTime"] forKey:@"sc"];
            [mInfo setObject:[data objectForKey:@"JD"] forKey:@"JD"];
            [mInfo setObject:[questionTypeInfo objectForKey:@"TGName"] forKey:@"TGName"];
            [questionArray addObject:mInfo];
        }
    }
    
    [self.currentTestSection removeAllQuestion];
    for (NSDictionary *dic in questionArray) {
        TestQuestionModel *questionModel = [[TestQuestionModel alloc] init];
        
        //        questionModel.lid = [[dic objectForKey:@"directionId"] intValue];
        //        questionModel.kid = [[dic objectForKey:@"subjectId"] intValue];
        //        questionModel.cid = [[dic objectForKey:@"chapterId"] intValue];
        //        questionModel.uid = [[dic objectForKey:@"unitId"] intValue];
        //        questionModel.sid = [[dic objectForKey:@"simulationId"] intValue];
        //        questionModel.isEasyWrong = [[dic objectForKey:@"isEasyWrong"] intValue];
        //        questionModel.lastLogId = [[successInfo objectForKey:@"lastLogId"] longValue];
        //        questionModel.logId = [[dic objectForKey:@"logId"] intValue];
        
        questionModel.questionInfo = dic;
        questionModel.jd = [[dic objectForKey:@"JD"] intValue];
        questionModel.xh = [[dic objectForKey:@"XH"] intValue];
        questionModel.questionId = [[dic objectForKey:@"Id"] intValue];
        questionModel.questionType = [dic objectForKey:@"questionType"];
        questionModel.questionTypeId = [[dic objectForKey:@"tx"] intValue];
        questionModel.selectArray = [self selectArrayWith:[dic objectForKey:@"MyOk"]];
        if (questionModel.selectArray.count > 0) {
            questionModel.questionIsAnswered = YES;
        }
        if ([[UIUtility judgeStr:[dic objectForKey:@"TGName"]] length] > 0) {
            questionModel.questionContent = [NSString stringWithFormat:@"%@\n%@", [dic objectForKey:@"TGName"], [dic objectForKey:@"MinTGName"]];
        }else
        {
            questionModel.questionContent = [dic objectForKey:@"MinTGName"];
        }
        questionModel.questionContent = [dic objectForKey:@"MinTGName"];
        questionModel.questionComplain = [dic objectForKey:@"JX"];//analysis
        questionModel.correctAnswerIds = [dic objectForKey:@"OK"];
        questionModel.questionIsCollected = [[dic objectForKey:@"scid"] boolValue];
        questionModel.caseInfo = [UIUtility judgeStr:[dic objectForKey:@"caseInfo"]];
        NSArray *array = [dic objectForKey:@"Option"];
        
        for (int i = 0; i < array.count; i++) {
            NSString * answerStr = [array objectAtIndex:i];
            if ([answerStr class] != [NSNull class] && answerStr != nil && ![answerStr isEqualToString:@""]) {
                TestAnswerModel *answer = [[TestAnswerModel alloc] init];
                switch (i) {
                    case 0:
                        answer.answerId = @"A";
                        break;
                    case 1:
                        answer.answerId = @"B";
                        break;
                    case 2:
                        answer.answerId = @"C";
                        break;
                    case 3:
                        answer.answerId = @"D";
                        break;
                    case 4:
                        answer.answerId = @"E";
                        break;
                    default:
                        break;
                }
                
                answer.answerContent = answerStr;
                
                if ([[UIUtility judgeStr:[dic objectForKey:@"OK"]] containsString:answer.answerId]) {
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
        
        [self.currentTestSection addQuestion:questionModel];
    }
    if (isObjectNotNil(self.testRecordNotifiedObject)) {
        [self.testRecordNotifiedObject didRequestTestRecordQuestionSuccess];
    }
}

- (NSArray *)selectArrayWith:(NSString *)selectStr
{
    NSMutableArray * dataArr = [NSMutableArray array];
    if ([selectStr class] == [NSNull class] || selectStr == nil) {
        return dataArr;
    }
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

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.testRecordNotifiedObject)) {
        [self.testRecordNotifiedObject didRequestTestRecordQuestionFailed:failInfo];
    }
}
@end
