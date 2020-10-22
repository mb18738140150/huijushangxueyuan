//
//  AddressListOperation.h
//  lanhailieren
//
//  Created by aaa on 2020/3/16.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressListOperation : NSObject

- (void)didRequestAddressListWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AddressListProtocol>)object;
@property (nonatomic, strong)NSArray * addressList;

@end

NS_ASSUME_NONNULL_END
