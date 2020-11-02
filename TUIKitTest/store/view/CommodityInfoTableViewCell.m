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
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    [self.contentView addSubview:self.titleLB];
    
    NSString * str = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"desc"]];
    CGFloat height = [str boundingRectWithSize:CGSizeMake(_titleLB.hd_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.height;
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(_titleLB.frame) + 5, _titleLB.hd_width, height)];
    self.contentLB.textColor = UIColorFromRGB(0x999999);
    _contentLB.text = str;
    _contentLB.numberOfLines = 0;
    _contentLB.font = kMainFont_12;
    [self.contentView addSubview:_contentLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_contentLB.frame) + 10, self.hd_width - 40, 20)];
    self.priceLB.textColor = UIColorFromRGB(0xCCA95D);
    self.priceLB.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.priceLB];
    NSString * oldStr = [self getOldStrWithSource1:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"pay_money"]] andSource2:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"offpay_money"]]];
    [self.contentView addSubview:self.priceLB];
    
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    NSMutableAttributedString * NewStr = [[NSMutableAttributedString alloc]initWithString:oldStr];
    [NewStr addAttributes:attribute range:NSMakeRange([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"pay_money"]] length]+ 1, oldStr.length - [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"offpay_money"]] length] - 1)];
    self.priceLB.attributedText = NewStr;
    
    self.saleCountLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 200, _priceLB.hd_y, 180, 20)];
    self.saleCountLB.text = [NSString stringWithFormat:@"销量：%@",  [infoDic objectForKey:@"pay_num"]];
    self.saleCountLB.textColor = UIColorFromRGB(0x666666);
    self.saleCountLB.font = kMainFont_12;
    _saleCountLB.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.saleCountLB];
    
}

- (NSMutableAttributedString *)getAttributeStringWithBegainStr:(NSString *)begainStr andContent:(NSString *)content
{
    NSString * str = [NSString stringWithFormat:@"%@%@", begainStr, content];
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont_12,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)};
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mStr addAttributes:attribute range:NSMakeRange(0, begainStr.length)];
    return mStr;
}
- (NSString *)getOldStrWithSource1:(NSString *)str1 andSource2:(NSString *)str2
{
    if (str2.length == 0) {
        return [NSString stringWithFormat:@"￥%@", str1];
    }else
    {
        return [NSString stringWithFormat:@"￥%@ ￥%@", str1,str2];
    }
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
