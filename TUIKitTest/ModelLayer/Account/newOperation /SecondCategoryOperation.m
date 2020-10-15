//
//  SecondCategoryOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/11.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "SecondCategoryOperation.h"
#define kDeep 1
@interface SecondCategoryOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_SecondCategoryProtocol> notifiedObject;
@end

@implementation SecondCategoryOperation

- (NSMutableArray *)secondCategoryList
{
    if (!_secondCategoryList) {
        _secondCategoryList = [NSMutableArray array];
    }
    return _secondCategoryList;
}

- (void)didRequestSecondCategoryWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SecondCategoryProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestSecondCategoryWithInfo:infoDic andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
//    NSLog(@"yearList = %@", successInfo);
    
    NSMutableArray * titleArray = [NSMutableArray array];
    NSDictionary * info = @{@"id":@0,@"name":@"全部"};
    [titleArray addObject:info];
    
    for (NSDictionary * info in [successInfo objectForKey:@"data"]) {
        [titleArray addObject:info];
    }
    
    self.secondCategoryList = titleArray;
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didSecondCategorySuccessed];
    }
}


- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didSecondCategoryFailed:failInfo];
    }
}
@end
