//
//  CourseStudyRecord.h
//  zhongxin
//
//  Created by aaa on 2020/6/29.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseStudyRecord : NSObject

- (void)getCourseStudyRecordListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseStudyRecord>)object;

@property (nonatomic, strong)NSMutableArray * list;

@end

NS_ASSUME_NONNULL_END
