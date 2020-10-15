//
//  LivingBuyVIPView.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivingBuyVIPView : UIView

@property (nonatomic, copy)void (^VIPPayBlock)(NSDictionary * info);// vip或者合伙人购买 ，学员操作

@property (nonatomic, copy)void (^ShutupBlock)(BOOL isOn);

@property (nonatomic, copy)void (^buyVIPOperationBlock)(NSDictionary *info); // 模拟VIP购买 ，老师操作
@property (nonatomic, copy)void (^buyHeHuoRenOperationBlock)(NSDictionary *info);// 模拟合伙人购买 ，老师操作


- (instancetype)initWithFrame:(CGRect)frame;

- (void)showInView:(UIView *)view andIsVIP:(BOOL)isVIP;

- (void)showShutUpViewInView:(UIView *)view andIsSHutup:(BOOL)isShutup;

- (void)showBuyVIPViewInView:(UIView *)view;
- (void)showBuyHeHuoRenViewInView:(UIView *)view;

- (void)resetShutupWithNojuristic;


@end

NS_ASSUME_NONNULL_END
