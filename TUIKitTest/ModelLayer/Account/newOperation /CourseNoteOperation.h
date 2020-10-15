//
//  CourseNoteOperation.h
//  zhongxin
//
//  Created by aaa on 2020/6/15.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseNoteOperation : NSObject

- (void)getCourseNoteWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseNoteProtocol>)object;

@property (nonatomic, strong)NSMutableArray * courseNoteList;

@end

NS_ASSUME_NONNULL_END
