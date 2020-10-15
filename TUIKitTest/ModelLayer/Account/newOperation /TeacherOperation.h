//
//  TeacherOperation.h
//  zhongxin
//
//  Created by aaa on 2020/6/15.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeacherOperation : NSObject
- (void)getCourseTeacherWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseTeacherProtocol>)object;

@property (nonatomic, strong)NSMutableArray * list;
@end

NS_ASSUME_NONNULL_END
