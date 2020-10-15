//
//  NewsListOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "NewsListOperation.h"

@interface NewsListOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_NewsList> notifiedObject;

@end

@implementation NewsListOperation

- (NSMutableArray *)courseNoteList
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)getNewsListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsList>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.info = successInfo;
    self.list = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNewsListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNewsListFailed:failInfo];
    }
}
@end
