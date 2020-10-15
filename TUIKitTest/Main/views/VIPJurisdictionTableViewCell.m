//
//  VIPJurisdictionTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import "VIPJurisdictionTableViewCell.h"

@implementation VIPJurisdictionTableViewCell

-(void)resetUIWithInfo:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * vipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, self.contentView.hd_width - 30, self.hd_height - 10)];
    vipImageView.image = [UIImage imageNamed:[info objectForKey:@"image"]];
    [self.contentView addSubview:vipImageView];
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
