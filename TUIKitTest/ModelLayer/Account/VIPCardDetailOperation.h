//
//  VIPCardDetailOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VIPCardDetailOperation : NSObject

@property (nonatomic, strong)NSDictionary * vipCardDetailInfo;

- (void)didRequestMyVIPCardDetailWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyVIPCardDetailInfo>)object;


@end

NS_ASSUME_NONNULL_END
