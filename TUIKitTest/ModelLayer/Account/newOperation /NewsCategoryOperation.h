//
//  NewsCategoryOperation.h
//  zhongxin
//
//  Created by aaa on 2020/6/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsCategoryOperation : NSObject

- (void)getNewsCategoryWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsCategory>)object;

@property (nonatomic, strong)NSMutableArray * list;

@end

NS_ASSUME_NONNULL_END
