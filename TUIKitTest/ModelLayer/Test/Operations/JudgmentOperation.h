//
//  JudgmentOperation.h
//  zhongxin
//
//  Created by aaa on 2020/7/28.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JudgmentOperation : NSObject

@property (nonatomic,weak) id<TestModule_judgmentProtocol>        notifiedObject;

- (void)didJudgment:(NSDictionary *)questionInfo withNotifiedObject:(id<TestModule_judgmentProtocol>)object;
@property (nonatomic, strong)NSDictionary * infoDic;

@end

NS_ASSUME_NONNULL_END
