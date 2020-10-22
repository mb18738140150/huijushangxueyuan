//
//  CommentZanOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentZanOperation : NSObject

- (void)didRequestCommentZantWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CommentZanProtocol>)object;


@end

NS_ASSUME_NONNULL_END
