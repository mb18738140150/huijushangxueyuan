//
//  MyCourseOperation.h
//  zhongxin
//
//  Created by aaa on 2019/10/29.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCourseOperation : NSObject

- (void)didRequestGetMyCourseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyCourse>)object;

@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, strong)NSArray * list;

@end

NS_ASSUME_NONNULL_END
