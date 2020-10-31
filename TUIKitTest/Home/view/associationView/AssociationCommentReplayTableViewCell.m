//
//  AssociationCommentReplayTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/29.
//

#import "AssociationCommentReplayTableViewCell.h"

#import "WFTextView.h"

@interface AssociationCommentReplayTableViewCell()<WFCoretextDelegate>

@property (nonatomic, strong)UIView * repalyView;

@end

@implementation AssociationCommentReplayTableViewCell


- (void)refreshUIWith:(YMTextData *)ymData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.contentView.frame = self.bounds;
    NSDictionary * infoDic = ymData.infoDic;
    self.info = ymData.infoDic;
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    self.iconImageView.layer.cornerRadius = self.iconImageView.hd_height / 2;
    self.iconImageView.layer.masksToBounds = YES;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y, self.hd_width - 70, self.iconImageView.hd_height / 2)];
    self.titleLB.font = kMainFont;
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    [self.contentView addSubview:self.titleLB];
    
    NSString * content = [infoDic objectForKey:@"content"];
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(self.hd_width - 70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height + 5;
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.iconImageView.frame) + 10, self.hd_width - 70, contentHeight)];
    self.contentLB.textColor = UIColorFromRGB(0x333333);
    self.contentLB.font = kMainFont;
    self.contentLB.text = content;
    self.contentLB.numberOfLines = 0;
    [self.contentView addSubview:self.contentLB];
    
    self.timeLb = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x, CGRectGetMaxY(self.titleLB.frame), 120, 15)];
    self.timeLb.font = kMainFont_10;
    self.timeLb.textColor = UIColorFromRGB(0x999999);
    self.timeLb.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"time"]];
    [self.contentView addSubview:self.timeLb];
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentBtn.frame = CGRectMake(CGRectGetMaxX(self.timeLb.frame) , self.timeLb.hd_y - 2.5, 40, 20);
    [self.commentBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = kMainFont_12;
//    [self.contentView addSubview:self.commentBtn];
    [self.commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.repalyView = [[UIView alloc]initWithFrame:CGRectMake(self.timeLb.hd_x, CGRectGetMaxY(self.contentLB.frame) + 10, self.hd_width - 70, ymData.replyHeight)];
    self.repalyView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    self.repalyView.layer.cornerRadius = 3;
    self.repalyView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.repalyView];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(self.repalyView.hd_x + 8, self.repalyView.hd_y - 7, 14, 7)];
    topView.backgroundColor = [UIColor clearColor];
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(topView.hd_x, self.repalyView.hd_y)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMidX(topView.frame), topView.hd_y)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(topView.frame), self.repalyView.hd_y)];
    [bezierPath closePath];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = topView.bounds;
    shapLayer.path = bezierPath.CGPath;
    shapLayer.fillColor = UIColorFromRGB(0xf4f4f4).CGColor;
    [topView.layer setMask:shapLayer];
    [self.contentView addSubview:topView];
    
    float origin_Y = 5;
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
        
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(10,origin_Y, kScreenWidth - 90, 0)];
        
        _ilcoreText.delegate = self;
        _ilcoreText.replyIndex = i;
        _ilcoreText.isFold = NO;
        _ilcoreText.attributedData = [ymData.attributedDataReply objectAtIndex:i];
        _ilcoreText.textColor = kCommonMainBlueColor;
        _ilcoreText.canClickAll = YES;
        WFReplyBody *body = (WFReplyBody *)[ymData.replyDataSource objectAtIndex:i];
        _ilcoreText.info = body.info;
        NSString *matchString;
        if ([[body.info objectForKey:@"reply_id"] intValue] == 0) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
        }else
        {
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
        }
        
        [_ilcoreText setOldString:matchString andNewString:[ymData.completionReplySource objectAtIndex:i]];
        
        _ilcoreText.frame = CGRectMake(10,origin_Y, kScreenWidth - 90, [_ilcoreText getTextHeight]);
        [self.repalyView addSubview:_ilcoreText];
        
        origin_Y += [_ilcoreText getTextHeight] + 5 ;
        
    }
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 1, self.hd_width, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:separateView];
    
    [self setNeedsDisplay];
}

- (void)commentAction
{
    if (self.commentBlock) {
        self.commentBlock(self.info);
    }
}

- (void)clickWFCoretextAllInfo:(NSDictionary *)info replyIndex:(NSInteger)index
{
    if (self.operationCommentBlock) {
        self.operationCommentBlock(info,self.info);
    }
}

- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index
{
    
}

- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index
{
    
}
@end
