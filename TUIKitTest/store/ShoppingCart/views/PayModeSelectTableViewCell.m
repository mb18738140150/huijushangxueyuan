//
//  payModeSelectTableViewCell.m
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "PayModeSelectTableViewCell.h"

@implementation PayModeSelectTableViewCell


- (void)refreshUI
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.frame = self.bounds;
    
    UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 20)];
    tipLB.text = @"请选择支_付方式";
    tipLB.textColor = UIColorFromRGB(0x000000);
    tipLB.font = kMainFont;
    [self.contentView addSubview:tipLB];
    
    self.p_a_yModeSelectView = [[PayModeSelectView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLB.frame) + 10, self.hd_width, 120)];
    [self.contentView addSubview:self.p_a_yModeSelectView];
    __weak typeof(self)weakSelf = self;
    self.p_a_yModeSelectView.p_a_yModeSelectBlock = ^(p_a_yModeType p_a_ymodeType) {
        if (weakSelf.p_a_yModeSelectBlock_cell) {
            weakSelf.p_a_yModeSelectBlock_cell(p_a_ymodeType);
        }
    };
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
