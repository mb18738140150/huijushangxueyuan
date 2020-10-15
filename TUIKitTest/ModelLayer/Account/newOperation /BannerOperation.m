//
//  BannerOperation.m
//  zhongxin
//
//  Created by aaa on 2019/9/23.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "BannerOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface BannerOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_BannerList> notifiedObject;
@end
@implementation BannerOperation

- (NSMutableArray *)bannerList
{
    if (!_bannerList) {
        _bannerList = [NSMutableArray array];
    }
    return _bannerList;
}

- (NSMutableArray *)RecommendList
{
    if (!_RecommendList) {
        _RecommendList = [NSMutableArray array];
    }
    return _RecommendList;
}
- (NSMutableArray *)freeList
{
    if (!_freeList) {
        _freeList = [NSMutableArray array];
    }
    return _freeList;
}
- (NSMutableArray *)answerList
{
    if (!_answerList) {
        _answerList = [NSMutableArray array];
    }
    return _answerList;
}


- (void)didRequestBannerListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_BannerList>)object;
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestBannerWithInfo:infoDic andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
//    NSLog(@"yearList = %@", successInfo);
    
//    [self.bannerList removeAllObjects];
//    [self.answerList removeAllObjects];
//    [self.freeList removeAllObjects];
//    [self.RecommendList removeAllObjects];
    
    self.bannerList = [successInfo objectForKey:@"result"];
    
//    NSArray * answerArray = [data objectForKey:@"AnswerData"];
//    NSArray * freeArray = [data objectForKey:@"FreeData"];
//    NSArray * RecommendData = [data objectForKey:@"RecommendData"];
//    self.TKdata = [data objectForKey:@"TKData"];
//
//    for (NSDictionary * assistantInfo in answerArray) {
//        [self.answerList addObject:assistantInfo];
//    }
//
//    for (NSDictionary * assistantInfo in freeArray) {
//        [self.freeList addObject:assistantInfo];
//    }
//    for (NSDictionary * assistantInfo in RecommendData) {
//        [self.RecommendList addObject:assistantInfo];
//    }
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didBannerListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didBannerListFailed:failInfo];
    }
}

@end
