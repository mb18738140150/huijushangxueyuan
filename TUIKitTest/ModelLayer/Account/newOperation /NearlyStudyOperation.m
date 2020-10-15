//
//  NearlyStudyOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/19.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "NearlyStudyOperation.h"

@interface NearlyStudyOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_NearlyStudy> notifiedObject;

@end

@implementation NearlyStudyOperation

- (NSMutableArray *)courseNoteList
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)getMyNearlyStudyCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NearlyStudy>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = successInfo;
    self.list = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNearlyStudySuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNearlyStudyFailed:failInfo];
    }
}
@end
