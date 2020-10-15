//
//  QuestionCollectOperation.h
//  zhongxin
//
//  Created by aaa on 2019/10/24.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModuleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionCollectOperation : NSObject

@property (nonatomic,weak) id<QuestionModule_CollectQuestion>        notifiedObject;

- (void)didCollectQuestion:(NSDictionary *)questionInfo withNotifiedObject:(id<QuestionModule_CollectQuestion>)object;


@end

NS_ASSUME_NONNULL_END
