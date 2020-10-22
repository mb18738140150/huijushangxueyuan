//
//  CommodityInfoTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import "CommodityInfoTableViewCell.h"

@implementation CommodityInfoTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.hd_width - 40, 20)];
    self.titleLB.text = @"招募合伙人";
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    [self.contentView addSubview:self.titleLB];
    
    NSString * str = @"srlijfoiperhiflskmvcopiejr9pisdvclxk cl/,x vl, .c, vl;kxzmvo[idjar0-fuqew0-9fuwq0[e9fjwqpeo,mfa'powekf0[ae4jfpwmc;aslkf[pawif[]pqweklf[\pwe";
    CGFloat height = [str boundingRectWithSize:CGSizeMake(_titleLB.hd_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.height;
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(_titleLB.frame) + 5, _titleLB.hd_width, height)];
    self.contentLB.textColor = UIColorFromRGB(0x999999);
    _contentLB.text = str;
    _contentLB.numberOfLines = 0;
    _contentLB.font = kMainFont_12;
    [self.contentView addSubview:_contentLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_contentLB.frame) + 10, self.hd_width - 40, 20)];
    self.priceLB.text = [NSString stringWithFormat:@"%@%@", [SoftManager shareSoftManager].coinName, @"4999.00"];
    self.priceLB.textColor = UIColorFromRGB(0xCCA95D);
    self.priceLB.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.priceLB];
    
    self.saleCountLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 200, _priceLB.hd_y, 180, 20)];
    self.saleCountLB.text = [NSString stringWithFormat:@"销量：%@",  @"4999"];
    self.saleCountLB.textColor = UIColorFromRGB(0x666666);
    self.saleCountLB.font = kMainFont_12;
    _saleCountLB.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.saleCountLB];
    
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
