//
//  ShutupOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShutupOperation : NSObject

- (void)didRequestShutupWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_Shutup>)object;

@end

NS_ASSUME_NONNULL_END
