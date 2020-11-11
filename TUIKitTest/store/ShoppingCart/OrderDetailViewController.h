//
//  OrderDetailViewController.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface OrderDetailViewController : ViewController
@property (nonatomic, strong)NSDictionary * info;
@property (nonatomic, copy)void(^backBlock)(BOOL isRefresh);

@end

NS_ASSUME_NONNULL_END
