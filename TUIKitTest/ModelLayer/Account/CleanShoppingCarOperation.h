//
//  CleanShoppingCarOperation.h
//  lanhailieren
//
//  Created by aaa on 2020/3/18.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CleanShoppingCarOperation : NSObject

- (void)didRequestCleanShoppingCarWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CleanShoppingCarProtocol>)object;

@end

NS_ASSUME_NONNULL_END
