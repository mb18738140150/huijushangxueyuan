//
//  TestCategoryOperation.h
//  zhongxin
//
//  Created by aaa on 2020/7/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestCategoryOperation : NSObject

- (void)didRequestSecondCategoryWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<TestModule_SecondCategoryProtocol>)object;
@property (nonatomic, strong)NSMutableArray * secondCategoryList;


@end

NS_ASSUME_NONNULL_END
