//
//  AssociationListOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociationListOperation : NSObject

@property (nonatomic, strong)NSArray * list;
- (void)getAssociationListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AssociationList>)object;


@end

NS_ASSUME_NONNULL_END
