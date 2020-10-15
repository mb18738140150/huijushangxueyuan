//
//  HomeAdverCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeAdverCollectionViewCell.h"

@implementation HomeAdverCollectionViewCell

- (void)refreshUIWith:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 17.5, self.hd_width - 35, (self.hd_width - 35) / 4)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[info objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"placeholdImage"] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [self.contentView addSubview:self.iconImageView];
}

@end
