//
//  TestSimulateQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/22.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestSimulateQuestionOperation.h"
#import "CommonMacro.h"
#import "HttpRequestManager.h"
#import "TestAnswerModel.h"
#import "UIUtility.h"

@interface TestSimulateQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestSimulateQuestionOperation

- (void)didRequestSimulateQuestionWithTestId:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_SimulateQuestionProtocol>)object
{
    self.notifiedObject = object;
    self.simulateModel.simulateId = [[infoDic objectForKey:ksjid] intValue];
    [[HttpRequestManager sharedManager] requestTestSimulateQuestionWithTestId:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSDictionary *data = [successInfo objectForKey:@"result"];
    NSArray * shiTiArray = [data objectForKey:@"items"];
    NSMutableArray * questionArray = [NSMutableArray array];
    
    int jd = 0;
    for (NSInteger i = shiTiArray.count - 1; i >= 0; i--) {
        NSDictionary * questionInfo = [shiTiArray objectAtIndex:i];
        if ([[questionInfo objectForKey:@"isAnwsered"] boolValue]) {
            jd = i + 1;
            break;
        }
    }
    
    for (NSDictionary * questionInfo in shiTiArray) {
            NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:questionInfo];

            NSString * contentStr = [questionInfo objectForKey:@"subject"];
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"width:100%" withString:[NSString stringWithFormat:@"width:40%%"]];
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"width: 100%" withString:[NSString stringWithFormat:@"width:40%%"]];
            contentStr = [contentStr stringByReplacingOccurrencesOfString:@"width:  100%" withString:[NSString stringWithFormat:@"width:40%%"]];
            [mInfo setObject:contentStr forKey:@"subject"];
            [mInfo setObject:[questionInfo objectForKey:@"typeName"] forKey:@"questionType"];

            [mInfo setObject:[data objectForKey:@"examinationId"] forKey:@"examinationId"];
            [mInfo setObject:[data objectForKey:@"paperId"] forKey:@"SJID"];
            [mInfo setObject:[data objectForKey:@"paperName"] forKey:@"NName"];
            [mInfo setObject:@(shiTiArray.count) forKey:@"zong"];
            [mInfo setObject:@(jd) forKey:@"JD"];
            [mInfo setObject:[questionInfo objectForKey:@"subject"] forKey:@"subject"];
            [mInfo setObject:[data objectForKey:@"anwserLogId"] forKey:@"anwserLogId"];
            [questionArray addObject:mInfo];
        }
    
    [self.simulateModel removeAllQuestion];
    
    for (NSDictionary *dic in questionArray) {
        TestQuestionModel *questionModel = [[TestQuestionModel alloc] init];
        
        questionModel.questionInfo = dic;
        questionModel.anwserLogId = [dic objectForKey:@"anwserLogId"];
        questionModel.examinationId = [dic objectForKey:@"examinationId"];
        questionModel.jd = jd;
        questionModel.xh = [[dic objectForKey:@"number"] intValue];
        questionModel.questionId = [[dic objectForKey:@"questionId"] intValue];
        questionModel.questionType = [dic objectForKey:@"questionType"];
        questionModel.questionTypeId = [[dic objectForKey:@"type"] intValue];
        questionModel.selectArray = [self selectArrayWith:[dic objectForKey:@"userAnwser"]];
        if (questionModel.selectArray.count > 0) {
            questionModel.questionIsAnswered = YES;
        }
        if ([[UIUtility judgeStr:[dic objectForKey:@"TGName"]] length] > 0) {
            questionModel.questionContent = [NSString stringWithFormat:@"%@\n%@", [dic objectForKey:@"TGName"], [dic objectForKey:@"MinTGName"]];
        }else
        {
            questionModel.questionContent = [dic objectForKey:@"subject"];
        }
        questionModel.questionContent = [dic objectForKey:@"subject"];
        questionModel.questionComplain = [dic objectForKey:@"analysis"];//analysis
        questionModel.correctAnswerIds = [dic objectForKey:@"refrenceAnswer"];
        questionModel.questionIsCollected = [[dic objectForKey:@"isAddFavorites"] boolValue];
        questionModel.caseInfo = [self removemarks:[UIUtility judgeStr:[dic objectForKey:@"parentSubject"]]];
        NSArray *array = [dic objectForKey:@"optionUserAnwser"];
        
        for (int i = 0; i < array.count; i++) {
            NSDictionary * answerDic = [array objectAtIndex:i];
            if ([answerDic class] != [NSNull class] && answerDic != nil ) {
                TestAnswerModel *answer = [[TestAnswerModel alloc] init];
                answer.answerId = [answerDic objectForKey:@"letter"];
                
                answer.answerContent = [self removemarks:[UIUtility judgeStr:[answerDic objectForKey:@"text"]]];
                answer.isCorrectAnswer = [[answerDic objectForKey:@"isAnwser"] boolValue];
                
                if (questionModel.questionTypeId == 3 ) {
                    if (i < 2) {
                        [questionModel.answers addObject:answer];
                    }
                }else
                {
                    [questionModel.answers addObject:answer];
                }
                
            }
        }
        
        [self.simulateModel addQuestion:questionModel];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSimulateQuestionSuccess];
    }
}

- (NSString *)removemarks:(NSString *)string
{
    NSString * nString = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    nString = [nString stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    return nString;
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
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestSimulateQuestionFailed:failInfo];
    }
}

@end
