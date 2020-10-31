//
//  DeleteDynamicOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeleteDynamicOperation : NSObject

@property(nonatomic, strong)NSDictionary * info;

- (void)getdeleteDynamicWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_deleteDynamic>)object;


@end

NS_ASSUME_NONNULL_END
