//
//  MyCoinOperation.m
//  Accountant
//
//  Created by aaa on 2018/5/13.
//  Copyright © 2018年 tianming. All rights reserved.
//

#import "MyCoinOperation.h"
#import "HttpRequestManager.h"
#import "HttpRequestProtocol.h"

@interface MyCoinOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_MyCoin> notifiedObject;

@end

@implementation MyCoinOperation

- (void)didRequestMyCoinWithNotifiedObject:(id<UserModule_MyCoin>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestGetMyGoldCoinWithProcessDelegate:self];
}


- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSNumber *count = [[[successInfo objectForKey:@"data"] objectForKey:@"apple_wallet"] objectForKey:@"amount"];
    int a = count.intValue;
    self.bills = [[successInfo objectForKey:@"result"] objectForKey:@"bills"];
    [[UserManager sharedManager] resetGoldCoinCount:a];
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyCoinSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestMyCoinFailed:failInfo];
    }
}

@end
