//
//  HttpUploaderManager.m
//  Accountant
//
//  Created by aaa on 2017/3/15.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HttpUploaderManager.h"
#import "AFNetworking.h"
#import "NetMacro.h"
#import "DateUtility.h"
#import "CommonMacro.h"

@implementation HttpUploaderManager

+ (instancetype)sharedManager
{
    static HttpUploaderManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[HttpUploaderManager alloc] init];
    });
    return __manager__;
}

- (void)uploadImage:(NSData *)imageData withProcessDelegate:(id)processObject
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/json"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"text/javascript"];
    [contentTypes addObject:@"text/xml"];
    [contentTypes addObject:@"image/*"];

    manager.responseSerializer.acceptableContentTypes = contentTypes;

    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求不使用AFN默认转换,保持原有数据
    
    
    NSDictionary * paramete = @{};
    NSString * aesStr = [UIUtility getAES_Str:paramete];
    
    NSString * sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
    NSMutableDictionary * headDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"token":[NSString stringWithFormat:@"%@", aesStr]}];
    if (sessionId) {
        if (sessionId.length > 0) {
            sessionId = [NSString stringWithFormat:@"PHPSESSID=%@", sessionId];
            
            [headDic setValue:sessionId forKey:@"Cookie"];
        }
    }
    
    [manager POST:kUploadRootUrl parameters:nil headers:headDic  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        /**
         *  压缩图片然后再上传(1.0代表无损 0~~1.0区间)
         */
        
        // UIImagePNGRepresentation(image)
        
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"iii" mimeType:@"image/jpeg"];
        
    }  progress:^(NSProgress * _Nonnull uploadProgress) {

        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"%.2lf%%", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"[responseObject class] = %@", [responseObject class]);
        
        NSLog(@"%@", responseObject);
        
        [processObject didUploadSuccess:[responseObject objectForKey:@"data"]];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [processObject didUploadFailed:@"图片上传失败"];
    }];
}

- (NSString *)getCurrentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970]*1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (void)uploadImageInfo:(NSDictionary *)imageInfo andUploadType:(NSString *)uploadType withProcessDelegate:(id)processObject
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"application/json"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"text/javascript"];
    [contentTypes addObject:@"text/xml"];
    [contentTypes addObject:@"image/*"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求不使用AFN默认转换,保持原有数据
    NSString * tokenString = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:Token]];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"access-token"];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"DeviceId"];// 设备id
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"TerminalSourceVersion"];// 版本号
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"TerminalSource"];// 应用id
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应不使用AFN默认转换,保持原有数据
    
    
    NSString * URLString = [NSString stringWithFormat:@"%@?%@", kUploadRootUrl,uploadType];
    [manager POST:URLString parameters:nil headers:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /**
         *  压缩图片然后再上传(1.0代表无损 0~~1.0区间)
         */
        NSData *data = [imageInfo objectForKey:@"data"];
        
        
        NSString *fileName = [imageInfo objectForKey:@"fileName"];
        
        [formData appendPartWithFileData:data name:@"" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"[responseObject class] = %@ *** \n %@", [responseObject class],responseObject);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [processObject didUploadSuccess:dic];
        NSLog(@"%@", [dic description]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [processObject didUploadFailed:@"图片上传失败"];
    }];
}


@end
