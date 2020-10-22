//
//  payModeSelectTableViewCell.h
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModeSelectView.h"
@interface PayModeSelectTableViewCell : UITableViewCell

@property (nonatomic, copy)void(^p_a_yModeSelectBlock_cell)(p_a_yModeType p_a_ymodeType);

@property (nonatomic, strong)PayModeSelectView * p_a_yModeSelectView;
- (void)refreshUI;


@end
