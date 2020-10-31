//
//  AssociationDynamicOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociationDynamicOperation : NSObject

@property(nonatomic, strong)NSArray * list;

- (void)getAssociationDynamicWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AssociationDynamic>)object;


@end

NS_ASSUME_NONNULL_END
