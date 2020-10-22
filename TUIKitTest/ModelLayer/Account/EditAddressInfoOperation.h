//
//  EditAddressInfoOperation.h
//  lanhailieren
//
//  Created by aaa on 2020/3/16.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditAddressInfoOperation : NSObject

- (void)didRequestEditAddressWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_EditAddressProtocol>)object;


@end

NS_ASSUME_NONNULL_END
