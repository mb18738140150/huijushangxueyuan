//
//  AddShoppingCarOperation.m
//  lanhailieren
//
//  Created by aaa on 2020/3/18.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "AddShoppingCarOperation.h"


#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface AddShoppingCarOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AddShoppingCarProtocol> notifiedObject;
@end

@implementation AddShoppingCarOperation

- (void)didRequestAddShoppingCarWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_AddShoppingCarProtocol>)object
{
    
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddShoppingCarSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddShoppingCarFailed:failInfo];
    }
}

@end
