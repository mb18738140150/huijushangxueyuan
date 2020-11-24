//
//  MyBuyCourseTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/16.
//

#import "MyBuyCourseTableViewCell.h"

#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"
#import "UIUtility.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"
@implementation MyBuyCourseTableViewCell



- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    
    float cellWidth = self.hd_width;
    
    // 90
    CGFloat topSpace = 10;

    // teacher
    self.courseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, topSpace, 140, 70)];
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[info objectForKey:@"product_thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseImageView.layer.cornerRadius = kMainCornerRadius;
    self.courseImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.courseImageView];
    [self.courseImageView addSubview:self.payCountLabel];
    
    // 直播状态
    self.livingStateView = [[LivingStateView alloc]initWithFrame:CGRectMake(0, self.courseImageView.hd_height - 20, 100, 20)];
    self.livingStateView.livingState = HomeLivingStateType_video;
//    [self.courseImageView addSubview:self.livingStateView];
    
    
    // 课程名称
    self.courseChapterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.courseImageView.frame) + 12, topSpace, self.hd_width - 185, 35)];
    self.courseChapterNameLabel.text = [info objectForKey:kCourseName];
    self.courseChapterNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.courseChapterNameLabel.numberOfLines = 0;
    self.courseChapterNameLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.courseChapterNameLabel];
    self.courseChapterNameLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"product_title"]];
    
    // 时间
    UIImageView * huangguanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.courseChapterNameLabel.hd_x, CGRectGetMaxY(self.courseImageView.frame) - 18, 15, 15)];
    huangguanImageView.image = [UIImage imageNamed:@"livingTime"];
    [self.contentView addSubview:huangguanImageView];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(huangguanImageView.frame) + 3, CGRectGetMaxY(self.courseImageView.frame) - 20, 150, 20)];
    self.priceLabel.font = kMainFont_10;
    self.priceLabel.textColor = UIColorFromRGB(0x999999);
    NSString * oldStr = [info objectForKey:@"order_pay_time"];
    [self.contentView addSubview:self.priceLabel];
    self.priceLabel.text = oldStr;
    
    // 价格
    NSString * priceStr = [NSString stringWithFormat:@"%@%@", [SoftManager shareSoftManager].coinName, [info objectForKey:@"order_pay_money"]];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)};
    NSMutableAttributedString * NewStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [NewStr addAttributes:attribute range:NSMakeRange([SoftManager shareSoftManager].coinName.length, priceStr.length  - [SoftManager shareSoftManager].coinName.length)];
    
    self.payCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 117.5, CGRectGetMaxY(self.courseImageView.frame) - 20, 100, 20)];
    self.payCountLabel.font = [UIFont systemFontOfSize:17];
    self.payCountLabel.textColor = UIColorFromRGB(0x999999);
    self.payCountLabel.textAlignment = NSTextAlignmentRight;
    self.payCountLabel.attributedText = NewStr;
    [self.contentView addSubview:self.payCountLabel];
    
}

- (NSString *)getOldStrWithSource1:(NSString *)str1 andSource2:(NSString *)str2
{
    if (str2.length == 0) {
        return [NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, str1];
    }else
    {
        return [NSString stringWithFormat:@"%@%@ %@%@",[SoftManager shareSoftManager].coinName, str1,[SoftManager shareSoftManager].coinName,str2];
    }
}

@end
