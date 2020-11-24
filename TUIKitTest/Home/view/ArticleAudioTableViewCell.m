//
//  ArticleAudioTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/20.
//

#import "ArticleAudioTableViewCell.h"
#import "BTVoicePlayer.h"

@implementation ArticleAudioTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width / 2 - 75, 15, 150, 150)];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[infoDic objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    self.backImageView.backgroundColor = UIColorFromRGB(0xdddddd);
    [self.contentView addSubview:self.backImageView];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    self.playBtn.hd_centerX = self.backImageView.hd_centerX;
    self.playBtn.hd_centerY = self.backImageView.hd_centerY;
    [self.contentView addSubview:self.playBtn];
    [self.playBtn setImage:[UIImage imageNamed:@"videoPause"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
//    self.playBtn.backgroundColor = UIColorFromRGB(0xff0000);
    
    self.currentLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_backImageView.frame) + 20, 100, 20)];
    self.currentLB.text = @"00:00";
    self.currentLB.textColor = UIColorFromRGB(0x333333);
    self.currentLB.font = kMainFont_12;
    self.currentLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.currentLB];
    
    self.durationLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 100, CGRectGetMaxY(_backImageView.frame) + 20, 100, 20)];
    self.durationLB.text = @"00:00";
    self.durationLB.textColor = UIColorFromRGB(0x333333);
    self.durationLB.font = kMainFont_12;
    self.durationLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.durationLB];
    
    self.progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.currentLB.frame) + 5, self.currentLB.hd_y, kScreenWidth - CGRectGetMaxX(self.currentLB.frame) * 2 - 10  , 20)];
    self.progressSlider.maximumTrackTintColor = UIColorFromRGB(0x333333);
    self.progressSlider.minimumTrackTintColor = [UIColor redColor];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"icon_zzss"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.progressSlider];
    self.progressSlider.maximumValue = 1;
    
}

- (void)playAction{
    
    if ([[BTVoicePlayer share] isPlaying]) {
        [self.playBtn setImage:[UIImage imageNamed:@"videoPause"] forState:UIControlStateNormal];
    }else
    {
        [self.playBtn setImage:[UIImage imageNamed:@"videoPlay"] forState:UIControlStateNormal];
    }
    
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
