//
//  TestAllCategoryOperation.m
//  Accountant
//
//  Created by aaa on 2017/3/18.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "TestAllCategoryOperation.h"
#import "HttpRequestManager.h"

@interface TestAllCategoryOperation ()<HttpRequestProtocol>

@property (nonatomic,weak) id<TestModule_AllCategoryProtocol>            notifiedObject;
@property (nonatomic, assign)BOOL isHaveNoUserID;

@end

@implementation TestAllCategoryOperation

- (NSMutableArray *)allCategoryArray
{
    if (!_allCategoryArray) {
        _allCategoryArray = [NSMutableArray array];
    }
    return _allCategoryArray;
}

- (NSMutableArray *)notLoginAllCategory
{
    if (!_notLoginAllCategory) {
        _notLoginAllCategory = [NSMutableArray array];
    }
    return _notLoginAllCategory;
}

//- (void)didRequestTestAllCategoryWithNotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject
//{
//    self.notifiedObject = notifiedObject;
//    [[HttpRequestManager sharedManager] requestTestAllCategoryWithUserId:(int )userID ProcessDelegate:self];
//}

- (void)didRequestTestAllCategoryWithUserId:(int )userID NotifiedObject:(id<TestModule_AllCategoryProtocol>)notifiedObject
{
    self.notifiedObject = notifiedObject;
    self.isHaveNoUserID = YES;
    [[HttpRequestManager sharedManager] requestTestAllCategoryWithUserId:userID ProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (self.isHaveNoUserID) {
        self.notLoginAllCategory = [[successInfo objectForKey:@"data"] objectForKey:@"dataList"];
        self.isHaveNoUserID = NO;
    }else
    {
        self.allCategoryArray = [[successInfo objectForKey:@"data"] objectForKey:@"dataList"];
    }
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAllTestCategorySuccess];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAllTestCategoryFailed:failInfo];
    }
}

- (void)didRequestFailedWithInfo:(NSDictionary *)failedInfo
{
    self.allCategoryArray = [failedInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAllTestCategorySuccess];
    }
}

@end
