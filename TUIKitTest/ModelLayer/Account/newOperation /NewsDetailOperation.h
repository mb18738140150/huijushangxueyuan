//
//  NewsDetailOperation.h
//  zhongxin
//
//  Created by aaa on 2020/6/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailOperation : NSObject

- (void)getNewsDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsDetail>)object;
@property (nonatomic, strong)NSDictionary * info;

@end

NS_ASSUME_NONNULL_END
