//
//  ChooseCountryPhoneNum.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseCountryPhoneNum : UIView

@property (nonatomic, copy)void (^chooseCountryBlock)(NSDictionary * info);

@end

NS_ASSUME_NONNULL_END
