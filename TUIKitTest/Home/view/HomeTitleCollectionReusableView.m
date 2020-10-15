//
//  HomeTitleCollectionReusableView.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeTitleCollectionReusableView.h"

@implementation HomeTitleCollectionReusableView

- (void)resetUIWithInfo:(NSDictionary *)info
{
    self.backgroundColor = [UIColor whiteColor];
    [self removeAllSubviews];
    self.info = info;
    // 65
    
    self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 20, 120, 25)];
    self.titleView.text = [info objectForKey:@"title"];
    self.titleView.font = [UIFont boldSystemFontOfSize:18];
    self.titleView.textColor = UIColorFromRGB(0x333333);
    [self addSubview:self.titleView];
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.frame = CGRectMake(self.hd_width - 60, 10, 50, 20);
    self.moreBtn.hd_centerY = self.titleView.hd_centerY;
    [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    self.moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.moreBtn setTitleColor:UIColorFromRGB(0x3D3731) forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    [self addSubview:self.moreBtn];
    
    [self.moreBtn addTarget:self action:@selector(openVipAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)openVipAction
{
    if (self.moreBlock) {
        self.moreBlock(self.info);
    }
}
    

@end
