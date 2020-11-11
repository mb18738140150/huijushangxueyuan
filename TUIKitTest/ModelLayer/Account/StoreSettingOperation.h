//
//  StoreSettingOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreSettingOperation : NSObject

@property (nonatomic, strong)NSDictionary * info;
- (void)didRequestStoreSettingWithWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_StoreSetting>)object;

@end

NS_ASSUME_NONNULL_END
