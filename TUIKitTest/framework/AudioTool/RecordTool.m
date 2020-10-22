//
//  RecordTool.m
//  RecordTool
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 JIABIANWANGLUO. All rights reserved.
//

#import "RecordTool.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#include "lame.h"

@interface RecordTool()

@property (nonatomic, strong) AVAudioRecorder * recorder;

@property (nonatomic, strong)NSTimer *timer;

//@property (nonatomic, assign)CGFloat length;
@end

@implementation RecordTool
DEF_SINGLETON(RecordTool)

- (void)resetproperty
{
    if (!self.m4aSavePath) {
        NSString * m4aName = @"hecheng";
        NSString * m4aPath = [NSString stringWithFormat:@"%@/%@.m4a",[self getCacheVoice],m4aName];
        self.m4aSavePath = m4aPath;
    }
    
    if (!self.convertSavePath) {
        NSString * convertName = @"hecheng";
        NSString * convertPath = [NSString stringWithFormat:@"%@/%@.wav",[self getCacheVoice],convertName];
        self.convertSavePath = convertPath;
    }
}

- (BOOL)isRecording
{
    return self.recorder.isRecording;
}

//开始录音
-(void)startRecordVoice{
    //初始化默认参数
    NSString * time = [self getCurrentTime:@"YYYYMMddHHmmss"];
    self.savePath = [NSString stringWithFormat:@"%@/%@.wav",[self getCacheVoice],time];
    
    NSString * mp3Name = [self getCurrentTime:@"YYYYMMddHHmmss"];
    NSString * mp3Path = [NSString stringWithFormat:@"%@/%@.mp3",[self getCacheVoice],mp3Name];
    self.mp3SavePath = mp3Path;
    
    if (!self.recordConfigDic) {
        self.recordConfigDic = [self getConfig];
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    NSError *error = nil;
    NSURL * url = [NSURL URLWithString:self.savePath];
    self.recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:self.recordConfigDic error:&error];
    self.recorder.meteringEnabled = YES;
    self.recorder.meteringEnabled = YES;
    [self.recorder record];
    self.timer.fireDate=[NSDate distantPast];
}

// 暂停录音
-(void)pauseRecordVoice
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([self.recorder isRecording]) {
        [self.recorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

// 恢复录音
- (void)recoverRecord
{
    if (![self.recorder isRecording]) {
        [self.recorder record];
        self.timer.fireDate=[NSDate distantPast];
    }
}

//停止录音
-(void)stopRecordVoice{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        self.timer.fireDate=[NSDate distantFuture];
        [SoftManager shareSoftManager].length = 0.0;
    }
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)audioPowerChange{
    [SoftManager shareSoftManager].length += 0.1;
    NSLog(@"[SoftManager shareSoftManager].length = %.1f", [SoftManager shareSoftManager].length);
}

//获取录音参数配置
- (NSDictionary *)getConfig{
    
    NSDictionary *result = nil;
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    
    result = [NSDictionary dictionaryWithDictionary:recordSetting];
    return result;
}

- (void)convertWavToMp3:(NSString*)wavFilePath withSavePath:(NSString*)savePath {
    @try {
        int read, write;
        
        FILE *pcm = fopen([wavFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024,SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([savePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        
    }
    @finally {

    }
    
}


#pragma mark ===== 转换成MP3文件=====
- (void)audio_PCMtoMP3With:(NSString *)sourcepath  withSavePath:(NSString*)savePath
{
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //NSString *mp3FileName = [strUrl lastPathComponent];
    //mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [strUrl stringByAppendingPathComponent:@"lll.mp3"];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([sourcepath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        strUrl = mp3FilePath;
//        _saveModel.speakUrl=[NSURL URLWithString:strUrl];
        NSLog(@"MP3生成成功: %@",strUrl);
    }
    
}

#pragma mark - 音频合成
/*
 其实AVFoundation框架提供音视频剪辑,合成等功能. 我在这里仅仅介绍下音频合并,希望能起到抛砖引玉的效果.
 这里需要使用到三个核心类
 AVMutableComposition: 用于对音视频轨道的添加和删除
 AVMutableCompositionTrack: 代表着一个音频/视频 的轨道,可以添加音频/视频资源
 AVAssetExportSession:用于导出处理后的音视频文件.
 
 步骤
 创建AVMutableComposition
 给AVMutableComposition 添加一个新音频的轨道,并返回音频轨道
 循环添加需要的音频资源
 导出合并的音频文件
 */

/// 合并音频文件
/// @param sourceURLs 需要合并的多个音频文件
/// @param toURL      合并后音频文件的存放地址 默认为 m4aSavePath
/// 注意:导出的文件是:m4a格式的.
- (void) sourceURLs:(NSArray *) sourceURLs composeToURL:(NSURL *) toURL completed:(void (^)(NSError *error)) completed
{
    
    NSAssert(sourceURLs.count > 1,@"源文件不足两个无需合并");
    
    // 之前有合成文件先删除
    if ([[NSFileManager defaultManager] fileExistsAtPath:[toURL path]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[toURL path] error:nil];
    }
    
    //  1. 创建`AVMutableComposition `,用于合并所有的音视频文件
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    
    //  2. 给`AVMutableComposition` 添加一个新音频的轨道,并返回音频轨道
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //  3. 循环添加需要的音频资源
    
    //  3.1 音频插入的开始时间,用于记录每次添加音频文件的开始时间
    CMTime beginTime = kCMTimeZero;
    //  3.2 用于记录错误的对象
    NSError *error = nil;
    //  3.3 循环添加音频资源
    for (NSURL *sourceURL in sourceURLs) {
        //      3.3.1 音频文件资源
        AVURLAsset  *audioAsset = [[AVURLAsset alloc]initWithURL:sourceURL options:nil];
        //      3.3.2 需要合并的音频文件的播放的时间区间
        CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
        //      3.3.3 添加音频文件
        //      参数说明:
        //      insertTimeRange:源录音文件的的区间
        //      ofTrack:插入音频的内容
        //      atTime:源音频插入到目标文件开始时间
        //      error: 插入失败记录错误
        //      返回:YES表示插入成功,`NO`表示插入失败
        BOOL success = [compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:beginTime error:&error];
        //      3.3.4 如果插入失败,打印插入失败信息
        if (!success) {
            NSLog(@"插入音频失败: %@",error);
            completed(error);
            return;
        }else
        {
            NSLog(@"插入成功一个");
        }
        //     3.3.5  记录下次音频文件插入的开始时间
        beginTime = CMTimeAdd(beginTime, audioAsset.duration);
    }
    
    //  4. 导出合并的音频文件
    //  4.0 创建一个导入M4A格式的音频的导出对象
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    //  4.2 设置导入音视频的URL
    assetExport.outputURL = toURL;
    //  导出音视频的文件格式
    assetExport.outputFileType = @"com.apple.m4a-audio";
    //  4.3 导入出
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        //      4.5 分发到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(assetExport.error);
        });
    }];
}


#pragma mark - m4a转wav
- (void)convetM4aToWav:(NSURL *)originalUrl  destUrl:(NSURL *)destUrl  completed:(void (^)(NSError *error)) completed
{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[destUrl path]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[destUrl path] error:nil];
    }
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:originalUrl options:nil];
    
    //读取原始文件信息
    NSError *error = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        return;
    }
    
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                              audioSettings: nil];
    if (![assetReader canAddOutput:assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return;
    }
    [assetReader addOutput:assetReaderOutput];
    
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:destUrl
                                                          fileType:AVFileTypeCoreAudioFormat
                                                             error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        return;
    }
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:outputSettings];
    if ([assetWriter canAddInput:assetWriterInput]) {
        [assetWriter addInput:assetWriterInput];
    } else {
        NSLog (@"can't add asset writer input... die!");
        return;
    }
    
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime:startTime];
    
    __block UInt64 convertedByteCount = 0;
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^
     {
         while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 NSLog (@"appended a buffer (%zu bytes)",
                        CMSampleBufferGetTotalSampleSize (nextBuffer));
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 
                 
             } else {
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWritingWithCompletionHandler:^{
                     
                 }];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:[destUrl path]
                                                       error:nil];
                 NSLog (@"FlyElephant %lld",[outputFileAttributes fileSize]);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     completed(error);
                 });
                 
//                 [assetReader release];
//                 [assetReaderOutput release];
//                 [assetWriter release];
//                 [assetWriterInput release];
//                 [exportPath release];
                 
                 break;
             }
         }
         
     }];
}


#pragma mark - 工具方法

- (CGFloat)timelenght
{
    // 获取音频时长
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.savePath] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

- (CGFloat)length
{
    return [SoftManager shareSoftManager].length;
}

// 系统时间
- (NSString*)getCurrentTime:(NSString*)formatter{
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

// 文件操作
- (NSString*)getCacheVoice{
    NSString * voice=[NSString stringWithFormat:@"%@/voice",[self getCachePath]];
    if (![self isFileExit:voice]) {
        [self createPath:voice];
    }
    return voice;
}

- (NSString*)getCachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}


- (BOOL)isFileExit:(NSString*)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


- (void)deleteFile:(NSString*)path{
    if ([self isFileExit:path]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"删除%@出错:%@",path,error.domain);
        }
    }
}


- (void)createPath:(NSString*)path{
    if (![self isFileExit:path]) {
        NSFileManager * fileManager=[NSFileManager defaultManager];
        NSString * parentPath=[path stringByDeletingLastPathComponent];
        if ([self isFileExit:parentPath]) {
            NSError * error;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:path attributes:nil error:&error];
        }else{
            [self createPath:parentPath];
            [self createPath:path];
        }
        
    }
}
@end
