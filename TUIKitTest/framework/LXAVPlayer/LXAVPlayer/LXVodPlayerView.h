//
//  LXVodPlayerView.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/11.
//

#import <UIKit/UIKit.h>
@class LXPlayModel;

NS_ASSUME_NONNULL_BEGIN

@interface LXVodPlayerView : UIView

//是否可以设置为横屏
@property(nonatomic,assign)BOOL isLandScape;

//是否自动播放
@property(nonatomic,assign)BOOL isAutoReplay;

@property(nonatomic,strong)LXPlayModel          *currentModel;//当前模型

/*返回按钮的回调*/
@property(nonatomic,copy)void (^backBlock) (NSDictionary * info);

// 记录学习时长
@property (nonatomic, copy) void(^StudyTimeBlock)(double time);

@property (nonatomic, copy)NSString * playURL;

/**销毁播放器*/
-(void)destroyPlayer;

- (NSDictionary *)getCurrentProgress;

- (void)seekToTimeWithDragedSeconds:(NSInteger )dragedSeconds;

#pragma mark---播放
-(void)play;

- (void)startPlay;
#pragma mark---暂停---
-(void)pause;

- (void)backstop;

- (NSInteger)getPlayState;

@end

NS_ASSUME_NONNULL_END
