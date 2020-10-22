//
//  DeleteShoppingCarOperation.m
//  lanhailieren
//
//  Created by aaa on 2020/3/18.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "DeleteShoppingCarOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface DeleteShoppingCarOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_DeleteShoppingCarProtocol> notifiedObject;
@end

@implementation DeleteShoppingCarOperation
- (void)didRequestDeleteShoppingCarWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_DeleteShoppingCarProtocol>)object
{
    
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDeleteShoppingCarSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestDeleteShoppingCarFailed:failInfo];
    }
}
@end
