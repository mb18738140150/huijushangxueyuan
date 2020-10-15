//
//  bottomAlertView.h
//  LzhAlertView
//
//  Created by 刘中华 on 2019/12/11.
//  Copyright © 2019 LZH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface bottomAlertView : UIView

@property (nonatomic, copy)void (^shareBolck)(NSDictionary * info_Type);

@end

NS_ASSUME_NONNULL_END
