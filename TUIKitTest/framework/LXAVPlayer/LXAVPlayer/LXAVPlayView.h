//
//  LXAVPlayView.h
//  LXPlayer
//
//  Created by chenergou on 2017/12/4.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXPlayModel;

@interface LXAVPlayView : UIView

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, LXPanDirection){
    LXPanDirectionHorizontalMoved, // 横向移动
    LXPanDirectionVerticalMoved    // 纵向移动
};

//是否可以设置为横屏
@property(nonatomic,assign)BOOL isLandScape;

//是否自动播放
@property(nonatomic,assign)BOOL isAutoReplay;

@property(nonatomic,strong)LXPlayModel          *currentModel;//当前模型

/*返回按钮的回调*/
@property(nonatomic,copy)void (^backBlock) (NSDictionary * info);

// 记录学习时长
@property (nonatomic, copy) void(^StudyTimeBlock)(double time);

// 进度
@property (nonatomic, copy) void(^CurrentTimeBlock)(int time);


/**销毁播放器*/
-(void)destroyPlayer;

- (NSDictionary *)getCurrentProgress;

- (void)seekToTimeWithDragedSeconds:(NSInteger )dragedSeconds;

- (void)addPlayerToFatherView:(UIView *)view;

// 隐藏顶部
-(void)hiddenTopView;

#pragma mark---播放
-(void)play;
#pragma mark---暂停---
-(void)pause;

- (void)backstop;

- (NSInteger)getPlayState;

- (float)getPlayRate;

@end
