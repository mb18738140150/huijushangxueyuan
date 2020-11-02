//
//  LearningCourseOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/20.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LearningCourseOperation.h"
#import "HttpRequestManager.h"
#import "CourseraManager.h"
#import "CourseModel.h"
#import "CommonMacro.h"

@interface LearningCourseOperation ()<HttpRequestProtocol>

@property (nonatomic, strong)NSDictionary *infoDic;

@end

@implementation LearningCourseOperation

- (NSMutableArray *)learningCourseArray
{
    if (!_learningCourseArray) {
        _learningCourseArray = [NSMutableArray array];
    }
    return _learningCourseArray;
}

- (NSMutableArray *)completeCourseArray
{
    if (!_completeCourseArray) {
        _completeCourseArray = [NSMutableArray array];
    }
    return _completeCourseArray;
}

- (void)didRequestLearningCourseWith:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_LearningCourseProtocol>)object
{
    self.infoDic = infoDic;
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestLearingCourseWithInfoDic:infoDic ProcessDelegate:self];
}

- (void)didRequestCompleteCourseWith:(NSDictionary *)infoDic NotifiedObject:(id<CourseModule_CompleteCourseProtocol>)object
{
    self.infoDic = infoDic;
    self.complateNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestLearingCourseWithInfoDic:infoDic ProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.learningCourseArray = [[successInfo objectForKey:@"data"] mutableCopy];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestLearningCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestLearningCourseFailed:failInfo];
    }
}

@end
