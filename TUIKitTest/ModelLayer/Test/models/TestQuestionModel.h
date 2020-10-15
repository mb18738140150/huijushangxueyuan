//
//  TestQuestionModel.h
//  Accountant
//
//  Created by aaa on 2017/3/17.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TestQuestionTypeSingle = 0,
    TestQuestionTypeMutil,
    TestQuestionTypeJudgement
}TestQuestionType;


/*
 /// <summary>
 /// 单选
 /// </summary>
 [Description("单选题")]
 SingleChoice = 1,
 /// <summary>
 /// 多选
 /// </summary>
 [Description("多选题")]
 MultipleChoice = 2,
 /// <summary>
 /// 判断题
 /// </summary>
 [Description("判断题")]
 TrueOrFalse = 3,
 /// <summary>
 /// 填空题
 /// </summary>
 [Description("填空题")]
 FillBlank = 4,
 /// <summary>
 /// 问答题
 /// </summary>
 [Description("问答题")]
 QuestionAndAnswer = 5,
 /// <summary>
 /// 组合题
 /// </summary>
 [Description("组合题")]
 Combination = 6
 */

@interface TestQuestionModel : NSObject

@property (nonatomic, strong)NSDictionary           *questionInfo;
@property (nonatomic,assign) int                     questionId;
//@property (nonatomic,assign) TestQuestionType        questionType;
@property (nonatomic,strong) NSString               *questionType;
@property (nonatomic, assign)int                    questionTypeId;// 1.单选、2.多选、3.判断、4.填空、5.简答、6.组合题（材料题）
@property (nonatomic,strong) NSString               *questionContent;
@property (nonatomic,strong) NSString               *questionComplain;
@property (nonatomic,strong) NSMutableArray         *answers;// 问题答案选项
@property (nonatomic,strong) NSString               *correctAnswerIds;
@property (nonatomic,strong) NSString               *selectedAnswerIds;// 已选答案
@property (nonatomic, copy) NSString * caseInfo;// 材料题信息
@property (nonatomic, copy) NSString * myAnswer;
@property (nonatomic, assign)int isResponse;
@property (nonatomic, assign)int jd;// 进度
@property (nonatomic, strong)NSString *anwserLogId;// 关联的答题记录id
@property (nonatomic, strong)NSString * examinationId;//  原始考试id 
@property (nonatomic, assign)int xh;// 序号

@property (nonatomic, assign)int lid;//接收时对应 directionId：职称id
@property (nonatomic, assign)int kid;//接收时对应 subjectId：科目id
@property (nonatomic, assign)int cid;//接收时对应 chapterId：章id
@property (nonatomic, assign)int uid;//接收时对应 unitId：节id
@property (nonatomic, assign)int sid;//接收时对应 simulationId：模拟卷id ****** 职称id到模拟卷id几个没有用
@property (nonatomic, assign)int isEasyWrong;

@property (nonatomic, assign)int lastLogId;

@property (nonatomic,assign) BOOL                    questionIsAnswered;// 是否一作答
@property (nonatomic, assign) BOOL                   questionIsShowAnswer;//是否显示答案及解析
@property (nonatomic,assign) BOOL                    questionIsCollected;
@property (nonatomic,assign) BOOL                    isAnsweredCorrect;
@property (nonatomic,strong) NSArray                *selectArray;

@property (nonatomic, assign)int                    questionNumber;

@property (nonatomic,assign) int                     logId;

@end
