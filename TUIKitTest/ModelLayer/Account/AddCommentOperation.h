//
//  AddCommentOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddCommentOperation : NSObject

- (void)didRequestAddCommentWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_AddCommentProtocol>)object;


@end

NS_ASSUME_NONNULL_END
