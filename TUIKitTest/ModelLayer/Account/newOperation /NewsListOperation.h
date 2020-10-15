//
//  NewsListOperation.h
//  zhongxin
//
//  Created by aaa on 2020/6/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsListOperation : NSObject

- (void)getNewsListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsList>)object;

@property (nonatomic, strong)NSMutableArray * list;
@property (nonatomic, strong)NSDictionary * info;

@end

NS_ASSUME_NONNULL_END
