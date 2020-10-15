//
//  QuestionReplayOperation.h
//  zhongxin
//
//  Created by aaa on 2019/10/25.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionReplayOperation : NSObject

@property (nonatomic,weak) id<QuestionModule_ReplayQuestion>        notifiedObject;

- (void)didReplayQuestion:(NSDictionary *)questionInfo withNotifiedObject:(id<QuestionModule_ReplayQuestion>)object;


@end

NS_ASSUME_NONNULL_END
