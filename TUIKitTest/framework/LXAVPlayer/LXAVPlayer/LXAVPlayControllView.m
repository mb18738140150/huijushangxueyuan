//
//  LXAVPlayControllView.m
//  LXPlayer
//
//  Created by chenergou on 2017/12/4.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXAVPlayControllView.h"

#define TopViewH ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define BottomViewH 48
#define Space 10
#import "LXPlayLoadingView.h"
@interface LXAVPlayControllView()<UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource>
/*
 * 顶部工具栏
 *
 */
@property(nonatomic,strong)UIView *   topView; //容器

@property(nonatomic,strong)LxButton * backBtn;//返回按钮

@property(nonatomic,strong)UILabel *  titleLabel;//标题

/*
 * 底部工具栏
 *
 */

@property(nonatomic,strong)UIView *   bottomView;//底部容器


@property(nonatomic,strong)LXSlider * slider;

@property(nonatomic,strong)LxButton * playBtn;//播放按钮

@property(nonatomic,strong)UILabel *  startLabel;//开始时间

@property(nonatomic,strong)UILabel *  endLabel;//结束时间

@property(nonatomic,strong)LxButton *  rateBtn;//播放速率按钮
@property (nonatomic, strong)UITableView * rateTableView;
@property (nonatomic, strong)NSArray * rateArray;

@property(nonatomic,strong)LxButton * fullScreenBtn;

@property(nonatomic,strong)LxButton * rePlaytbn;//重播按钮

@property(nonatomic,strong)LXPlayLoadingView *loadingView;//加载圈圈


@property(nonatomic,strong)UIImageView  *placeholdImageView;//加载圈圈

@end
@implementation LXAVPlayControllView

-(instancetype)init{
    self = [super init];
    if (self) {
      
        [self setUp];
        
        [self makeConstraints];
        
        [self addCallBack];
    }
    return self;
}
-(void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;
    
    self.fullScreenBtn.selected = isFullScreen;
}
#pragma mark---添加回调-
-(void)addCallBack{
    
    LXWS(weakSelf);
    [self.playBtn addClickBlock:^(UIButton *button) {
        
        button.selected  = !button.selected;
        if (weakSelf.playCallBack) {
            weakSelf.playCallBack(button.selected);
        }
        
    }];
    
    [self.fullScreenBtn addClickBlock:^(UIButton *button) {
        button.selected = !button.selected;
        
        if (weakSelf.fullScreenBlock) {
            weakSelf.fullScreenBlock(!button.selected);
        }
        
    }];
    
    [self.backBtn addClickBlock:^(UIButton *button) {
        
        if (weakSelf.backBlock) {
            weakSelf.backBlock();
        }
    }];
    
    
    [self.rePlaytbn addClickBlock:^(UIButton *button) {
        
        if (weakSelf.replayBlock) {
            weakSelf.replayBlock(YES);
        }
    }];
    
    [self.rateBtn addClickBlock:^(UIButton *button) {
        weakSelf.rateTableView.hidden = NO;
    }];
    
}
#pragma mark--接口--
-(void)showIsAnimated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.topView.alpha = 1.0;
            self.bottomView.alpha = 1.0;

        }];
    }else{
        self.topView.alpha = 1.0;
        self.bottomView.alpha = 1.0;
    }
    
    self.isShow = YES;
}
-(void)hidIsAnimated:(BOOL)animated{
    self.rateTableView.hidden = YES;
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.topView.alpha = 0.0;
            self.bottomView.alpha = 0.0;
            
        }];
    }else{
        self.topView.alpha = 0.0;
        self.bottomView.alpha = 0.0;
    }
    
    self.isShow = NO;
}
-(void)IsPlaying:(BOOL)isPlaying{
    self.playBtn.selected = isPlaying;
    
    self.rePlaytbn.hidden = YES;
    self.bottomView.hidden = NO;
    
    self.slider.userInteractionEnabled = YES;
    self.bottomView.userInteractionEnabled = YES;
    self.placeholdImageView.alpha = 0;
}
//播放结束
-(void)showPlayEnd{
    
    self.rePlaytbn.hidden = NO;
    self.bottomView.hidden = YES;
    
    
}
-(void)showLoadingAnimation:(BOOL)isShow{
    
    self.bottomView.userInteractionEnabled = self.loadingView.hidden = !isShow;
}
//重置播放状态
-(void)resetPlayState{
    
    self.startTime = @"00:00";
    self.endTime = @"00:00";
    self.slideValue = 0.0;
    self.cacheValue = 0.0;
    
    [self showLoadingAnimation:YES];
    
    self.slider.userInteractionEnabled = NO;
    self.bottomView.userInteractionEnabled = NO;
    
    self.rePlaytbn.hidden = YES;
}

- (void)hideVideoProgress
{
    self.rateBtn.hidden = YES;
    self.startLabel.hidden = YES;
    self.endLabel.hidden = YES;
    self.slider.hidden = YES;
}

#pragma mark---控件---
-(void)setUp{
    
    self.rateArray = @[@"0.75",@"1.0",@"1.25",@"1.5",@"2.0"];
    
    [self addSubview:self.placeholdImageView];
    //顶部工具栏
    [self addSubview:self.topView];
    
    [self.topView addSubview:self.backBtn];
    [self.topView addSubview:self.titleLabel];
    
    //底部工具栏
    [self addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.playBtn];
    
    
    [self.bottomView addSubview:self.startLabel];
    
    [self.bottomView addSubview:self.endLabel];
    
    [self.bottomView addSubview:self.rateBtn];
    
    [self.bottomView addSubview:self.fullScreenBtn];
    
    [self.bottomView addSubview:self.slider];
    
    [self addSubview:self.rePlaytbn];
    
    [self addSubview:self.rateTableView];
    
    
    [self addSubview:self.loadingView];
    LXWS(weakSelf);
    self.slider.panBegin = ^{
        
        if (weakSelf.panBegin) {
            weakSelf.panBegin();
        }
    };
    
    self.slider.getSlideValue = ^(CGFloat value) {
        
        if (weakSelf.getSlideValue) {
            weakSelf.getSlideValue(value);
        }
    };
 
    self.slider.panEnd = ^(CGFloat value) {
        if (weakSelf.panEnd) {
            weakSelf.panEnd(value);
        }
    };
    
    self.slider.tapSlider = ^(CGFloat value) {
        if (weakSelf.tapSlider) {
            weakSelf.tapSlider(value);
        }
    };
}
#pragma mark --添加约束---
-(void)makeConstraints{
    
    
    [self.placeholdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    //顶部view的设置
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(@TopViewH);
        
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.mas_equalTo(self.topView);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backBtn.mas_right).with.offset(Space);
        make.right.equalTo(self.topView).with.offset(-Space);
        make.height.top.bottom.equalTo(self.topView);
    }];
    
    
    //底部view的设置
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(@BottomViewH);
        
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(@Space);
        
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(@-Space);
        
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    [self.rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenBtn.mas_left).with.offset(-Space);
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    [self.startLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.playBtn.mas_right).with.offset(Space);
        
        make.centerY.mas_equalTo(self.bottomView);
        
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    [self.endLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.rateBtn.mas_left).with.offset(-Space);
        
        make.centerY.mas_equalTo(self.bottomView);
        
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    
    //顶部view的设置
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.startLabel.mas_right).with.offset(1);
        
        
        make.centerY.mas_equalTo(self.bottomView);
        
        make.right.equalTo(self.endLabel.mas_left).with.offset(-1);
        make.height.mas_equalTo(25);
        
    }];
   
    
    [self.rePlaytbn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.lx_centerX);
        make.centerY.mas_equalTo(self.lx_centerY);
        
    }];
 
    
    [self.rateTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.offset(-40);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.width.mas_equalTo(50);
    }];
   
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.loadingView.lx_centerX = self.lx_width / 2;
    self.loadingView.lx_centerY = self.lx_height /2;
}
#pragma mark---setter---
-(void)setStartTime:(NSString *)startTime{
    
    _startTime = startTime;
    self.startLabel.text = _startTime;
}
-(void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    self.endLabel.text = _endTime;
}
-(void)setSlideValue:(CGFloat)slideValue{
    _slideValue = slideValue;
    self.slider.slideValue = _slideValue;

}
-(void)setCacheValue:(CGFloat)cacheValue{
    _cacheValue = cacheValue;
    self.slider.cacheValue = _cacheValue;
}
-(void)setPlayTitle:(NSString *)playTitle{
    _playTitle = playTitle;
    
    self.titleLabel.text = _playTitle;
}
-(void)setPlaceImage:(UIImage *)placeImage{
    _placeImage = placeImage;
    self.placeholdImageView.image = _placeImage;
}
#pragma mark---懒加载---
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor =[UIColor clearColor];
    }
    return _topView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView =[[UIView alloc]init];
        _bottomView.backgroundColor =[UIColor clearColor];

    }
    return _bottomView;
}

-(LxButton *)backBtn{
    if (!_backBtn) {
        _backBtn =[LxButton LXButtonNoFrameWithTitle:nil titleFont:nil Image:[UIImage LXPlayer_ImageName:@"返回"] backgroundImage:nil backgroundColor:nil titleColor:nil];
        _backBtn.enlargeSize = CGSizeMake(40, 20);
    }
    return _backBtn;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel =[UILabel LXLabelWithTextNoFrame:@"蝙蝠侠大战大灰狼" textColor:[UIColor hexStringToColor:@"ffffff"] backgroundColor:[UIColor clearColor] font:Font(15) textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

-(LxButton *)playBtn{
    if (!_playBtn) {
         _playBtn =[LxButton LXButtonNoFrameWithTitle:nil titleFont:nil Image:[UIImage LXPlayer_ImageName:@"pause"] backgroundImage:nil backgroundColor:nil titleColor:nil];
        [_playBtn setImage:[UIImage LXPlayer_ImageName:@"play"] forState:UIControlStateSelected];
        _playBtn.enlargeSize = CGSizeMake(30, 30);
    }
    return _playBtn;
}
-(UILabel *)startLabel{
    if (!_startLabel) {
        _startLabel =[UILabel LXLabelWithTextNoFrame:@"00:00" textColor:[UIColor hexStringToColor:@"ffffff"] backgroundColor:self.bottomView.backgroundColor font:Font(13) textAlignment:NSTextAlignmentCenter];
//        _startLabel.backgroundColor =[UIColor redColor];
    }
    return _startLabel;
}
-(UILabel *)endLabel{
    if (!_endLabel) {
        _endLabel =[UILabel LXLabelWithTextNoFrame:@"00:00" textColor:[UIColor hexStringToColor:@"ffffff"] backgroundColor:self.bottomView.backgroundColor font:Font(13) textAlignment:NSTextAlignmentCenter];
    }
    return _endLabel;
}

-(LxButton *)rateBtn{
    if (!_rateBtn) {
         _rateBtn =[LxButton LXButtonNoFrameWithTitle:@"x1.0" titleFont:Font(13) Image:nil backgroundImage:nil backgroundColor:self.bottomView.backgroundColor titleColor:[UIColor hexStringToColor:@"ffffff"]];
        [_rateBtn setTitle:@"x1.0" forState:UIControlStateNormal];
        _rateBtn.enlargeSize = CGSizeMake(50, 30);
    }
    return _rateBtn;
}

-(LxButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn =[LxButton LXButtonNoFrameWithTitle:nil titleFont:nil Image:[UIImage LXPlayer_ImageName:@"noScreen"] backgroundImage:nil backgroundColor:nil titleColor:nil];
        [_fullScreenBtn setImage:[UIImage LXPlayer_ImageName:@"fullScreen"] forState:UIControlStateSelected];
        _fullScreenBtn.enlargeSize = CGSizeMake(30, 30);
    }
    return _fullScreenBtn;
}
-(LxButton *)rePlaytbn{
    if (!_rePlaytbn) {
        _rePlaytbn =[LxButton LXButtonNoFrameWithTitle:nil titleFont:nil Image:[UIImage LXPlayer_ImageName:@"repeat_video"] backgroundImage:nil backgroundColor:nil titleColor:nil];
        _rePlaytbn.hidden = YES;
    }
    return _rePlaytbn;
}
-(LXSlider *)slider{
    if (!_slider) {
        _slider =[[LXSlider alloc]init];
        _slider.backgroundColor = self.bottomView.backgroundColor;
    }
    return _slider;
}
-(LXPlayLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[LXPlayLoadingView alloc]initWithFrame:CGRectMake(0, 0, 45, 45) animationDuration:1.5 strokeColor:[UIColor redColor]];
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

-(UIImageView *)placeholdImageView{
    if (!_placeholdImageView) {
        _placeholdImageView =[[UIImageView alloc]init];
        _placeholdImageView.userInteractionEnabled = YES;
    }
    return _placeholdImageView;
}
- (UITableView *)rateTableView
{
    if ((!_rateTableView)) {
        _rateTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rateTableView.delegate = self;
        _rateTableView.dataSource = self;
        _rateTableView.hidden = YES;
        _rateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rateTableView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
        [_rateTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _rateTableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    UILabel * textLB = [[UILabel alloc]init];
    textLB.text = [NSString stringWithFormat:@"x%@", self.rateArray[indexPath.row]];
    textLB.textAlignment = NSTextAlignmentCenter;
    textLB.backgroundColor = [UIColor clearColor];
    textLB.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:textLB];
    [textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(cell);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.rateBtn setTitle:[NSString stringWithFormat:@"x%@", self.rateArray[indexPath.row]] forState:UIControlStateNormal];
    if (self.RateChangeBlock) {
        self.RateChangeBlock([self.rateArray[indexPath.row] floatValue]);
    }
    tableView.hidden = YES;
}

// 隐藏顶部试图
-(void)hiddenTopView
{
    self.topView.hidden = YES;
}

@end
