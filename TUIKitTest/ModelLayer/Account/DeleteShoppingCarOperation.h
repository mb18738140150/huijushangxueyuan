//
//  DeleteShoppingCarOperation.h
//  lanhailieren
//
//  Created by aaa on 2020/3/18.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeleteShoppingCarOperation : NSObject
- (void)didRequestDeleteShoppingCarWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_DeleteShoppingCarProtocol>)object;
@end

NS_ASSUME_NONNULL_END
