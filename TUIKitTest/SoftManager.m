//
//  SoftManager.m
//  qianshutang
//
//  Created by aaa on 2018/8/4.
//  Copyright © 2018年 mcb. All rights reserved.
//

#import "SoftManager.h"

@implementation SoftManager

+ (instancetype)shareSoftManager
{
    static SoftManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SoftManager alloc]init];
        if ([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue]) {
            manager.coinName = @"￥";
        }else
        {
            manager.coinName = @"金币";
        }
    });
    
    return manager;
}

- (float)getAllPrice:(NSArray *)selectArray
{
    if (selectArray.count == 0) {
        return 0.00;
    }else
    {
        float allPrice = 0.00;
        for (NSDictionary * infoDic in selectArray) {
            float price = [[infoDic objectForKey:@"price"] doubleValue];
            int count = [[infoDic objectForKey:@"count"] intValue];
            allPrice += price * count;
        }
        return allPrice;
    }
    
}

- (int)getAllPoint:(NSArray *)selectArray
{
    if (selectArray.count == 0) {
        return 0;
    }else
    {
        float allpoint = 0;
        for (NSDictionary * infoDic in selectArray) {
            int  point = [[infoDic objectForKey:@"point"] doubleValue];
            int count = [[infoDic objectForKey:@"count"] intValue];
            allpoint += point * count;
        }
        return allpoint;
    }
    
}

@end
