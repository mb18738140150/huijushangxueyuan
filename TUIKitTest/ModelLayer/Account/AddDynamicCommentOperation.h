//
//  AddDynamicCommentOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddDynamicCommentOperation : NSObject

- (void)getAddDynamicCommentWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AddDynamicComment>)object;

@end

NS_ASSUME_NONNULL_END
