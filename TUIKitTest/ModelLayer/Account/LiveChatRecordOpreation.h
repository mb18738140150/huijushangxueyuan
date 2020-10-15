//
//  LiveChatRecordOpreation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveChatRecordOpreation : NSObject

@property (nonatomic, strong)NSMutableArray * list;
- (void)didRequestLiveChatRecordWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_LiveChatRecord>)object;


@end

NS_ASSUME_NONNULL_END
