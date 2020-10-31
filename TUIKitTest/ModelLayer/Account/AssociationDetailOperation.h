//
//  AssociationDetailOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociationDetailOperation : NSObject

@property(nonatomic, strong)NSDictionary * info;

- (void)getAssociationDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AssociationDetail>)object;


@end

NS_ASSUME_NONNULL_END
