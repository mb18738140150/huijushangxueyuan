//
//  MockPartnerBuyOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MockPartnerBuyOperation : NSObject

@property (nonatomic, strong)NSDictionary * partnerBuyInfo;

- (void)didRequestMockPartnerBuyWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MockPartnerBuy>)object;

@end

NS_ASSUME_NONNULL_END
