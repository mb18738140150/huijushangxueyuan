//
//  CustomChatViewController.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/26.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "CustomTUIChatController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomChatViewController : UIViewController

@property (nonatomic, strong) TUIConversationCellData *conversationData;
@property (nonatomic, copy)NSString * groupId;
@property (nonatomic, copy)NSString * playUrl;
@property (nonatomic, copy)NSString * tencentPlayID;
@property (nonatomic, assign)BOOL isPlayBack;
@property (nonatomic, strong)NSDictionary * videoInfo;
@property (nonatomic, copy)void (^quitChatRoomBlock)();

@end

NS_ASSUME_NONNULL_END
