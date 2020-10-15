//
//  SendMessageOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendMessageOperation : NSObject

@property (nonatomic, strong)NSDictionary * info;
- (void)didRequestSendMessageWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_SendMessage>)object;


@end

NS_ASSUME_NONNULL_END
