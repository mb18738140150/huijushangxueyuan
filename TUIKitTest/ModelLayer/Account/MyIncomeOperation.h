//
//  MyIncomeOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyIncomeOperation : NSObject

@property(nonatomic, strong)NSDictionary * info;

- (void)getIncomeInfoWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_IncomeInfo>)object;


@end

NS_ASSUME_NONNULL_END
