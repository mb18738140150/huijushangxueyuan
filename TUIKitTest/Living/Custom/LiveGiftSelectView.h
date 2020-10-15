//
//  LiveGiftSelectView.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveGiftSelectView : UIView

@property (nonatomic, copy)void (^payBlock)(NSDictionary * info);

- (void)showInView:(UIView *)view;

- (void)resetWithInfoArray:(NSArray *)giftArray;

@end

NS_ASSUME_NONNULL_END
