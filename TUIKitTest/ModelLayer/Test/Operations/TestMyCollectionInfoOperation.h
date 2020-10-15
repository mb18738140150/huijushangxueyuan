//
//  TestMyCollectionInfoOperation.h
//  Accountant
//
//  Created by aaa on 2017/6/24.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestMyCollectionInfoOperation : NSObject

@property (nonatomic,weak) id<TestModule_CollectQuestionInfoProtocol>          collectInfoNotifiedObject;

@property (nonatomic,weak) NSMutableArray                           *collectChapterArray;
@property (nonatomic,weak) NSMutableArray                           *simulateArray;
- (void)didRequestCollectInfoWithCategoryId:(NSDictionary *)cateId andNotifiedObject:(id<TestModule_CollectQuestionInfoProtocol>)object;

@end
