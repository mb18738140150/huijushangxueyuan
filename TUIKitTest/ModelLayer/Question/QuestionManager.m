//
//  QuestionManager.m
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "QuestionManager.h"
#import "HttpRequestManager.h"
#import "QuestionOperation.h"
#import "QuestionModuleModels.h"
#import "QuestionDetailOperation.h"
#import "CommonMacro.h"
#import "QuestionMainViewOperation.h"
#import "QuestionPublishOperation.h"
#import "MyQuestionNotReplyOperation.h"
#import "MyQuestionAlreadyReplyOperation.h"
#import "QuestionCollectOperation.h"
#import "QuestionReplayOperation.h"

@interface QuestionManager ()

@property (nonatomic,strong) QuestionModuleModels       *questionModuleModels;

@property (nonatomic,strong) QuestionOperation          *questionOperation;

@property (nonatomic,strong) QuestionDetailOperation    *questionDetailOperation;

@property (nonatomic,strong) QuestionMainViewOperation  *questionMainOperation;

@property (nonatomic,strong) QuestionPublishOperation   *questionPublishOperation;

@property (nonatomic,strong) MyQuestionNotReplyOperation        *myQuestionNotReplyOperation;
@property (nonatomic,strong) MyQuestionAlreadyReplyOperation    *myQuestionAlreadyReplyOperation;
@property (nonatomic,strong) QuestionCollectOperation    *questionCollectOperation;
@property (nonatomic,strong) QuestionReplayOperation    *questionReplayOperation;


@end

@implementation QuestionManager

+ (instancetype)sharedManager
{
    static QuestionManager      *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[QuestionManager alloc] init];
    });
    return __manager__;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.questionModuleModels = [[QuestionModuleModels alloc] init];
        
        self.questionOperation = [[QuestionOperation alloc] init];
        [self.questionOperation setCurrentShowQuestionModels:self.questionModuleModels.showQuestionModel];
        self.questionOperation.moduleModel = self.questionModuleModels;
        
        self.questionDetailOperation = [[QuestionDetailOperation alloc] init];
        self.questionDetailOperation.detailModel = self.questionModuleModels.questionDetailModel;
        
        self.questionMainOperation = [[QuestionMainViewOperation alloc] init];
        self.questionMainOperation.mainViewQuestionModel = self.questionModuleModels.mainViewQuestionModel;
        
        self.questionPublishOperation = [[QuestionPublishOperation alloc] init];
        
        self.myQuestionNotReplyOperation = [[MyQuestionNotReplyOperation alloc] init];
        self.myQuestionNotReplyOperation.notReplyQuestionArray = self.questionModuleModels.notReplyQuestionArray;
        self.myQuestionAlreadyReplyOperation = [[MyQuestionAlreadyReplyOperation alloc] init];
        self.myQuestionAlreadyReplyOperation.alreadyReplyQuestionArray = self.questionModuleModels.alreadyReplyQuestionArray;
        self.questionCollectOperation = [[QuestionCollectOperation alloc] init];
        self.questionReplayOperation = [[QuestionReplayOperation alloc] init];

    }
    return self;
}

- (BOOL)isLoadMax
{
    return self.questionModuleModels.isLoadMax;
}

- (void)resetQuestionRequestConfig
{
    [self.questionOperation clearAllQuestions];
    [self.questionModuleModels resetLoadInfos];
}

- (void)didCurrentPageQuestionRequestWithNotifiedObject:(id<QuestionModule_QuestionProtocol>)object andTypeInfo:(NSDictionary *)infoDic
{
    [self.questionModuleModels resetPage];
    int pageCount = -1;
    
    
    [self.questionOperation didRequestQuestionWithPageIndex:infoDic andNotifiedObject:object];
}

- (void)didNextPageQuestionRequestWithNotifiedObject:(id<QuestionModule_QuestionProtocol>)object andTypeInfo:(NSDictionary *)infoDic
{
    int nextPage = [self.questionModuleModels nextPage];
    
    NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:infoDic];
    [mInfo setObject:@(nextPage) forKey:@"pageNo"];
    
    [self.questionOperation didRequestQuestionWithPageIndex:mInfo andNotifiedObject:object];
}

- (void)didRequestCollectQuestionWithQuestionInfos:(NSDictionary *)dicInfo withNotifiedObject:(id<QuestionModule_CollectQuestion>)object
{
    [self.questionCollectOperation didCollectQuestion:dicInfo withNotifiedObject:object];
}

- (void)didRequestReplayQuestionWithQuestionInfos:(NSDictionary *)dicInfo withNotifiedObject:(id<QuestionModule_ReplayQuestion>)object
{
    [self.questionReplayOperation didReplayQuestion:dicInfo withNotifiedObject:object];
}


- (void)didRequestPublishQuestionWithQuestionInfos:(NSDictionary *)dicInfo withNotifiedObject:(id<QuestionModule_QuestionPublishProtocol>)object
{
    [self.questionPublishOperation didPublishQuestion:dicInfo withNotifiedObject:object];
}

- (void)didRequestQuestionDetailWithQuestionId:(NSDictionary *)infoDic andNotifiedObject:(id<QuestionModule_QuestionDetailProtocol>)object
{
    [self.questionDetailOperation didRequestQuestionDetailWithQuestionId:infoDic andNotifiedObject:object];
}

- (void)didRequestMainPageQuestionRequestWithNotifiedObject:(id<QuestionModule_QuestionProtocol>)object andTypeInfo:(NSDictionary *)infoDic
{
    [self.questionMainOperation didRequestQuestionWithPageIndex:@{@"pageCount":@(-1),
                                                                  @"findType":[infoDic objectForKey:@"findType"],
                                                                  @"sortType":[infoDic objectForKey:@"sortType"]} andNotifiedObject:object];
}



- (void)didRequestMyQuestionAlreadyReplyWithNotifiedObject:(id<QuestionModule_MyQuestionAlreadyReply>)object
{
    [self.myQuestionAlreadyReplyOperation didRequestMyQuestionAlreadyReplyWithNotifiedObject:object];
}

- (void)didRequestMyQuestionNotReplyWithNotifiedObject:(id<QuestionModule_MyQuestionNotReply>)object
{
    [self.myQuestionNotReplyOperation didRequestMyQuestionNotReplyWithNotifiedObject:object];
}

#pragma mark - get funcs
- (NSArray *)getQuestionsInfos
{
    return self.questionModuleModels.showQuestionModel.questionArray;
    
    NSMutableArray *questionInfoArray = [[NSMutableArray alloc] init];
    for (QuestionModel *questionModel in self.questionModuleModels.showQuestionModel.showQuestionModels) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [tmpDic setObject:questionModel.questionContent forKey:kQuestionContent];
        [tmpDic setObject:questionModel.questionTime forKey:kQuestionTime];
        [tmpDic setObject:@(questionModel.questionId) forKey:kQuestionId];
        [tmpDic setObject:@(questionModel.questionSeeCount) forKey:kQuestionSeePeopleCount];
        [tmpDic setObject:@(questionModel.questionQuizzerId) forKey:kQuestionQuizzerId];
        [tmpDic setObject:questionModel.questionQuizzerUserName forKey:kQuestionQuizzerUserName];
        [tmpDic setObject:questionModel.questionQuizzerHeaderImageUrl forKey:kQuestionQuizzerHeaderImageUrl];
//        [tmpDic setObject:questionModel.questionQuizzerName forKey:kQuestionQuizzerUserName];
        [tmpDic setObject:@(questionModel.questionReplyCount) forKey:kQuestionReplyCount];
        [tmpDic setObject:questionModel.replyList forKey:@"replyList"];
        [questionInfoArray addObject:tmpDic];
    }
    return questionInfoArray;
}

- (NSDictionary *)getQuestionsTotalInfo
{
    return self.questionOperation.info;
}

- (NSArray *)getMainQuestionInfos
{
    NSMutableArray *questionInfoArray = [[NSMutableArray alloc] init];
    for (QuestionModel *questionModel in self.questionModuleModels.mainViewQuestionModel.showQuestionModels) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [tmpDic setObject:questionModel.questionContent forKey:kQuestionContent];
        [tmpDic setObject:questionModel.questionTime forKey:kQuestionTime];
        [tmpDic setObject:@(questionModel.questionId) forKey:kQuestionId];
        [tmpDic setObject:@(questionModel.questionSeeCount) forKey:kQuestionSeePeopleCount];
        [tmpDic setObject:@(questionModel.questionQuizzerId) forKey:kQuestionQuizzerId];
        [tmpDic setObject:questionModel.questionQuizzerUserName forKey:kQuestionQuizzerUserName];
        [tmpDic setObject:questionModel.questionQuizzerHeaderImageUrl forKey:kQuestionQuizzerHeaderImageUrl];
        //        [tmpDic setObject:questionModel.questionQuizzerName forKey:kQuestionQuizzerUserName];
        [tmpDic setObject:@(questionModel.questionReplyCount) forKey:kQuestionReplyCount];
        [questionInfoArray addObject:tmpDic];
    }
    return questionInfoArray;
}

- (NSDictionary *)getDetailQuestionInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    QuestionDetailModel *model = self.questionModuleModels.questionDetailModel;
    [dic setObject:model.questionContent forKey:kQuestionContent];
    [dic setObject:model.questionQuizzerHeaderImageUrl forKey:kQuestionQuizzerHeaderImageUrl];
    [dic setObject:model.questionQuizzerUserName forKey:kQuestionQuizzerUserName];
    [dic setObject:model.questionTime forKey:kQuestionTime];
    [dic setObject:@(model.questionReplyCount) forKey:kQuestionReplyCount];
    [dic setObject:@(model.questionSeeCount) forKey:kQuestionSeePeopleCount];
    [dic setObject:model.questionImgArray forKey:kQuestionImgStr];
    return dic;
}

- (NSArray *)getDetailQuestionReplyArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (QuestionReplyModel *model in self.questionModuleModels.questionDetailModel.questionReplys) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [tmpDic setObject:model.replierHeaderImageUrl forKey:kReplierHeaderImage];
        [tmpDic setObject:model.replierUserName forKey:kReplierUserName];
        [tmpDic setObject:model.replyContent forKey:kReplyContent];
        [tmpDic setObject:model.replyTime forKey:kReplyTime];
        [tmpDic setObject:@(model.replayId) forKey:kReplyId];
        
        NSMutableArray * askedArr = [NSMutableArray array];
        for (NSDictionary *infoDic in model.askedArray) {
            [askedArr addObject:infoDic];
        }
        [tmpDic setObject:askedArr forKey:kAskedArray];
        [array addObject:tmpDic];
    }
    return array;
}

- (NSArray *)getAlreadyReplyQuestionArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (QuestionModel *model in self.questionModuleModels.alreadyReplyQuestionArray) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [tmpDic setObject:model.questionContent forKey:kQuestionContent];
        [tmpDic setObject:@(model.questionId) forKey:kQuestionId];
        [tmpDic setObject:@(model.questionReplyCount) forKey:kQuestionReplyCount];
        [array addObject:tmpDic];
    }
    return array;
}

- (NSArray *)getNotReplyQuestionArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (QuestionModel *model in self.questionModuleModels.notReplyQuestionArray) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [tmpDic setObject:model.questionContent forKey:kQuestionContent];
        [tmpDic setObject:@(model.questionId) forKey:kQuestionId];
        [array addObject:tmpDic];
    }
    return array;
}

- (NSDictionary *)getQuestionDetailInfo
{
    return self.questionDetailOperation.infoDic;
}

@end
