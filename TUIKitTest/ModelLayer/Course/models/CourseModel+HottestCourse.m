//
//  CourseModel+HottestCourse.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "CourseModel+HottestCourse.h"

@implementation CourseModel (HottestCourse)

- (instancetype)initWithHosttestDicInfo:(NSDictionary *)dicInfo
{
    if (self = [super init]) {
        self.courseName = [dicInfo objectForKey:@"courseName"];
        if (self.courseName == nil) {
            self.courseName = [dicInfo objectForKey:@"liveName"];
        }
        if (self.courseName == nil) {
            self.courseName = @"";
        }
        self.name = @"";
        if (![[dicInfo objectForKey:@"name"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"name"]) {
            self.name = [dicInfo objectForKey:@"name"];
        }
        
        self.courseURLString = [UIUtility judgeStr:[dicInfo objectForKey:@"pullUrlRtmp"]];
        self.playback = [UIUtility judgeStr:[dicInfo objectForKey:@"videoUrl"]];
        self.teacherDetail = [UIUtility judgeStr:[dicInfo objectForKey:@"teacherIntro"]];
        self.livingDetail = [UIUtility judgeStr:[dicInfo objectForKey:@"intro"]];
        
        self.beginLivingTime = [UIUtility judgeStr:[dicInfo objectForKey:@"beginTime"]];
        
        self.endLivingTime = [UIUtility judgeStr:[dicInfo objectForKey:@"endTime"]];
        
       
        
        if (![[dicInfo objectForKey:@"coverImg"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"coverImg"]) {
            self.courseCover = [dicInfo objectForKey:@"coverImg"];
        }else
        {
            self.courseCover = @"";
        }
        
        self.courseID = [[dicInfo objectForKey:@"liveId"] intValue];
        
        self.coueseTeacherName = [dicInfo objectForKey:@"teacherName"];
        if ([self.coueseTeacherName isKindOfClass:[NSNull class]] || !self.coueseTeacherName) {
            self.coueseTeacherName = @"";
        }
        
        self.time = [dicInfo objectForKey:@"beginTime"];
        if ([self.time isKindOfClass:[NSNull class]] || !self.time) {
            self.time = @"";
        }
        
        
        self.teacherPortraitUrl = [dicInfo objectForKey:@"teacherAvatar"];
        if ([self.teacherPortraitUrl isKindOfClass:[NSNull class]] || !self.teacherPortraitUrl) {
            self.teacherPortraitUrl = @"";
        }
        
        NSNumber *sectionId = [dicInfo objectForKey:@"id"];
        if ([sectionId isKindOfClass:[NSNull class]] ) {
            sectionId = @0;
        }
        self.sectionId = sectionId.intValue;
        
       NSNumber *isSubscribe = [dicInfo objectForKey:@"isSubscribe"];
       if ([isSubscribe isKindOfClass:[NSNull class]] ) {
           isSubscribe = @0;
       }
       self.isSubscribe = isSubscribe.intValue;
        
        
        
        NSNumber *isFree = [dicInfo objectForKey:@"isFree"];
        if ([isFree isKindOfClass:[NSNull class]] ) {
            isFree = @0;
        }
        self.isFree = isFree.intValue;
        
         
        // 直播权限，回放权限，下载权限，现在统一都是一个
        
        if ([[dicInfo objectForKey:@"isBuyed"] intValue] == 1) {
            self.haveJurisdiction = 1;
            self.isBack = 1;
            self.isDownload = 1;
        }else if ([[dicInfo objectForKey:@"isBuyed"] intValue] == 0 && self.isFree == 1)
        {
            self.haveJurisdiction = 1;
            self.isBack = 1;
            self.isDownload = 1;
        }else
        {
            self.haveJurisdiction = 0;
            self.isBack = 0;
            self.isDownload = 0;
        }
        
//        NSNumber *isBack = [dicInfo objectForKey:@"isBack"];
//        if ([isBack isKindOfClass:[NSNull class]] ) {
//            isBack = @0;
//        }
//        self.isBack = isBack.intValue;
//
//        NSNumber * isDownload = [dicInfo objectForKey:@"isDownload"];
//        if ([[dicInfo objectForKey:@"isDownload"] isKindOfClass:[NSNull class]]) {
//            isDownload = @0;
//        }
//        self.isDownload = isDownload.intValue;
        
        self.chatRoomId = @"";
        if (![[dicInfo objectForKey:@"liveRoomId"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"liveRoomId"]) {
            self.chatRoomId = [NSString stringWithFormat:@"%@", [dicInfo objectForKey:@"liveRoomId"]];
        }
        
        self.assistantId = @"";
        if (![[dicInfo objectForKey:@"assistantId"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"assistantId"]) {
            self.assistantId = [dicInfo objectForKey:@"assistantId"];
        }
        
        self.lastTime = @"";
        if (![[dicInfo objectForKey:@"lastTime"] isKindOfClass:[NSNull class]] && [dicInfo objectForKey:@"lastTime"]) {
            self.lastTime = [dicInfo objectForKey:@"lastTime"];
        }
        
        self.price = [[dicInfo objectForKey:@"price"] doubleValue];
        if ([[dicInfo objectForKey:@"price"] isKindOfClass:[NSNull class]]) {
            self.price = 0;
        }
        
        self.oldPrice = [[dicInfo objectForKey:@"oldPrice"] intValue];
        if ([[dicInfo objectForKey:@"oldPrice"] isKindOfClass:[NSNull class]]) {
            self.oldPrice = 0;
        }
        
        self.playState = 0;
        // 1.根据livingstate判断是否正在直播
        if ([[dicInfo objectForKey:@"isLiving"] intValue] == 1) {
            self.playState = 2;// 直播中
        }else
        {
            
            // 2.根据playBack是否优质判断是否播放完毕,
            if ([[UIUtility judgeStr:[dicInfo objectForKey:@"videoUrl"]] length] > 0) {
                self.playState = 3;
            }else
            {
                // 3.无playBack，根据结束时间判断回放是否正在上传
                if ([self isEndLivingTimeEarly:[dicInfo objectForKey:@"beginTime"]]) {
                    self.playState = 3;
                }else
                {
                    //4. 直播还未开始 判断是否已预约
                    
                    if ([[dicInfo objectForKey:@"isSubscribe"] intValue] == 1) {
                        self.playState = 1;
                    }else
                    {
                        
                        self.playState = 0;
                    }
                }
            }
        }
        
        
    }
    return self;
}


- (BOOL)isEndLivingTimeEarly:(NSString *)endLivingTime
{
    NSDate * nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 截止时间字符串格式
    NSString * expireDateStr = endLivingTime;
    //    expireDateStr = @"2017/9/14 16:25:00";
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    if (dateCom.second < 0) {
        return YES;
    }
    
    return NO;;
}

@end
