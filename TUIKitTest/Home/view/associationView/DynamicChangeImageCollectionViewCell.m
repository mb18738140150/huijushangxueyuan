//
//  DynamicChangeImageCollectionViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/31.
//

#import "DynamicChangeImageCollectionViewCell.h"

@implementation DynamicChangeImageCollectionViewCell

- (void)refreshUIWith:(UIImage *)info andCanClose:(BOOL)canClose
{
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xffffff);
    self.info = info;
    
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_width - 20)];
    self.iconImage.image = info;
    [self.contentView addSubview:self.iconImage];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(self.hd_width - 15, 0, 15, 15);
    [_closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_closeBtn];
    _closeBtn.hidden = YES;
    if (canClose) {
        _closeBtn.hidden = NO;
    }
}

- (void)closeAction
{
    if (self.closeImageBlock) {
        self.closeImageBlock(self.info);
    }
}

@end
