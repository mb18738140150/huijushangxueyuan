//
//  payModeSelectView.h
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModeView.h"

@interface PayModeSelectView : UIView

@property (nonatomic, strong)PayModeView * zhi_f_bView;
@property (nonatomic, strong)PayModeView * wechatView;
@property (nonatomic, strong)PayModeView * yueView;

@property (nonatomic, copy)void(^p_a_yModeSelectBlock)(p_a_yModeType p_a_ymodeType);

@end
