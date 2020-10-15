//
//  FailView.m
//  tiku
//
//  Created by aaa on 2017/6/1.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import "FailView.h"

@implementation FailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = kCommonNavigationBarColor;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 100, 200, 200)];
    self.imageView.hd_centerX = self.hd_centerX;
    [self addSubview:self.imageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.imageView.frame) + 20, kScreenWidth, 15)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.textAlignment = 1;
    self.titleLB.font = kMainFont;
    [self addSubview:self.titleLB];
    
    self.refreshBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBT.frame = CGRectMake(0, CGRectGetMaxY(self.titleLB.frame) + 20, kScreenWidth, 26);
    self.refreshBT.hd_centerX = self.hd_centerX;
//    self.refreshBT.layer.cornerRadius = self.refreshBT.hd_height / 2;
//    self.refreshBT.layer.masksToBounds = YES;
//    self.refreshBT.layer.borderWidth = 1;
//    self.refreshBT.layer.borderColor = UIColorFromRGB(0x1D7AF8).CGColor;
    [self.refreshBT setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [self.refreshBT setTitle:@"刷新" forState:UIControlStateNormal];
    self.refreshBT.titleLabel.font = kMainFont;
    [self addSubview:self.refreshBT];
    [self.refreshBT addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setFailType:(FailType )failType
{
    _failType = failType;
    [self.refreshBT setTitle:@"刷新" forState:UIControlStateNormal];
    switch (failType) {
        case FailType_NoData:
        {
            self.imageView.image = [UIImage imageNamed:@"zwty"];
            self.titleLB.text = @"暂无数据";
        }
            break;
        case FailType_NoNetWork:
        {
            self.imageView.image = [UIImage imageNamed:@"zwty"];
            self.titleLB.text = @"暂无网络连接";
        }
            break;
        case FailType_NoLogin:
        {
            self.imageView.image = [UIImage imageNamed:@"zwty"];
            self.titleLB.text = @"请先登录";
            [self.refreshBT setTitle:@"登录" forState:UIControlStateNormal];
        }
            break;
        case FailType_NoCourse:
        {
            self.imageView.image = [UIImage imageNamed:@"zwty"];
            self.titleLB.text = @"您还没有购买网校辅导课程";
            [self.refreshBT setTitle:@"快去选购课程吧~" forState:UIControlStateNormal];
        }
            break;
        case FailType_NoOrder:
        {
            self.imageView.image = [UIImage imageNamed:@"zwdd"];
            self.titleLB.text = @"暂无订单";
            [self.refreshBT setTitle:@"快去选购课程吧~" forState:UIControlStateNormal];
        }
            break;
        case FailType_NoNote:
        {
            self.imageView.image = [UIImage imageNamed:@"zwbj"];
            self.titleLB.text = @"暂无课程笔记";
            [self.refreshBT setTitle:@"好记性不如烂笔头快去做笔记吧~" forState:UIControlStateNormal];
        }
            break;
        case FailType_NoDownload:
        {
            self.imageView.image = [UIImage imageNamed:@"zwxz"];
            self.titleLB.text = @"暂无下载";
            [self.refreshBT setTitle:@"快去其他地方逛逛吧~" forState:UIControlStateNormal];
        }
            break;
        case FailType_Noquestion:
        {
            self.imageView.image = [UIImage imageNamed:@"zwwt"];
            self.titleLB.text = @"您还未发布任何问题";
            [self.refreshBT setTitle:@"快去其他地方逛逛吧~" forState:UIControlStateNormal];
        }
            break;
        case FailType_NoLiving:
        {
            self.imageView.image = [UIImage imageNamed:@"zwzb"];
            self.titleLB.text = @"您还未预约任何直播课";
            [self.refreshBT setTitle:@"快去选购课程吧~" forState:UIControlStateNormal];
        }
            break;
        case FailType_NoTiku:
        {
            self.imageView.image = [UIImage imageNamed:@"zwtk"];
            self.titleLB.text = @"您还未购买任何题库";
            [self.refreshBT setTitle:@"快去其他地方逛逛吧~" forState:UIControlStateNormal];
        }
            break;
        case FailType_NoStudyRecord:
        {
            self.imageView.image = [UIImage imageNamed:@"zwtk"];
            self.titleLB.text = @"暂无学习记录";
            [self.refreshBT setTitle:@"快去学习吧~" forState:UIControlStateNormal];
        }
            break;
        case FailType_NoCollection:
        {
            self.imageView.image = [UIImage imageNamed:@"zwty"];
            self.titleLB.text = @"您还未收藏课程";
            [self.refreshBT setTitle:@"快去其他地方逛逛吧~" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)refresh
{
    if(_failType == FailType_NoLogin)
    {
        if (self.LoginBlock) {
            self.LoginBlock();
        }
    }else
    {
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        if (self.OperationBlock) {
            self.OperationBlock(self.failType);
        }
    }
}

- (void)refreshNoCourseData
{
    self.titleLB.text = @"课程录制中，敬请期待";
    self.refreshBT.hidden = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
