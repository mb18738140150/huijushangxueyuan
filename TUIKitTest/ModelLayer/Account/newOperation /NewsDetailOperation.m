//
//  NewsDetailOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "NewsDetailOperation.h"

@interface NewsDetailOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_NewsDetail> notifiedObject;

@end

@implementation NewsDetailOperation

- (void)getNewsDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsDetail>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNewsDetailSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNewsDetailFailed:failInfo];
    }
}
@end
