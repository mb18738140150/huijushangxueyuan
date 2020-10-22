//
//  ArticleVideoTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/20.
//

#import "ArticleVideoTableViewCell.h"

@implementation ArticleVideoTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    if (nil == infoDic) {
        return;
    }
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, self.hd_height)];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[infoDic objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    
    self.backView = [[UIView alloc]initWithFrame:self.backImageView.frame];
    self.backView.backgroundColor = [UIColor blackColor];
    
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.backImageView];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    self.playBtn.hd_centerX = self.backImageView.hd_centerX;
    self.playBtn.hd_centerY = self.backImageView.hd_centerY;
    [self.contentView addSubview:self.playBtn];
    [self.playBtn setImage:[UIImage imageNamed:@"时间"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.backgroundColor = UIColorFromRGB(0xff0000);
}

- (void)hideAllView
{
    _backImageView.hidden = YES;
    _playBtn.hidden = YES;
}

- (void)playAction{
    if (self.playActionBlock) {
        self.playActionBlock(@{});
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
