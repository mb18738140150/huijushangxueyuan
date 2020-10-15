//
//  LivingImageListTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import "LivingImageListTableViewCell.h"



@implementation LivingImageListTableViewCell

- (void)resetUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    __weak typeof(self)weakSelf = self;
    self.iconImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"url"]]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if ([[info objectForKey:@"height"] floatValue] > 0) {
            // 不作处理
        }else
        {
            if (weakSelf.loadImageSuccessBlock) {
                weakSelf.loadImageSuccessBlock(CGSizeMake(image.size.width, image.size.height));
            }
        }
    }];
    [self.contentView addSubview:self.iconImageView];
    
    
}


@end
