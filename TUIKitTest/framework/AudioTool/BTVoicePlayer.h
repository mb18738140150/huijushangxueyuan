//
//  BTVoicePlayer.h
//  road
//
//  Created by stonemover on 2017/6/28.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol ChangeMusicProtocol <NSObject>

// 播放完毕切换下一首
- (void)changeMusic;

@end

@interface BTVoicePlayer : NSObject

- (BOOL)isPlaying;
- (BOOL)isHavePlayerItem;
- (BOOL)isHaveLocalPlayerItem;
- (BOOL)isLocalPlaying;
+(instancetype)share;

-(void)play:(NSString*)url;// 播放本地录音
- (void)playLine:(NSString*)url;// 播放在线音乐

-(void)stop;
- (void)pause;

- (void)localpause;

-(void)localstop;

- (void)playContinu;
- (void)playLocalContinu;

- (void)seekToTime:(CGFloat)value;
- (BOOL)isHavePlayContent;

@property (nonatomic, copy)void(^getMusicLengthBlock)(NSString * lengthStr);

@property (nonatomic, copy)void(^getMusicProgressBlock)(NSDictionary * infoDic);

@property (nonatomic, assign)id<ChangeMusicProtocol>delegate;

- (void)audioPlayerDidFinish:(void (^)(AVAudioPlayer * player,BOOL flag))playFinishBlock;

- (NSString *)getMusicLength:(NSString *)url;

@end
