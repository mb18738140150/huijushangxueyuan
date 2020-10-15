//
//  TestCategoryOperation.m
//  zhongxin
//
//  Created by aaa on 2020/7/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "TestCategoryOperation.h"

#define kDeep 1
@interface TestCategoryOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<TestModule_SecondCategoryProtocol> notifiedObject;
@end

@implementation TestCategoryOperation

- (NSMutableArray *)secondCategoryList
{
    if (!_secondCategoryList) {
        _secondCategoryList = [NSMutableArray array];
    }
    return _secondCategoryList;
}

- (void)didRequestSecondCategoryWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<TestModule_SecondCategoryProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestSecondCategoryWithInfo:infoDic andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
//    NSLog(@"yearList = %@", successInfo);
    
    [self.secondCategoryList removeAllObjects];
    NSArray * list = [successInfo objectForKey:@"result"];
    for (NSDictionary * assistantInfo in list) {
        [self getDeepIndex:assistantInfo];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didTestSecondCategorySuccessed];
    }
}

- (void)getDeepIndex:(NSDictionary *)info
{
    if ([[info objectForKey:@"deep"] intValue] == kDeep) {
        [self.secondCategoryList addObject:info];
    }else if ([[info objectForKey:@"deep"] intValue] < kDeep)
    {
        NSArray * children = [info objectForKey:@"children"];
        for (NSDictionary * childInfo in children) {
            [self getDeepIndex:childInfo];
        }
    }else
    {
        return;
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didTestSecondCategoryFailed:failInfo];
    }
}
@end
