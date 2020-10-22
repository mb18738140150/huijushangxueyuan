//
//  ShoppingCarListOperation.h
//  lanhailieren
//
//  Created by aaa on 2020/3/18.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCarListOperation : NSObject

@property (nonatomic, strong)NSArray * shoppingList;
- (void)didRequestShoppingCarListWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_ShoppingCarListProtocol>)object;

@end

NS_ASSUME_NONNULL_END
