//
//  MockVIPBuyOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MockVIPBuyOperation : NSObject

@property (nonatomic, strong)NSDictionary * vipBuyInfo;

- (void)didRequestMockVIPBuyWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MockVIPBuy>)object;


@end

NS_ASSUME_NONNULL_END
