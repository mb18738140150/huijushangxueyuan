//
//  HomeBigImageNoTeacherTypeCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeBigImageNoTeacherTypeCollectionViewCell.h"

@implementation HomeBigImageNoTeacherTypeCollectionViewCell
- (void)refreshUIWith:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    self.infoDic = infoDic;
    
    // (self.hd_width - 35) / 2 + 77.5
    
    CGFloat topSpace = 0;
    if (self.isOneCourse) {
        topSpace = 20;
    }
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, (self.hd_width - 35) / 2 + 77.5 + topSpace)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    // 直播大图
    self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, topSpace, self.hd_width - 35, (self.hd_width - 35) / 2)];
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@"placeholdImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    [self.backView addSubview:self.iconImageVIew];
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.iconImageVIew.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = self.iconImageVIew.bounds;
    shapLayer.path = bezierpath.CGPath;
    [self.iconImageVIew.layer setMask: shapLayer];
    
    // 直播状态
    self.livingStateView = [[LivingStateView alloc]initWithFrame:CGRectMake(5, self.iconImageVIew.hd_height - 25, 100, 20)];
    if ([infoDic objectForKey:@"topic_status"])
    {
        // topic_status 1.直播中 2.未开始 3.已结束
        int livingStatus = [[infoDic objectForKey:@"topic_status"] intValue];
        switch (livingStatus) {
            case 1:
            {
                self.livingStateView.frame = CGRectMake(5, self.iconImageVIew.hd_height - 25, 100, 20);
                self.livingStateView.livingState = HomeLivingStateType_living;
                
            }
                break;
            case 2:
            {
                self.livingStateView.livingState = HomeLivingStateType_noStart;
            }
                break;
            case 3:
            {
                self.livingStateView.livingState = HomeLivingStateType_end;
            }
                break;
                
            default:
                self.livingStateView.livingState = HomeLivingStateType_living;
                break;
        }
    }
    [self.iconImageVIew addSubview:self.livingStateView];
    
    CGFloat seperateWidth = 10;
    
    // title
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageVIew.hd_x , CGRectGetMaxY(self.iconImageVIew.frame) + seperateWidth, self.backView.hd_width - 35, 22.5)];
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = [UIFont boldSystemFontOfSize:16];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    [self.backView addSubview:self.titleLB];
    
    
    // price
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(_titleLB.frame) + seperateWidth, 150, 20)];
    self.priceLB.font = kMainFont_12;
    self.priceLB.textColor = UIColorFromRGB(0xCCA95D);
    [self.backView addSubview:self.priceLB];
    
    NSString * oldStr = [self getOldStrWithSource1:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] andSource2:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"off_paymoney"]]];
       [self.backView addSubview:self.priceLB];
       
       NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
       NSMutableAttributedString * NewStr = [[NSMutableAttributedString alloc]initWithString:oldStr];
       [NewStr addAttributes:attribute range:NSMakeRange([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] length] + 1, oldStr.length - [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] length] - 1)];
       self.priceLB.attributedText = NewStr;
    
    // joinBtn
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(self.backView.hd_width - 97.5, CGRectGetMaxY(self.iconImageVIew.frame) + 66.5, 80, 30);
    [self.applyBtn setTitle:[NSString stringWithFormat:@"%@人已看过", [infoDic objectForKey:@"look_num"]] forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    self.applyBtn.backgroundColor = [UIColor whiteColor];
    self.applyBtn.titleLabel.font = kMainFont_10;
    [self.backView addSubview:self.applyBtn];
    
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
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
@end
