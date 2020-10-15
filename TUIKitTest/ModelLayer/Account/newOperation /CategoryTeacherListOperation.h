//
//  CategoryTeacherListOperation.h
//  zhongxin
//
//  Created by aaa on 2019/10/11.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryTeacherListOperation : NSObject

- (void)didRequestCategoryTeacherListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CategoryTeacherListProtocol>)object;
@property (nonatomic, strong)NSMutableArray * categoryTeacherList;


@end

NS_ASSUME_NONNULL_END
