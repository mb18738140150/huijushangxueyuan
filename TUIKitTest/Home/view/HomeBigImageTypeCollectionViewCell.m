//
//  HomeBigImageTypeCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeBigImageTypeCollectionViewCell.h"
#import "CountDown.h"

@interface HomeBigImageTypeCollectionViewCell()


@property (nonatomic, assign)NSInteger      day;
@property (nonatomic, assign)NSInteger      hour;
@property (nonatomic, assign)NSInteger      minute;
@property (nonatomic, assign)NSInteger      sec;
@property (nonatomic, strong)UILabel        *timeLB;

@property (nonatomic, strong)NSTimer        *timer;
@property (strong, nonatomic)  CountDown *countDown;

@property (nonatomic, assign)BOOL isStartTimeDown;


@end

@implementation HomeBigImageTypeCollectionViewCell


- (void)refreshUIWith:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    self.infoDic = infoDic;
    
    if (self.timer) {
        [self timerInvalidate];
    }
    
    
    // (self.hd_width - 35) / 2 + 126
    CGFloat topSpace = 0;
    if (self.isOneCourse) {
        topSpace = 20;
    }
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, (self.hd_width - 35) / 2 + 126 + topSpace)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    // 直播大图
    self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, topSpace, self.hd_width - 35, (self.hd_width - 35) / 2)];
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@"placeholdImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    [self.backView addSubview:self.iconImageVIew];
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.iconImageVIew.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = self.iconImageVIew.bounds;
    shapLayer.path = bezierpath.CGPath;
    [self.iconImageVIew.layer setMask: shapLayer];
    
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageVIew.hd_width - 220, _iconImageVIew.hd_height - 25, 210, 20)];
    self.timeLB.textColor = UIColorFromRGB(0xffffff);
    self.timeLB.font = kMainFont;
    self.timeLB.textAlignment = NSTextAlignmentRight;
    [self.iconImageVIew addSubview:self.timeLB];
    self.timeLB.attributedText = [self getTimeWith:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"begin_timestamp"]]];
    self.timeLB.hidden = YES;
    
    // 直播状态
    self.livingStateView = [[LivingStateView alloc]initWithFrame:CGRectMake(5, self.iconImageVIew.hd_height - 25, 100, 20)];
    if ([infoDic objectForKey:@"topic_status"])
    {
        // topic_status 1.直播中 2.未开始 3.已结束
        int livingStatus = [[infoDic objectForKey:@"topic_status"] intValue];
        switch (livingStatus) {
            case 1:
            {
                self.livingStateView.frame = CGRectMake(5, self.iconImageVIew.hd_height - 25, 100, 20);
                self.livingStateView.livingState = HomeLivingStateType_living;
                
            }
                break;
            case 2:
            {
                self.livingStateView.livingState = HomeLivingStateType_noStart;
                [self startTimeCountDown];
                self.timeLB.hidden = NO;
            }
                break;
            case 3:
            {
                self.livingStateView.livingState = HomeLivingStateType_end;
            }
                break;
                
            default:
                break;
        }
    }
    [self.iconImageVIew addSubview:self.livingStateView];
    
    CGFloat seperateWidth = 10;
    
    // title
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageVIew.hd_x , CGRectGetMaxY(self.iconImageVIew.frame) + seperateWidth, self.backView.hd_width - 35, 22.5)];
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = [UIFont boldSystemFontOfSize:16];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"title"]];
    [self.backView addSubview:self.titleLB];
    
    // teacher info
    NSDictionary * teacherInfo = [infoDic objectForKey:@"author"];
    
    NSString * teacherStr = [NSString stringWithFormat:@"讲师：%@",[teacherInfo objectForKey:@"nickname"]];
    CGFloat width = [teacherStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.width;
    
    CGFloat bachWidth = width + 24 + 20;
    
    UIView * teacherBackView = [[UIView alloc]initWithFrame:CGRectMake(17.5, CGRectGetMaxY(self.titleLB.frame) + seperateWidth, bachWidth, 24)];
    teacherBackView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    teacherBackView.layer.cornerRadius = teacherBackView.hd_height / 2;
    teacherBackView.layer.masksToBounds = YES;
    [self.backView addSubview:teacherBackView];
    
    self.teacherIconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.teacherIconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[teacherInfo objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    self.teacherIconImageVIew.layer.cornerRadius = self.teacherIconImageVIew.hd_height / 2;
    self.teacherIconImageVIew.layer.masksToBounds = YES;
    [teacherBackView addSubview:self.teacherIconImageVIew];
    
    self.teacherNameLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.teacherIconImageVIew.frame) + 10, 0, width + 5, 24)];
    self.teacherNameLB.text = teacherStr;
    self.teacherNameLB.textColor = UIColorFromRGB(0x666666);
    self.teacherNameLB.font = kMainFont_12;
    [teacherBackView addSubview:self.teacherNameLB];
    
    // price
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(_backView.hd_width - 165, teacherBackView.hd_y, 150, 20)];
    self.priceLB.font = kMainFont_16;
    self.priceLB.textColor = UIColorFromRGB(0xCCA95D);
    self.priceLB.textAlignment = NSTextAlignmentRight;
    [self.backView addSubview:self.priceLB];
    self.priceLB.text = [NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, [infoDic objectForKey:@"show_paymoney"]];
    
//    NSString * oldStr = [self getOldStrWithSource1:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] andSource2:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"off_paymoney"]]];
//    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
//    NSMutableAttributedString * NewStr = [[NSMutableAttributedString alloc]initWithString:oldStr];
//
//    [NewStr addAttributes:attribute range:NSMakeRange([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] length]+ 1, oldStr.length - [[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"show_paymoney"]] length] - 1)];
//    self.priceLB.attributedText = NewStr;
    
    // joinBtn
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(self.backView.hd_width - 97.5, CGRectGetMaxY(self.iconImageVIew.frame) + 66.5, 80, 30);
    [self.applyBtn setTitle:@"立即进入" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0x2A75ED) forState:UIControlStateNormal];
    self.applyBtn.backgroundColor = [UIColor whiteColor];
    self.applyBtn.layer.cornerRadius = self.applyBtn.hd_height / 2;
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.borderColor = UIColorFromRGB(0x2A75ED).CGColor;
    self.applyBtn.layer.borderWidth = 1;
    self.applyBtn.titleLabel.font = kMainFont_12;
//    [self.backView addSubview:self.applyBtn];
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];

    int topic_type = [[infoDic objectForKey:@"topic_type"] intValue];
    if (topic_type == 3) {
        self.priceLB.text = @"加密";
    }
    
    if ([[teacherInfo allKeys] count] == 0) {
        teacherBackView.hidden = YES;
        self.priceLB.hd_x = teacherBackView.hd_x;
        self.priceLB.textAlignment = NSTextAlignmentLeft;
    }
    
}


- (NSMutableAttributedString *)getAttributeStringWithBegainStr:(NSString *)begainStr andContent:(NSString *)content
{
    NSString * str = [NSString stringWithFormat:@"%@%@", begainStr, content];
    NSDictionary * attribute = @{NSFontAttributeName:kMainFont_12,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)};
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mStr addAttributes:attribute range:NSMakeRange(0, begainStr.length)];
    return mStr;
}

- (void)applyAction
{
    if (self.applyBlock) {
        self.applyBlock(self.infoDic);
    }
}
- (NSString *)getOldStrWithSource1:(NSString *)str1 andSource2:(NSString *)str2
{
    if (str2.length == 0) {
        return [NSString stringWithFormat:@"￥%@", str1];
    }else
    {
        return [NSString stringWithFormat:@"￥%@￥%@", str1,str2];
    }
}


- (void)startTimeCountDown
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)timeCountDown
{
    __weak typeof(self)weakSelf = self;
    
    weakSelf.sec--;
    if (weakSelf.sec < 0) {
        weakSelf.minute--;
        
        if (weakSelf.minute<0) {
            weakSelf.hour--;
            if (weakSelf.hour <0) {
                weakSelf.day--;
                if (weakSelf.day < 0) {
                    weakSelf.day = 0;
                    weakSelf.hour = 0;
                    weakSelf.minute = 0;
                    weakSelf.sec = 0;
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                    if (weakSelf.livingCourseStartBlock) {
                        weakSelf.livingCourseStartBlock(@{});
                    }
                    
                }else
                {
                    weakSelf.hour = 23;
                    weakSelf.minute = 59;
                    weakSelf.sec = 59;
                }
            }else
            {
                weakSelf.minute = 59;
                weakSelf.sec = 59;
            }
        }else
        {
            weakSelf.sec = 59;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.timeLB.attributedText = [weakSelf getTimeStrWithday:weakSelf.day andHour:weakSelf.hour andMinute:weakSelf.minute andSecond:weakSelf.sec];
    });
}

- (void)timerInvalidate
{
    [self.timer invalidate];
    self.timer = nil;
}

- (NSMutableAttributedString *)getTimeWith:(NSString *)timeStr
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:myDate options:0];
    
    self.day = dateCom.month * 30  + dateCom.day;
    self.hour = dateCom.hour;
    
    self.minute = dateCom.minute;
    self.sec = dateCom.second;
    if (_day <= 0) {
        _day = 0;
    }
    
    if (_hour <= 0) {
        _hour = 0;
    }
    _minute--;
    if (_minute <= 0) {
        _minute = 0;
    }
    
    if (_sec <= 0) {
        _sec = 0;
    }
    
    return [self getTimeStrWithday:self.day andHour:_hour andMinute:_minute andSecond:_sec];
}

- (NSAttributedString *)getTimeStrWithday:(NSInteger)day andHour:(NSInteger)hour andMinute:(NSInteger)minute andSecond:(NSInteger)second
{
    NSString * dayStr = day > 9 ? [NSString stringWithFormat:@"%ld", day]:[NSString stringWithFormat:@"0%ld", day];
    NSString * hourStr = hour > 9 ? [NSString stringWithFormat:@"%ld", hour]:[NSString stringWithFormat:@"0%ld", hour];
    NSString * minStr = minute > 9 ? [NSString stringWithFormat:@"%ld", minute]:[NSString stringWithFormat:@"0%ld", minute];
    NSString * secStr = second > 9 ? [NSString stringWithFormat:@"%ld", second]:[NSString stringWithFormat:@"0%ld", second];
    
    
    NSString * timeString = [NSString stringWithFormat:@" 倒计时:  %@ : %@ : %@ : %@  ",dayStr, hourStr,minStr, secStr];
    
    
    
    
    NSRange dayRange = [timeString rangeOfString:dayStr];
    NSRange range1 = NSMakeRange(dayRange.location, timeString.length - dayRange.location - dayRange.length);
    
    NSRange hourRange = [timeString rangeOfString:hourStr options:NSCaseInsensitiveSearch range:range1];
    range1 = NSMakeRange(hourRange.location + hourRange.length, timeString.length - hourRange.location - hourRange.length);

    NSRange minuteRange = [timeString rangeOfString:minStr options:NSCaseInsensitiveSearch range:range1];
    range1 = NSMakeRange(minuteRange.location + minuteRange.length, timeString.length - minuteRange.location - minuteRange.length);

    NSRange secondRange = [timeString rangeOfString:secStr options:NSCaseInsensitiveSearch range:range1];
    
    
    NSMutableAttributedString * mTimeStr = [[NSMutableAttributedString alloc]initWithString:timeString];
    
    NSDictionary * timeAttribute = @{NSFontAttributeName:kMainFont,NSBackgroundColorAttributeName:UIColorFromRGB(0x000000)};
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(0, 5)];
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(dayRange.location - 1, dayRange.length + 2)];
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(hourRange.location - 1, hourRange.length + 2)];
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(minuteRange.location - 1, minuteRange.length + 2)];
    [mTimeStr setAttributes:timeAttribute range:NSMakeRange(secondRange.location - 1, secondRange.length + 2)];

    return mTimeStr;
}


@end
