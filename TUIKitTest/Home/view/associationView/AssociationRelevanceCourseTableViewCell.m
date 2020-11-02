//
//  AssociationRelevanceCourseTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/2.
//

#import "AssociationRelevanceCourseTableViewCell.h"

@implementation AssociationRelevanceCourseTableViewCell

- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    float cellWidth = self.hd_width;
    
    // 90
    CGFloat topSpace = 10;

    // teacher
    self.courseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, topSpace, 100, 70)];
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[info objectForKey:@"shop_thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseImageView.layer.cornerRadius = kMainCornerRadius;
    self.courseImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.courseImageView];
    
    // 课程名称
    self.courseChapterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.courseImageView.frame) + 12, topSpace, self.hd_width - 185, 25)];
    self.courseChapterNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.courseChapterNameLabel.numberOfLines = 0;
    self.courseChapterNameLabel.textColor = UIColorFromRGB(0x000000);
    [self.contentView addSubview:self.courseChapterNameLabel];
    self.courseChapterNameLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"shop_title"]];
    
    // 价格
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseChapterNameLabel.hd_x, CGRectGetMaxY(self.courseChapterNameLabel.frame), 100, 25)];
    self.priceLabel.font = kMainFont;
    self.priceLabel.textColor = kCommonMainBlueColor;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"shop_money"]];
    [self.contentView addSubview:self.priceLabel];
    
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
