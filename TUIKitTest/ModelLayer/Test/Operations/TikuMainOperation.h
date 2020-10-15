//
//  TikuMainOperation.h
//  zhongxin
//
//  Created by aaa on 2019/10/27.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TikuMainOperation : NSObject

@property (nonatomic,weak) id<TestModule_TikuMain>        notifiedObject;

- (void)didTikuMain:(NSDictionary *)questionInfo withNotifiedObject:(id<TestModule_TikuMain>)object;
@property (nonatomic, strong)NSDictionary * infoDic;

@end

NS_ASSUME_NONNULL_END
