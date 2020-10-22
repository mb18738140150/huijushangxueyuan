//
//  CommentZanOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import "CommentZanOperation.h"

@interface CommentZanOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_CommentZanProtocol> notifiedObject;
@end

@implementation CommentZanOperation


- (void)didRequestCommentZantWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CommentZanProtocol>)object{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestOrderListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCommentZanSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestCommentZanFailed:failInfo];
    }
}

@end
