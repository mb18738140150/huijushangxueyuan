//
//  NewsCategoryOperation.m
//  zhongxin
//
//  Created by aaa on 2020/6/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "NewsCategoryOperation.h"

@interface NewsCategoryOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_NewsCategory> notifiedObject;

@end

@implementation NewsCategoryOperation

- (NSMutableArray *)courseNoteList
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)getNewsCategoryWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsCategory>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] reqeustGetMyCourseWithDic:info andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.list = [successInfo objectForKey:@"result"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNewsCategorySuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestNewsCategoryFailed:failInfo];
    }
}
@end
