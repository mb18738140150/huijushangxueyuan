//
//  ShareClickView.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareClickView : UIView

@property (nonatomic, copy)void (^shareBlock)(NSDictionary *info);

@end

NS_ASSUME_NONNULL_END
