//
//  TeacherDetailOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeacherDetailOperation : NSObject

@property(nonatomic, strong)NSDictionary * info;

- (void)getTeacherDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_TeacherDetailProtocol>)object;

@end

NS_ASSUME_NONNULL_END
