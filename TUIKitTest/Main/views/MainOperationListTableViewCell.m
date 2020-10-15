//
//  MainOperationListTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import "MainOperationListTableViewCell.h"

@interface MainOperationListTableViewCell ()

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic,strong)UILabel * titleLB;

@end

@implementation MainOperationListTableViewCell

- (void)refreshUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 20, 20, 20)];
    self.iconImageView.image = [UIImage imageNamed:[info objectForKey:@"image"]];
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_centerY - 10, 200, 20)];
    self.titleLB.text = [info objectForKey:@"title"];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    [self.contentView addSubview:self.titleLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(12, 59, kScreenWidth - 24, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:separateView];
    
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
