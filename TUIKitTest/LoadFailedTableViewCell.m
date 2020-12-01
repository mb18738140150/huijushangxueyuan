//
//  LoadFailedTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/30.
//

#import "LoadFailedTableViewCell.h"

@implementation LoadFailedTableViewCell

- (void)refreshUIWith:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.84)];
    imageView.image = [UIImage imageNamed:@"位图"];
    [self.contentView addSubview:imageView];
    
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
