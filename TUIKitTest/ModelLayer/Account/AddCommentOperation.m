//
//  AddCommentOperation.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import "AddCommentOperation.h"

@interface AddCommentOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_AddCommentProtocol> notifiedObject;
@end

@implementation AddCommentOperation


- (void)didRequestAddCommentWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_AddCommentProtocol>)object{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestOrderListWithInfoDic:infoDic andProcessDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddCommentSuccessed];
    }
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didRequestAddCommentFailed:failInfo];
    }
}
@end
