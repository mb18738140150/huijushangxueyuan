//
//  TestMyWrongQuestionOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestMyWrongQuestionOperation.h"
#import "HttpRequestManager.h"
#import "TestChapterModel.h"
#import "CommonMacro.h"

@interface TestMyWrongQuestionOperation ()<HttpRequestProtocol>

@end

@implementation TestMyWrongQuestionOperation

- (void)didAddMyWrongQuestionWithQuestionId:(int)questionId
{
    [[HttpRequestManager sharedManager] reqestTestAddMyWrongQuestionWithQuestionId:questionId andProcessDelegate:nil];
}

- (void)didRequesMyWrongChapterWithCategoryId:(int)cateId andNotifiedObject:(id<TestModule_MyWrongQuestionInfoProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestTestMyWrongChapterInfoWithCategoryId:cateId andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    [self.myWrongChapterArray removeAllObjects];
    [self.simulateArray removeAllObjects];
    
    self.simulateArray = [successInfo objectForKey:@"result"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyWrongQuestionSuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    [self.notifiedObject didRequestMyWrongQuestionFailed:failInfo];
}

@end
