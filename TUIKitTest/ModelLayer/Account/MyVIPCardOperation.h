//
//  MyVIPCardOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyVIPCardOperation : NSObject

@property (nonatomic, strong)NSDictionary * vipCardInfo;

- (void)didRequestMyVIPCardWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyVIPCardInfo>)object;


@end

NS_ASSUME_NONNULL_END
