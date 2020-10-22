//
//  ConfirmOrderInfoTableViewCell.m
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ConfirmOrderInfoTableViewCell.h"

@implementation ConfirmOrderInfoTableViewCell

- (void)refreshUI:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.frame = self.bounds;
    
    UILabel * orderBtn = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    orderBtn.text =[info objectForKey:@"title"];
    orderBtn.textColor =UIColorFromRGB(0x000000);
    orderBtn.font = kMainFont;
    [self.contentView addSubview:orderBtn];
    self.orderBtn = orderBtn;
    
    UILabel* checkAllBtn = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 230, orderBtn.hd_y, 200, 20)];
    
    checkAllBtn.font = kMainFont;
    checkAllBtn.textAlignment = NSTextAlignmentRight;
    checkAllBtn.textColor = kCommonMainBlueColor;
    checkAllBtn.text =[info objectForKey:@"content"];
    [self.contentView addSubview:checkAllBtn];
    
    self.checkAllBtn = checkAllBtn;
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, self.contentView.hd_height - 1, self.hd_width - 30, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xececec);
    [self.contentView addSubview:seperateView];
}

- (void)refreshContentLB:(NSString *)string
{
    self.checkAllBtn.text = string;
}

- (void)resetContentLbColor:(UIColor *)color
{
    self.checkAllBtn.textColor = color;
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
