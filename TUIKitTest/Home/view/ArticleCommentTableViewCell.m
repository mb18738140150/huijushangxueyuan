//
//  ArticleCommentTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import "ArticleCommentTableViewCell.h"

@implementation ArticleCommentTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.info = infoDic;
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[infoDic objectForKey:@"avatar"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    
    
    self.nameLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 5, _iconImageView.hd_y, 200, 15)];
    self.nameLB.text = [infoDic objectForKey:@"nickname"];
    self.nameLB.font = kMainFont;
    self.nameLB.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.nameLB];
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 5, _iconImageView.hd_centerY, 200, 15)];
    self.timeLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"time"]];
    self.timeLB.font = kMainFont_12;
    self.timeLB.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.timeLB];
    
    NSString * content = [infoDic objectForKey:@"content"];
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(self.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 5, CGRectGetMaxY(_iconImageView.frame) + 5, 200, contentHeight + 5)];
    self.contentLB.text = content;
    self.contentLB.font = kMainFont;
    self.contentLB.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.contentLB];
    
    
    self.replayLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 5, CGRectGetMaxY(_contentLB.frame), 200, 0)];
    if (![[infoDic objectForKey:@"reply"] isKindOfClass:[NSNull class]] ) {
        
        NSString * replay = [NSString stringWithFormat:@"回复：%@", [infoDic objectForKey:@"reply"]];
        CGFloat replayHeight = [replay boundingRectWithSize:CGSizeMake(self.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
        self.replayLB.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 5, CGRectGetMaxY(_contentLB.frame), 200, replayHeight + 5);
        self.replayLB.font = kMainFont;
        self.replayLB.textColor = UIColorFromRGB(0x333333);
        [self.contentView addSubview:self.replayLB];
        
        NSDictionary * attribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:kCommonMainBlueColor};
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:replay];
        [mStr setAttributes:attribute range:NSMakeRange(0, 3)];
        self.replayLB.attributedText = mStr;
    }
    
    
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zanBtn.frame = CGRectMake(self.hd_width - 15 - 30, 15, 30, 30);
    
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"zan_count"]] forState:UIControlStateNormal];
    self.zanBtn.titleLabel.font = kMainFont_10;
    
    BOOL is_zan = [[infoDic objectForKey:@"is_zan"] boolValue];
    if (is_zan) {
        [self.zanBtn setImage:[UIImage imageNamed:@"comment_点赞2"] forState:UIControlStateNormal];
        [self.zanBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    }else
    {
        [self.zanBtn setImage:[UIImage imageNamed:@"comment_点赞1"] forState:UIControlStateNormal];
        [self.zanBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    
    [self.contentView addSubview:self.zanBtn];
    
    [self.zanBtn addTarget:self action:@selector(zanAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_replayLB.frame) + 14, self.hd_width - 30, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:separateView];
    
}

- (void)zanAction
{
    if (self.zanBlock) {
        self.zanBlock(self.info);
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
