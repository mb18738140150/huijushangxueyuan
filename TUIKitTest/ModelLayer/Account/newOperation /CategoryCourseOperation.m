//
//  CategoryCourseOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/12.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "CategoryCourseOperation.h"

@interface CategoryCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CategoryCourseProtocol> notifiedObject;

@property (nonatomic, strong)NSDictionary * requestInfo;

@end

@implementation CategoryCourseOperation

- (NSMutableArray *)categoryCourseList
{
    if (!_categoryCourseList) {
        _categoryCourseList = [NSMutableArray array];
    }
    return _categoryCourseList;
}

- (void)didRequestCategoryCourseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CategoryCourseProtocol>)object
{
    self.requestInfo = infoDic;
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestCategoryCourseWithInfo:infoDic andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
//    NSLog(@"yearList = %@", successInfo);
    
    self.categoryCourseList = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCategoryCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCategoryCourseFailed:failInfo];
    }
}
@end
