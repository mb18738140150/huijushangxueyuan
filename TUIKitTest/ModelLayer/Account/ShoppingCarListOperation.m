//
//  ShoppingCarListOperation.m
//  lanhailieren
//
//  Created by aaa on 2020/3/18.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ShoppingCarListOperation.h"

#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"
@interface ShoppingCarListOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_ShoppingCarListProtocol> notifiedObject;
@end

@implementation ShoppingCarListOperation

- (void)didRequestShoppingCarListWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_ShoppingCarListProtocol>)object
{
    
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGiftListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    self.shoppingList = [successInfo objectForKey:@"data"];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestShoppingCarListSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestShoppingCarListFailed:failInfo];
    }
}

@end
