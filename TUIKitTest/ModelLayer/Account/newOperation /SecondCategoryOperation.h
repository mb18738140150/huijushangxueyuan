//
//  SecondCategoryOperation.h
//  zhongxin
//
//  Created by aaa on 2019/10/11.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecondCategoryOperation : NSObject

- (void)didRequestSecondCategoryWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SecondCategoryProtocol>)object;
@property (nonatomic, strong)NSMutableArray * secondCategoryList;


@end

NS_ASSUME_NONNULL_END
