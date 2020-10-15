//
//  ShowQuestionModels.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "ShowQuestionModel.h"

@implementation ShowQuestionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showQuestionModels = [[NSMutableArray alloc] init];
        self.questionArray = [NSMutableArray array];
    }
    return self;
}

- (void)removeAllQuestionModels
{
    [self.showQuestionModels removeAllObjects];
    [self.questionArray removeAllObjects];
}


- (void)addQuestionModel:(QuestionModel *)questionModel
{
    [self.showQuestionModels addObject:questionModel];
}

@end
