//
//  JingpinDynamicOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JingpinDynamicOperation : NSObject

@property(nonatomic, strong)NSDictionary * info;

- (void)getjingpinDynamicWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_jingpinDynamic>)object;


@end

NS_ASSUME_NONNULL_END
