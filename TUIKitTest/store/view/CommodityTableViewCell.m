//
//  CommodityTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/2.
//

#import "CommodityTableViewCell.h"

@implementation CommodityTableViewCell
- (void)refreshUIWith:(NSDictionary *)infoDic andItem:(int)item
{
    [self.contentView removeAllSubviews];
    self.infoDic = infoDic;
    
    // (self.hd_width - 22.5) / 2 + 86.5
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, (self.hd_width - 22.5) / 2 + 86.5)];
    
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    
    CGFloat leftWidth = 0;
    CGFloat topSpace = 0;
    if (self.isOneCourse) {
        topSpace = 20;
    }
    
    UIView * boardView = [[UIView alloc]init];
    // 直播大图
    if (item % 2 != 0) {
        leftWidth = 5;
        self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(5, topSpace, self.hd_width - 22.5, (self.hd_width - 22.5)  )];
        boardView.frame = CGRectMake(5, topSpace, self.hd_width - 22.5, (self.hd_width - 22.5) + 60 );
    }else
    {
        leftWidth = 17.5;
        self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, topSpace, self.hd_width - 22.5, (self.hd_width - 22.5) )];
        boardView.frame = CGRectMake(17.5, topSpace, self.hd_width - 22.5, (self.hd_width - 22.5) + 60);
    }
    boardView.layer.cornerRadius = 5;
    boardView.layer.masksToBounds = YES;
    boardView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    boardView.layer.borderWidth = 1;
    [self.backView addSubview:boardView];
    
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    [self.backView addSubview:self.iconImageVIew];
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.iconImageVIew.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = self.iconImageVIew.bounds;
    shapLayer.path = bezierpath.CGPath;
    [self.iconImageVIew.layer setMask: shapLayer];
    
    CGFloat seperateWidth = 10;
    
    // title
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageVIew.hd_x , CGRectGetMaxY(self.iconImageVIew.frame) + seperateWidth, self.backView.hd_width - 22.5, 15)];
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = kMainFont;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    [self.backView addSubview:self.titleLB];
    
    
    // price
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.titleLB.frame) + seperateWidth, 120, 15)];
    self.priceLB.font = kMainFont_12;
    self.priceLB.textColor = UIColorFromRGB(0xCCA95D);
    NSString * oldStr = [self getOldStrWithSource1:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] andSource2:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"off_paymoney"]]];
    [self.backView addSubview:self.priceLB];
    
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    NSMutableAttributedString * NewStr = [[NSMutableAttributedString alloc]initWithString:oldStr];
    [NewStr addAttributes:attribute range:NSMakeRange([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] length]+ 1, oldStr.length - [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] length] - 1)];
    self.priceLB.attributedText = NewStr;
    
}


- (NSMutableAttributedString *)getAttributeStringWithBegainStr:(NSString *)begainStr andContent:(NSString *)content
{
    NSString * str = [NSString stringWithFormat:@"%@%@", begainStr, content];
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont_12,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)};
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mStr addAttributes:attribute range:NSMakeRange(0, begainStr.length)];
    return mStr;
}

- (void)applyAction
{
    if (self.applyBlock) {
        self.applyBlock(self.infoDic);
    }
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
