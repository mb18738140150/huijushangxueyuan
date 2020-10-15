//
//  CourseDetailOperation.h
//  zhongxin
//
//  Created by aaa on 2019/10/12.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseDetailOperation : NSObject

- (void)didRequestCourseDetailWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CourseDetailProtocol>)object;
@property (nonatomic, strong)NSMutableArray * categoryCourseList;
@property (nonatomic, strong)NSDictionary * infoDic;


@end

NS_ASSUME_NONNULL_END
