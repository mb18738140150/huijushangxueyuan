//
//  QuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionOperation.h"
#import "HttpRequestManager.h"
#import "CommonMacro.h"

@interface QuestionOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<QuestionModule_QuestionProtocol>               notifiedObject;
@property (nonatomic,weak) ShowQuestionModel                               *showQuestionModel;

@property (nonatomic, strong)NSDictionary * typeInfo;

@end

@implementation QuestionOperation

- (void)setCurrentShowQuestionModels:(ShowQuestionModel *)model
{
    self.showQuestionModel = model;
}

- (void)didRequestQuestionWithPageIndex:(NSDictionary *)infoDic andNotifiedObject:(id<QuestionModule_QuestionProtocol>)object
{
    self.typeInfo = infoDic;
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestQuestionWithPageIndex:infoDic withProcessDelegate:self];;
}

- (void)clearAllQuestions
{
    [self.showQuestionModel removeAllQuestionModels];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.moduleModel.isLoadMax = NO;
    NSArray *questionArray = [successInfo objectForKey:@"result"];
    self.info = successInfo;
    if ([[self.typeInfo objectForKey:@"pageNo"] intValue] <= 1) {
        [self.showQuestionModel removeAllQuestionModels];
    }
    
    if (questionArray.count == 0) {
        self.moduleModel.isLoadMax = YES;
    }
    
    if (self.showQuestionModel.questionArray.count >= [[[successInfo objectForKey:@"page"] objectForKey:@"recordCount"] intValue]) {
        
    }else
    {
        for (NSDictionary *tmpDic in questionArray) {
            
            NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:tmpDic];
            
            [self.showQuestionModel.questionArray addObject:mInfo];
        }
    }
    
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
