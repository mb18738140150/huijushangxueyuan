//
//  JoinAssociationOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JoinAssociationOperation : NSObject

@property(nonatomic, strong)NSDictionary * info;

- (void)getJoinAssociationWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_JoinAssociation>)object;

@end

NS_ASSUME_NONNULL_END
