//
//  CleanShoppingCarOperation.m
//  lanhailieren
//
//  Created by aaa on 2020/3/18.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "CleanShoppingCarOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface CleanShoppingCarOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CleanShoppingCarProtocol> notifiedObject;
@end

@implementation CleanShoppingCarOperation


- (void)didRequestCleanShoppingCarWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CleanShoppingCarProtocol>)object
{
    
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCleanShoppingCarSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCleanShoppingCarFailed:failInfo];
    }
}

@end
