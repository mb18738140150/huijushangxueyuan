//
//  SecondListTableViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "MyPresentRecordTableViewCell.h"

#import "CommonMacro.h"
#import "UIImageView+AFNetworking.h"
#import "UIUtility.h"
#import "UIMacro.h"
#import "DelayButton+helper.h"
@implementation MyPresentRecordTableViewCell

- (void)resetCellContent:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.info = info;
    float cellWidth = self.hd_width;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 90
    CGFloat topSpace = 10;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);

    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_height - 15)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    // teacher
    self.courseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, topSpace, 140, 70)];
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[info objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseImageView.layer.cornerRadius = kMainCornerRadius;
    self.courseImageView.layer.masksToBounds = YES;
    [backView addSubview:self.courseImageView];
    
    
    // 课程名称
    self.courseChapterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.courseImageView.frame) + 12, topSpace, backView.hd_width - 185, 35)];
    self.courseChapterNameLabel.text = [info objectForKey:kCourseName];
    self.courseChapterNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.courseChapterNameLabel.numberOfLines = 0;
    self.courseChapterNameLabel.textColor = UIColorFromRGB(0x333333);
    [backView addSubview:self.courseChapterNameLabel];
    self.courseChapterNameLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"title"]];
    
    // 时间
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.courseChapterNameLabel.hd_x, CGRectGetMaxY(self.courseImageView.frame) - 20, 100, 20)];
    self.priceLabel.font = kMainFont;
    self.priceLabel.textColor = UIColorFromRGB(0xCCA95D);
    [backView addSubview:self.priceLabel];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"time"]];
    
    // 价格
    self.payCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(backView.hd_width - 117.5, CGRectGetMaxY(self.courseImageView.frame) - 20, 100, 20)];
    self.payCountLabel.font = [UIFont systemFontOfSize:10];
    self.payCountLabel.textColor = UIColorFromRGB(0xCCA95D);
    self.payCountLabel.text = [NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, [info objectForKey:@"price"]];
    self.payCountLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:self.payCountLabel];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.courseImageView.frame) + 10, backView.hd_width, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
    
    if ([[info objectForKey:@"give_status"] intValue] == 1) {
        self.presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _presentBtn.frame = CGRectMake(backView.hd_width - 50, CGRectGetMaxY(separateView.frame) + 10, 40, 20);
        _presentBtn.backgroundColor = kCommonMainBlueColor;
        _presentBtn.layer.cornerRadius = _presentBtn.hd_height / 2;
        _presentBtn.layer.masksToBounds = YES;
        [_presentBtn setTitle:@"赠送" forState:UIControlStateNormal];
        [_presentBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _presentBtn.titleLabel.font = kMainFont;
        [backView addSubview:_presentBtn];
        [_presentBtn addTarget:self action:@selector(presentAcytion) forControlEvents:UIControlEventTouchUpInside];
        
    }else
    {
        NSString * nameStr = [[info objectForKey:@"to_user"] objectForKey:@"nickname"];
        NSString * stateStr = [[info objectForKey:@"give_status"] intValue] == 1? @"未赠送" : @"已领取";
        NSString * newStr = [nameStr stringByAppendingFormat:@" %@", stateStr];
        CGFloat width = [newStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.width;
        
        self.presenteriName = [[UILabel alloc]initWithFrame:CGRectMake(backView.hd_width - 15 - width, CGRectGetMaxY(separateView.frame) + 10, width + 5, 20)];
        self.presenteriName.font = kMainFont;
        self.presenteriName.textColor = UIColorFromRGB(0x999999);
        self.presenteriName.textAlignment = NSTextAlignmentRight;
        [backView addSubview:self.presenteriName];
        
        NSDictionary * attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:newStr];
        [mStr addAttributes:attribute range:NSMakeRange(0, nameStr.length)];
        self.presenteriName.attributedText = mStr;
        
        self.presenteriConImage = [[UIImageView alloc]initWithFrame:CGRectMake(_presenteriName.hd_x - 25, _presenteriName.hd_y, 20, 20)];
        [self.presenteriConImage sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[[info objectForKey:@"to_user"] objectForKey:@"avatar"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
        self.presenteriConImage.layer.cornerRadius = self.presenteriConImage.hd_height / 2;
        self.presenteriConImage.layer.masksToBounds = YES;
        [backView addSubview:self.presenteriConImage];
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

- (void)presentAcytion
{
    if (self.presentBlock) {
        self.presentBlock();
    }
}

@end
