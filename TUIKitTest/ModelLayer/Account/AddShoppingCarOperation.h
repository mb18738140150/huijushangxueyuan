//
//  AddShoppingCarOperation.h
//  lanhailieren
//
//  Created by aaa on 2020/3/18.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddShoppingCarOperation : NSObject

- (void)didRequestAddShoppingCarWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_AddShoppingCarProtocol>)object;


@end

NS_ASSUME_NONNULL_END
