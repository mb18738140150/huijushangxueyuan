//
//  TeacherArticleTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/22.
//

#import "TeacherArticleTableViewCell.h"

#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"
#import "UIUtility.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"
@implementation TeacherArticleTableViewCell

- (void)refreshUIWith:(NSDictionary *)info andCornerType:(CellCornerType)cornertype
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.info = info;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.hd_width - 20, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    if (cornertype == CellCornerType_top) {
        UIBezierPath * topBPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer * layer = [[CAShapeLayer alloc]init];
        layer.frame = backView.bounds;
        layer.path = topBPath.CGPath;
        [backView.layer setMask:layer];
    }else if (cornertype == CellCornerType_bottom)
    {
        UIBezierPath * topBPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer * layer = [[CAShapeLayer alloc]init];
        layer.frame = backView.bounds;
        layer.path = topBPath.CGPath;
        [backView.layer setMask:layer];
    }
    float cellWidth = self.hd_width;
    
    // 90
    CGFloat topSpace = 10;

    // teacher
    self.courseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, topSpace, 140, 70)];
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[info objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseImageView.layer.cornerRadius = kMainCornerRadius;
    self.courseImageView.layer.masksToBounds = YES;
    [backView addSubview:self.courseImageView];
    
    // 课程名称
    self.courseChapterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.courseImageView.frame) + 12, topSpace, self.hd_width - 185, 20)];
    self.courseChapterNameLabel.font = kMainFont;
    self.courseChapterNameLabel.textColor = UIColorFromRGB(0x333333);
    [backView addSubview:self.courseChapterNameLabel];
    self.courseChapterNameLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"title"]];
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_courseChapterNameLabel.hd_x, _courseImageView.hd_centerY - 8, 100, 16)];
    self.typeLabel.text = [self getTypeString];
    self.typeLabel.font = kMainFont_12;
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.backgroundColor = [self getBackColor];
    self.typeLabel.textColor = [self getTitleColor];
    [self.typeLabel sizeToFit];
    [backView addSubview:self.typeLabel];
    
    self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_typeLabel.frame) + 5, CGRectGetMaxY(_courseChapterNameLabel.frame), backView.hd_width - CGRectGetMaxX(_typeLabel.frame) - 20, 30)];
    
    NSString * htmlString = [UIUtility judgeStr:[info objectForKey:@"desc"]];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.descLabel.attributedText = attrStr;
    self.descLabel.textColor = UIColorFromRGB(0x999999);
    self.descLabel.font = kMainFont_12;
    [backView addSubview:self.descLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_courseChapterNameLabel.hd_x, CGRectGetMaxY(_descLabel.frame), 200, 20)];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"time"]];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    _timeLabel.font = kMainFont_12;
    [backView addSubview:_timeLabel];
    
    // 价格
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(backView.hd_width - 200, CGRectGetMaxY(self.courseImageView.frame) - 20, 185, 20)];
    self.priceLabel.font = kMainFont;
    self.priceLabel.textColor = UIColorFromRGB(0xCCA95D);
    [backView addSubview:self.priceLabel];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@", [SoftManager shareSoftManager].coinName,[info objectForKey:@"show_paymoney"]];
    
    
    
    
}

- (NSString * )getTypeString
{
    NSDictionary * info = self.info;
    if ([info objectForKey:@"type"]) {
        NSString * type = [info objectForKey:@"type"];
        if ([type isEqualToString:@"article"]) {
            return @"图文";
        }else if ([type isEqualToString:@"image"])
        {
            return @"图片";
        }else if ([type isEqualToString:@"audio"])
        {
            return @"音频";

        }else if ([type isEqualToString:@"video"])
        {
            return @"视频";

        }
    }else if ([info objectForKey:@"topic_status"])
    {
        int livingStatus = [[info objectForKey:@"topic_style"] intValue];
        switch (livingStatus) {
            case 1:
            {
                
                return @"语音课件直播";
            }
                break;
            case 2:
            {
                return @"实时视频直播";
            }
                break;
            case 3:
            {
                return @"录播";
            }
                break;
            case 6:
            {
                return @"第三方直播";
            }
                break;
            default:
                break;
        }
    }
    return @"";
}

- (UIColor *)getTitleColor
{
    NSDictionary * info = self.info;
    if ([info objectForKey:@"type"]) {
        NSString * type = [info objectForKey:@"type"];
        if ([type isEqualToString:@"article"]) {
            return UIColorFromRGB(0x0E9A4C);
        }else if ([type isEqualToString:@"image"])
        {
            return UIColorFromRGB(0x2A4CED);
        }else if ([type isEqualToString:@"audio"])
        {
            return UIColorFromRGB(0xED6A2A);

        }else if ([type isEqualToString:@"video"])
        {
            return UIColorFromRGB(0x0FB1BF);

        }
    }else if ([info objectForKey:@"topic_status"])
    {
        int livingStatus = [[info objectForKey:@"topic_style"] intValue];
        switch (livingStatus) {
            case 1:
            {
                
                return UIColorFromRGB(0x0E9A4C);
            }
                break;
            case 2:
            {
                return UIColorFromRGB(0xED2A6A);
            }
                break;
            case 3:
            {
                return UIColorFromRGB(0x0FB1BF);
            }
                break;
            case 6:
            {
                return UIColorFromRGB(0xED2A6A);
            }
                break;
            default:
                break;
        }
    }
    return UIColorFromRGB(0xffffff);
}


- (UIColor *)getBackColor
{
    NSDictionary * info = self.info;
    if ([info objectForKey:@"type"]) {
        NSString * type = [info objectForKey:@"type"];
        if ([type isEqualToString:@"article"]) {
            return UIColorFromRGB(0xE6F6ED);
        }else if ([type isEqualToString:@"image"])
        {
            return UIColorFromRGB(0xEAEEFF);
        }else if ([type isEqualToString:@"audio"])
        {
            return UIColorFromRGB(0xFBF0E8);

        }else if ([type isEqualToString:@"video"])
        {
            return UIColorFromRGB(0xE3F5F7);

        }
    }else if ([info objectForKey:@"topic_status"])
    {
        int livingStatus = [[info objectForKey:@"topic_style"] intValue];
        switch (livingStatus) {
            case 1:
            {
                
                return UIColorFromRGB(0xE6F6ED);
            }
                break;
            case 2:
            {
                return UIColorFromRGB(0xFFEFF3);
            }
                break;
            case 3:
            {
                return UIColorFromRGB(0xE3F5F7);
            }
                break;
            case 6:
            {
                return UIColorFromRGB(0xFFEFF3);
            }
                break;
            default:
                break;
        }
    }
    return UIColorFromRGB(0xffffff);
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
