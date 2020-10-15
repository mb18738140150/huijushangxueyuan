//
//  LivingJurisdictionOperation.m
//  Accountant
//
//  Created by aaa on 2019/2/20.
//  Copyright © 2019年 tianming. All rights reserved.
//

#import "LivingJurisdictionOperation.h"
#import "HottestCourseModel.h"
#import "HttpRequestManager.h"

@interface LivingJurisdictionOperation()<HttpRequestProtocol>

@end

@implementation LivingJurisdictionOperation

- (void)didRequestLivingJurisdictionWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<CourseModule_LivingJurisdiction>)delegate
{
    self.notifiedObject = delegate;
    [[HttpRequestManager sharedManager] requestGetLivingJurisdictionWithInfo:infoDic andProcessDelegate:self];
}

#pragma mark - http delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    
    self.infoDic = successInfo;
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestLivingLivingJurisdictionSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    
    if (self.notifiedObject != nil) {
        [self.notifiedObject didRequestLivingLivingJurisdictionFailed:failInfo];
    }
}

@end
