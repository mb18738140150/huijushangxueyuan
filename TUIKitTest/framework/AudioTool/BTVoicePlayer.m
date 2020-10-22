//
//  BTVoicePlayer.m
//  road
//
//  Created by stonemover on 2017/6/28.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import "BTVoicePlayer.h"

static BTVoicePlayer * selfPlayer;

typedef void(^PlayFinishBlock)(AVAudioPlayer * player,BOOL flag);
@interface BTVoicePlayer()<AVAudioPlayerDelegate>

//@property (nonatomic, strong) AVAudioPlayer * player;
@property (nonatomic, copy)PlayFinishBlock finishBlock;
@property (nonatomic, strong)AVPlayer * player;
@property (nonatomic, strong)AVPlayer * localPlayer;
@property (nonatomic, strong)id timeObserve;

@property (nonatomic, strong)id localTimeObserve;

@end

@implementation BTVoicePlayer

+(instancetype)share{
    if (!selfPlayer) {
        selfPlayer=[BTVoicePlayer new];
    }
    
    return selfPlayer;
}

// 播放本地录音
-(void)play:(NSString*)url{
    
    NSError * error=nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    NSURL * urlResult=[NSURL fileURLWithPath:url];
    
    AVPlayerItem *currentPlayerItem = [AVPlayerItem playerItemWithURL:urlResult];
    self.localPlayer = [[AVPlayer alloc] initWithPlayerItem:currentPlayerItem];
    
    self.localPlayer.volume = 1.0f;
    
    [self.localPlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localPlaybackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.localPlayer currentItem]];
    
    __weak typeof(self)weakSelf = self;
    self.localTimeObserve = [self.localPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(currentPlayerItem.duration);
        if (current) {
            CGFloat progress = current / total;
            //            weakSelf.playTime = [NSString stringWithFormat:@"%.f",current];
            //            weakSelf.playDuration = [NSString stringWithFormat:@"%.2f",total];
            NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
            [infoDic setObject:@(progress) forKey:@"progress"];
            [infoDic setObject:[weakSelf getTimeStr:total] forKey:@"totalTime"];
            [infoDic setObject:@(current) forKey:@"currentTime"];
            if (weakSelf.getMusicProgressBlock) {
                weakSelf.getMusicProgressBlock(infoDic);
            }
        }
    }];
    
}

// 播放在线音乐
- (void)playLine:(NSString*)url
{
    if (self.timeObserve) {
        [_player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    NSError * error=nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    
    NSMutableDictionary * headers = [NSMutableDictionary dictionary];
    [headers setObject:@"https://h5.luezhi.com" forKey:@"Referer"];
    AVAsset * asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
    
    AVPlayerItem *currentPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [[AVPlayer alloc] initWithPlayerItem:currentPlayerItem];
    
    self.player.volume = 1.0f;
    
    [self.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    
        __weak typeof(self)weakSelf = self;
        self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds(currentPlayerItem.duration);
            if (current) {
                CGFloat progress = current / total;
    //            weakSelf.playTime = [NSString stringWithFormat:@"%.f",current];
    //            weakSelf.playDuration = [NSString stringWithFormat:@"%.2f",total];
                NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
                [infoDic setObject:@(progress) forKey:@"progress"];
                [infoDic setObject:[weakSelf getTimeStr:total] forKey:@"totalTime"];
                [infoDic setObject:@(current) forKey:@"currentTime"];
                if (weakSelf.getMusicProgressBlock) {
                    weakSelf.getMusicProgressBlock(infoDic);
                }
            }
        }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//
//        NSString * timeStr = [self getMusicLength:url];
//        if (self.getMusicLengthBlock) {
//            self.getMusicLengthBlock(timeStr);
//        }
//    });
    
}

- (NSString *)getMusicLength:(NSString *)url;
{
    CMTime audioDuration = [self.player.currentItem duration];
    
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    NSLog(@"self.totalTimeLB.text =  %.1f", audioDurationSeconds);
    
    return [self getTimeStr:audioDurationSeconds];
}

- (NSString *)getTimeStr:(CGFloat)time
{
    int minutes = (int)time / 60;
    int second = (int)time % 60;
    NSString * minutesStr = @"";
    NSString * secondStr = @"";
    if (minutes > 9) {
        minutesStr = [NSString stringWithFormat:@"%d", minutes];
    }else
    {
        minutesStr = [NSString stringWithFormat:@"0%d", minutes];
    }
    if (second > 9) {
        secondStr = [NSString stringWithFormat:@"%d", second];
    }else
    {
        secondStr = [NSString stringWithFormat:@"0%d", second];
    }
    return [NSString stringWithFormat:@"%@:%@", minutesStr, secondStr];
}

-(void)stop{
    [self.player pause];
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
}
-(void)localstop
{
    [self.localPlayer pause];
    [self.localPlayer replaceCurrentItemWithPlayerItem:nil];

}
-(void)playbackFinished:(NSNotification *)notification{
    if (self.timeObserve) {
        [_player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [self.player replaceCurrentItemWithPlayerItem:nil];
    NSLog(@"开始下一首");
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeMusic)]) {
        [self.delegate changeMusic];
    }
}

- (void)localPlaybackFinished:(NSNotification *)notification{

    NSLog(@"开始下一首");
    if (self.finishBlock) {
        self.finishBlock(self.localPlayer, YES);
    }
}

- (void)playContinu
{
    [self.player play];
}

- (void)playLocalContinu
{
    [self.localPlayer play];
}

- (void)pause
{
    [self.player pause];
}
- (void)localpause
{
    [self.localPlayer pause];
}
- (void)seekToTime:(CGFloat)value
{
    CMTime audioDuration = [self.player.currentItem duration];
    CGFloat time = value * CMTimeGetSeconds(audioDuration);
    [self.player seekToTime:CMTimeMake(time, 1)];
}

- (BOOL)isPlaying
{
    if(_player.rate == 1.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isHavePlayerItem
{
    if (self.player.currentItem) {
        return YES;
    }
    return NO;
}
- (BOOL)isHaveLocalPlayerItem
{
    if (self.localPlayer.currentItem) {
        return YES;
    }
    return NO;
}
- (BOOL)isLocalPlaying
{
    if(_localPlayer.rate == 1.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isHavePlayContent
{
    if (self.player.currentItem) {
        return YES;
    }else
    {
        return NO;
    }
}


#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.finishBlock(player, flag);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}

- (void)audioPlayerDidFinish:(void (^)(AVAudioPlayer * player,BOOL flag))playFinishBlock
{
    self.finishBlock = playFinishBlock;
}

@end
