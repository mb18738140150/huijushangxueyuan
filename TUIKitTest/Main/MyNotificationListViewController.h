//
//  MyNotificationListViewController.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/16.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyNotificationListViewController : ViewController

@property (nonatomic, copy)void(^refreshNewsNumBlock)(NSDictionary *info);

@end

NS_ASSUME_NONNULL_END
