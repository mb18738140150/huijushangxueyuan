//
//  TestAllCategoryOperation.h
//  Accountant
//
//  Created by aaa on 2017/3/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModuleProtocol.h"

@interface TestAllCategoryOperation : NSObject

@property (nonatomic,weak) NSMutableArray       *allCategoryArray;

@property (nonatomic, strong)NSMutableArray       *notLoginAllCategory;

//- (void)didRequestTestAllCategoryWithNotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject;

- (void)didRequestTestAllCategoryWithUserId:(int )userID NotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject;

@end
