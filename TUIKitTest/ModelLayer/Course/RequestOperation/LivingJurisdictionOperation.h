//
//  LivingJurisdictionOperation.h
//  Accountant
//
//  Created by aaa on 2019/2/20.
//  Copyright © 2019年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModuleProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface LivingJurisdictionOperation : NSObject

@property (nonatomic,weak) id<CourseModule_LivingJurisdiction>              notifiedObject;

@property (nonatomic, strong)NSDictionary * infoDic;
- (void)didRequestLivingJurisdictionWithInfo:(NSDictionary *)infoDic andNotifiedObject:(id<CourseModule_LivingJurisdiction>)object;

@end

NS_ASSUME_NONNULL_END
