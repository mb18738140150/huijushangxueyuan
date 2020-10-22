//
//  ArticleImageTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import "ArticleImageTableViewCell.h"

@implementation ArticleImageTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellAccessoryNone;
    [self.contentView removeAllSubviews];
    
    __weak typeof(self)weakSelf = self;
    self.avaterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, self.hd_width - 30, self.hd_height)];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:[[UIUtility judgeStr:[infoDic objectForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (weakSelf.imageHeight <= 0) {
            CGFloat height = [weakSelf getImageHeight:image];
            if (weakSelf.getImageHeightBlock) {
                weakSelf.getImageHeightBlock(height);
            }
        }
    }];
    [self.contentView addSubview:self.avaterImageView];
}

- (CGFloat)getImageHeight:(UIImage *)image
{
    if (!image) {
        return 0;
    }
    CGFloat height;
    
    height = (kScreenWidth - 30) * image.size.height / image.size.width;
    
    return height;
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
