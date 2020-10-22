//
//  RecordTool.h
//  RecordTool
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 JIABIANWANGLUO. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef AS_SINGLETON

#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;
#undef DEF_SINGLETON

#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
    return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
    static dispatch_once_t once; \
    static __class * __singleton__; \
    dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
    return __singleton__; \
} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t once; \
    static __class * __singleton__; \
    dispatch_once(&once, ^{ __singleton__ = [super allocWithZone:zone]; } ); \
    return __singleton__; \
}


/**
 录音工具类
 */
@interface RecordTool : NSObject
AS_SINGLETON(RecordTool)

//文件存储的路径,需要带文件名和文件后缀,如果没有会这是默认值
@property (nonatomic, strong) NSString * savePath;
// 转换成MP3文件的存储路径
@property (nonatomic, strong) NSString * mp3SavePath;
//录音配置字典,如果不设置将会默认值
@property (nonatomic, strong) NSDictionary * recordConfigDic;

// 音频合成后m4a存储路径
@property (nonatomic, strong)NSString * m4aSavePath;
@property (nonatomic, strong)NSString * convertSavePath;// 合成文件转化后的wav文件存储路径


// 录音时长
- (CGFloat)timelenght;

- (CGFloat)length;

- (BOOL)isRecording;

// 开始录音
-(void)startRecordVoice;
// 暂停录音
-(void)pauseRecordVoice;

// 恢复录音
- (void)recoverRecord;

// 结束录音
-(void)stopRecordVoice;

// wav格式转换MP3
- (void)convertWavToMp3:(NSString*)wavFilePath withSavePath:(NSString*)savePath;
// pcm格式转换MP3
- (void)audio_PCMtoMP3With:(NSString *)sourcepath  withSavePath:(NSString*)savePath;

- (void)resetproperty;

// 录音合成m4a
/// 合并音频文件
/// @param sourceURLs 需要合并的多个音频文件
/// @param toURL      合并后音频文件的存放地址
/// 注意:导出的文件是:m4a格式的.
- (void) sourceURLs:(NSArray *) sourceURLs composeToURL:(NSURL *) toURL completed:(void (^)(NSError *error)) completed;


// m4a格式转换wav
- (void)convetM4aToWav:(NSURL *)originalUrl  destUrl:(NSURL *)destUrl completed:(void (^)(NSError *error)) completed;


@end
