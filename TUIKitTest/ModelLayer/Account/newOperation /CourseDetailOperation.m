//
//  CourseDetailOperation.m
//  zhongxin
//
//  Created by aaa on 2019/10/12.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "CourseDetailOperation.h"

@interface CourseDetailOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CourseDetailProtocol> notifiedObject;

@property (nonatomic, strong)NSDictionary * requestInfo;

@end

@implementation CourseDetailOperation

- (NSMutableArray *)categoryCourseList
{
    if (!_categoryCourseList) {
        _categoryCourseList = [NSMutableArray array];
    }
    return _categoryCourseList;
}

- (void)didRequestCourseDetailWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CourseDetailProtocol>)object
{
    self.requestInfo = infoDic;
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestCourseDetailWithInfo:infoDic andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSLog(@"successInfo = %@", successInfo);
    
    NSDictionary * courseInfo = [successInfo objectForKey:@"data"];
    self.infoDic = courseInfo;
   
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCourseDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didCourseDetailFailed:failInfo];
    }
}
@end
