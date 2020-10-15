//
//  CustomCell.m
//  BarrageDemo
//
//  Created by siping ruan on 16/9/22.
//  Copyright © 2016年 siping ruan. All rights reserved.
//

#import "CustomCell.h"
#import "BarrageModel.h"
#import "UIImageView+WebCache.h"
#import "BarrageView.h"

@interface CustomCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end

@implementation CustomCell

- (instancetype)reloadCustomCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:0].firstObject;
}

//- (instancetype)init
//{
//    if (self = [super init]) {
//        self = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:0].firstObject;
//    }
//    return self;
//}

+ (instancetype)cellWithBarrageView:(BarrageView *)barrageView
{
    static NSString *reuseIdentifier = @"CustomCell";
    CustomCell *cell = [barrageView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[CustomCell alloc] initWithIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.avatar.clipsToBounds = YES;
    self.avatar.layer.cornerRadius = 14;
    
}

- (void)setModel:(BarrageModel *)model
{
    _model = model;
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"mor_toux"] options:SDWebImageAllowInvalidSSLCertificates];
    self.message.text = model.message;
}

@end
