//
//  AddCourseStudyRecordOperation.h
//  zhongxin
//
//  Created by aaa on 2020/7/3.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddCourseStudyRecordOperation : NSObject

- (void)getAddCourseStudyRecordListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AddCourseStudyRecord>)object;

@property (nonatomic, strong)NSDictionary * info;

@end

NS_ASSUME_NONNULL_END
