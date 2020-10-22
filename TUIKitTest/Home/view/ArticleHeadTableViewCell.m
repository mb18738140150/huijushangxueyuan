//
//  ArticleHeadTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/20.
//

#import "ArticleHeadTableViewCell.h"

@implementation ArticleHeadTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    if (infoDic == nil) {
        return;
    }
    
    NSString * titleStr = [infoDic objectForKey:@"title"];
    CGFloat titleHeight = [titleStr boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_16} context:nil].size.height;
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, titleHeight + 5)];
    _titleLB.font = kMainFont_16;
    _titleLB.text = titleStr;
    _titleLB.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:_titleLB];
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(_titleLB.hd_x, CGRectGetMaxY(_titleLB.frame) + 10, 200, 15)];
    self.timeLB.font = kMainFont_12;
    self.timeLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"time"]];
    self.timeLB.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.timeLB];
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_timeLB.frame) + 10, _titleLB.hd_width, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:seperateView];
    
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
