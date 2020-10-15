//
//  TabbarOperation.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabbarOperation : NSObject

@property (nonatomic, strong)NSMutableArray * list;
- (void)didRequestTabbarWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_TabbarList>)object;

@end

NS_ASSUME_NONNULL_END
