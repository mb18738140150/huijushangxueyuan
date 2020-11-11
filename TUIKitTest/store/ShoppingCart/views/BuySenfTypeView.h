//
//  BuySenfTypeView.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuySenfTypeView : UIView

@property (nonatomic, assign)int index;
@property (nonatomic, copy)void(^btnSelectBlock)(NSInteger index);
- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array andMainColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
