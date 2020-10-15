//
//  TestManager.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleModels.h"
#import "TestModuleProtocol.h"

typedef enum {
    CollectTypeTest = 0,
    CollectTypeSimulate,
    CollectTypeSimulateWrong
}CollectType;

@interface TestManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign)CollectType colectType;

// 题库信息
- (void)didRequestTikuMainWithInfo:(NSDictionary *)cateInfo andNotifiedObject:(id<TestModule_TikuMain>)notifiedObject;
- (NSDictionary *)getTikkuMainInfo;

- (void)getSecondCategoryeWith:(NSDictionary *)info withNotifiedObject:(id<TestModule_SecondCategoryProtocol>)object;
- (NSArray *)getSecondCategoryeArray;

/**
 请求题库权限
 
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestJurisdictionWithcourseId:(int)courseId NotifiedObject:(id<TestModule_JurisdictionProtocol>)notifiedObject;

/**
 请求题库所有类型的信息

 @param notifiedObject 请求成功后通知的对象
 */
//- (void)didRequestTestAllCategoryWithNotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject;

- (NSArray *)getAllCategory;

- (void)didRequestTestAllCategoryWithUserId:(int )userID NotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject;
- (NSArray *)getNotLoginAllCategory;

/**
 请求某一题库类型的章节信息

 @param cateId 题库类别id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequesTestChapterInfoWithCategoryId:(NSDictionary *)cateId andNotifiedObject:(id<TestModule_ChapterInfoProtocol>)notifiedObject;


/**
 请求某一节的所有问题信息

 @param sectionId 节id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestSectionQuestionWithSection:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_SectionQuestionProtocol>)notifiedObject;


/**
 请求某一题库类别的模拟试题列表信息

 @param cateId 题库类别id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestSimulateInfoWithCategoryId:(NSDictionary *)cateInfo andNotifiedObject:(id<TestModule_SimulateInfoProtocol>)notifiedObject;


/**
 请求某一模拟试题的所有问题信息

 @param testId 模拟试题id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestSimulateQuestionWithTestId:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_SimulateQuestionProtocol>)notifiedObject;


/**
 请求模拟试题的答案得分情况

 @param array 试题的全部答案
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestSimulateScoreWithInfo:(NSArray *)array andNotifiedObject:(id<TestModule_SimulateScoreProtocol>)notifiedObject;


/**
 请求某一题库类别下的一错题章信息

 @param cateId 题库类别id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestErrorInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_ErrorInfoProtocol>)notifiedObject;


/**
 请求易错题某一章下面的所有问题

 @param sectionId 章id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestErrorQuestionWithSectionId:(NSDictionary *)sectionId andNotifiedObject:(id<TestModule_ErrorQuestionProtocol>)notifiedObject;


/**
 请求添加我的错题

 @param questionId 问题id
 */
- (void)didRequestTestAddMyWrongQuestionWithQuestionId:(int)questionId;


/**
 请求某一题库类别下我的错题（错题重做）所有章的信息

 @param cateId 题库类别id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestMyWrongQuestionChapterInfoWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_MyWrongQuestionInfoProtocol>)notifiedObject;


/**
 请求某一章下我的错题所有问题

 @param chapterId 章id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestMyWrongQuestionListWithChapterId:(NSDictionary *)chapterId andNotifiedObject:(id<TestModule_MyWrongQuestionsListProtocol>)notifiedObject;

/**
 请求某一题库类别下的收藏章信息
 
 @param cateId 题库类别id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestCollectionInfoWithCategoryId:(NSDictionary *)cateId andNotifiedObject:(id<TestModule_CollectQuestionInfoProtocol>)notifiedObject;

- (void)didRequestTestCollectionInfoMonishitiWithCategoryId:(NSDictionary *)cateId andNotifiedObject:(id<TestModule_CollectQuestionInfoProtocol>)notifiedObject;

- (void)didRequestTestCollectionInfoLinianzhentiWithCategoryId:(NSDictionary *)cateId andNotifiedObject:(id<TestModule_CollectQuestionInfoProtocol>)notifiedObject;

- (NSArray *)getTestCollectionInfoArray;
- (NSArray *)getTestCollectionInfoMonishitiArray;
- (NSArray *)getTestCollectionInfoLinianzhentiArray;


/**
 请求收藏某一章下面的所有问题
 
 @param chapterId 章id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestCollectionQuestionListWithChapterId:(NSDictionary *)chapterId andNotifiedObject:(id<TestModule_CollectQuestionListProtocol>)notifiedObject;

/**
 请求收藏某个问题

 @param questionId 问题id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestCollectQuestionWithQuestionId:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_CollectQuestionProtocol>)notifiedObject;


/**
 请求取消收藏某个问题

 @param questionId 问题id
 @param notifiedObject 请求成功后通知的对象
 */
- (void)didRequestTestUncollectQuestionWithQuestionId:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_UncollectQuestionProtocol>)notifiedObject;


/**
 请求添加做题记录（某个大类 章节信息等

 @param infoDic 添加的信息
 */
- (void)didRequestAddTestHistoryWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_AddHistoryProtocol>)notifiedObject;

/**
 请求添加做题记录 （具体的问题

 @param infoDic 添加的信息
 */
- (void)didRequestAddTestHistoryDetailWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<TestModule_AddHistoryProtocol>)notifiedObject;;

/**
 请求做题记录
 
 @param infoDic 添加的信息
 */
- (void)didRequestTestRecordWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestRecord>)notifiedObject;

- (NSArray *)getTestRecord;
- (NSDictionary *)getTestRecordInfo;


- (void)didRequestTestRecordQoestionWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestRecordQuestion>)notifiedObject;

- (NSDictionary *)getCurrentTestRecorsQuestionInfo;

/**
 请求每日一练
 
 @param infoDic 添加的信息
 */
- (void)didRequestTestDailyPracticeWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestDailyPractice>)notifiedObject;

- (NSArray *)getTestDailyPractice;

- (void)didRequestTestDailyPracticeQoestionWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestDailyPracticeQuestion>)notifiedObject;


- (void)didRequestTestPastExerciseWithInfo:(NSDictionary *)infoDic  andNotifiedObject:(id<TestModule_TestDailyPractice>)notifiedObject;
- (NSArray *)getTestPastExercise;

/**
 重置当前问题的信息
 */
- (void)resetCurrentQuestionInfos;
- (void)resetCurrentQuestionInfoswith:(int)index;

- (void)resetCurrentTestQuestionProcess;// 获取当前章节练习进度
- (void)resetCurrentSimulateQuestionProcess;// 获取当前章节练习进度

- (void)cleanTextProcess;
- (void)cleanSimulateProcess;

/**
 获取当前问题的index

 @return 当前问题的index
 */
- (int)getCurrentQuestionIndex;

/**
 下一个和上一个问题
 */
- (void)nextQuestion;
- (void)previousQuestion;


/**
 收藏和取消收藏某个问题
 */
- (void)collectCurrentQuestion;
- (void)uncollectCurrentQuestion;


/**
 获取答题时的logid

 @return logid
 */
- (int)getLogId;

//章节练习题

/**
 提交某个问题的答案

 @param answerArray 问题答案
 @param questionIndex 问题的index
 */
- (void)submitAnswers:(NSMutableArray *)answerArray andQuestionIndex:(int)questionIndex;



- (void)showQuestionAnswerWithQuestionIndex:(int)questionIndex;

/**
 获取所有问题个数

 @return 问题个数
 */
- (int)getTestSectionTotalCount;

/**
 获取当前问题的全部信息

 @return 问题信息
 */
- (NSDictionary *)getCurrentSectionQuestionInfo;

// 获取已做的章节测试题题信息
- (NSArray *)getCurrentWriteTestQuestions:(BOOL)haveCurrent;

//模拟题
- (void)submitSimulateAnswers:(NSMutableArray *)answerArray andQuestionIndex:(int)questionIndex;
- (void)reSubmitSimulateAnswers:(NSMutableArray *)answerArray andQuestionIndex:(int)questionIndex;

- (int)getTestSimulateTotalCount;
- (int)getTestSimulateWrongTotalCount;
- (NSDictionary *)getCurrentSimulateQuestionInfo;
- (NSDictionary *)getCurrentSimulateWrongQuestionInfo;

// 获取已做的模拟题信息
- (NSArray *)getCurrentwriteSinulateQuestions;


/**
 获取章节练习列表的信息

 @return 章节练习列表信息
 */
- (NSArray *)getChapterInfoArray;
- (NSDictionary *)getChapterInfo;

/**
 获取模拟试题列表信息

 @return 模拟试题列表信息
 */
- (NSArray *)getSimulateInfoArray;


/**
 获取易错题列表信息

 @return 易错题列表信息
 */
- (NSArray *)getErrorInfoArray;


/**
 获取我的错题列表信息

 @return 我的错题列表信息
 */
- (NSArray *)getMyWrongChapterInfoArray;


/**
 获取模拟试题中我已做答的问题的信息(用于做题进度本地存储)

 @return 回答问题的信息
 */
- (NSArray *)getSimulateMyAnswersInfo;

- (NSDictionary *)getSimulateresult;

// 判卷
- (void)didJudgment:(NSDictionary *)questionInfo withNotifiedObject:(id<TestModule_judgmentProtocol>)object;
- (NSDictionary *)getJudhgmentInfo;

@end
