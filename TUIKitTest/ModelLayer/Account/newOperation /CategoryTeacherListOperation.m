//
//  CategoryTeacherListOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/11.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "CategoryTeacherListOperation.h"

@interface CategoryTeacherListOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CategoryTeacherListProtocol> notifiedObject;
@end

@implementation CategoryTeacherListOperation

- (NSMutableArray *)categoryTeacherList
{
    if (!_categoryTeacherList) {
        _categoryTeacherList = [NSMutableArray array];
    }
    return _categoryTeacherList;
}

- (void)didRequestCategoryTeacherListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CategoryTeacherListProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestCategoryTeacherListWithInfo:infoDic andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
//    NSLog(@"yearList = %@", successInfo);
    
    [self.categoryTeacherList removeAllObjects];
    NSArray * list = [successInfo objectForKey:@"data"];
    for (NSDictionary * assistantInfo in list) {
        [self.categoryTeacherList addObject:assistantInfo];
    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCategoryTeacherListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCategoryTeacherListFailed:failInfo];
    }
}
@end
