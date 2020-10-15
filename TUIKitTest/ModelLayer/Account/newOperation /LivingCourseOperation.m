//
//  LivingCourseOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/2.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "LivingCourseOperation.h"

@interface LivingCourseOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_LivingCourseProtocol> notifiedObject;

@property (nonatomic, strong)NSDictionary * requestInfo;

@end

@implementation LivingCourseOperation

- (NSMutableArray *)livingCourseList
{
    if (!_livingCourseList) {
        _livingCourseList = [NSMutableArray array];
    }
    return _livingCourseList;
}

- (void)didRequestLivingCourseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LivingCourseProtocol>)object
{
    self.requestInfo = infoDic;
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestCategoryCourseWithInfo:infoDic andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
//    NSLog(@"yearList = %@", successInfo);
    
    if ([[self.requestInfo objectForKey:kPageNo] intValue] == 1) {
        [self.livingCourseList removeAllObjects];
    }
    self.livinghCourseCountInfo = [successInfo objectForKey:@"page"];
    NSArray * courseArray = [successInfo objectForKey:@"result"];
    for (NSDictionary * assistantInfo in courseArray) {
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:assistantInfo];
        [self.livingCourseList addObject:mInfo];
    };
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didLivingCourseSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didLivingCourseFailed:failInfo];
    }
}
@end
