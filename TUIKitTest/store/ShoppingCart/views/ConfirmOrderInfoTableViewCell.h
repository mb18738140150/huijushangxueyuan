//
//  ConfirmOrderInfoTableViewCell.h
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderInfoTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel* checkAllBtn;
@property (nonatomic, strong)UILabel * orderBtn;
- (void)refreshUI:(NSDictionary *)info;

- (void)resetContentLbColor:(UIColor *)color;

- (void)refreshContentLB:(NSString *)string;

@end
