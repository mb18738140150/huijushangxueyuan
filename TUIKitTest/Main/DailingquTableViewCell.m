//
//  DailingquTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/12/1.
//

#import "DailingquTableViewCell.h"

#import "CountDown.h"

@interface DailingquTableViewCell()


@property (nonatomic, assign)NSInteger      day;
@property (nonatomic, assign)NSInteger      hour;
@property (nonatomic, assign)NSInteger      minute;
@property (nonatomic, assign)NSInteger      sec;
@property (nonatomic, strong)UILabel        *timeLB;

@property (nonatomic, strong)NSTimer        *timer;
@property (strong, nonatomic)  CountDown *countDown;

@property (nonatomic, assign)BOOL isStartTimeDown;


@end

@implementation DailingquTableViewCell


- (void)refreshUIWith:(NSDictionary *)infoDic
{
    [self.contentView removeAllSubviews];
    self.infoDic = infoDic;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    if (self.timer) {
        [self timerInvalidate];
    }
    
    
    // 51 + 50
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_height - 10)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    
    NSDictionary * userInfo = [infoDic objectForKey:@"user"];
    
    // 直播大图
    self.iconImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    [self.backView addSubview:self.iconImageVIew];
    
    self.teacherNameLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageVIew.frame) + 10, self.iconImageVIew.hd_y - 5, _backView.hd_width - CGRectGetMaxX(self.iconImageVIew.frame) - 20, 20)];
    self.teacherNameLB.text = [UIUtility judgeStr:[userInfo objectForKey:@"nickname"]];
    self.teacherNameLB.textColor = UIColorFromRGB(0x666666);
    self.teacherNameLB.font = kMainFont_12;
    [_backView addSubview:self.teacherNameLB];
    
    
    // title
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(self.teacherNameLB.hd_x , CGRectGetMaxY(self.teacherNameLB.frame) , self.teacherNameLB.hd_width, 20)];
    self.titleLB.numberOfLines = 0;
    self.titleLB.font = [UIFont boldSystemFontOfSize:10];
    self.titleLB.textColor = UIColorFromRGB(0x999999);
    self.titleLB.text = [NSString stringWithFormat:@"消费:￥%@", [UIUtility judgeStr:[infoDic objectForKey:@"pay_money"]]];
    [self.backView addSubview:self.titleLB];
    
    
    UIView * lineiew = [[UIView alloc]initWithFrame:CGRectMake(10, 50, _backView.hd_width - 20, 1)];
    lineiew.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_backView addSubview:lineiew];
    
    UILabel * lingquLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineiew.frame) + 5, 100, 15)];
    lingquLB.text = @"待领取金额：";
    lingquLB.textColor = UIColorFromRGB(0x999999);
    lingquLB.font = kMainFont_12;
    [self.backView addSubview:lingquLB];
    
    // price
    NSString * priceStr = [self getTimeWith:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"time"]]];
    float priceWidth = [priceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_16} context:nil].size.width;
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lingquLB.frame) + 5, priceWidth + 10, 15)];
    self.priceLB.font = kMainFont_16;
    self.priceLB.textColor = kCommonMainBlueColor;
    [self.backView addSubview:self.priceLB];
    self.priceLB.text = [NSString stringWithFormat:@"￥%@", [infoDic objectForKey:@"money"]];
    [self.priceLB sizeToFit];
    
    NSString * timeStr = [self getTimeWith:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"time"]]];
    float timeWidth = [timeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.width;
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLB.frame) + 10, self.priceLB.hd_y - 1, timeWidth + 10, 17)];
    self.timeLB.textColor = kCommonMainBlueColor;
    self.timeLB.font = kMainFont_12;
    self.timeLB.layer.cornerRadius = 3;
    self.timeLB.layer.masksToBounds = YES;
    self.timeLB.layer.borderColor = kCommonMainBlueColor.CGColor;
    self.timeLB.layer.borderWidth = 1;
    self.timeLB.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.timeLB];
    self.timeLB.text = timeStr;
    
    
    // joinBtn
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(self.backView.hd_width - 80, CGRectGetMaxY(lineiew.frame) + 12, 70, 26);
    [self.applyBtn setTitle:@"领取" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.applyBtn.backgroundColor = kCommonMainBlueColor;
    self.applyBtn.layer.cornerRadius = 5;
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.titleLabel.font = kMainFont_12;
    [self.backView addSubview:self.applyBtn];
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self startTimeCountDown];
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
        return [NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, str1];
    }else
    {
        return [NSString stringWithFormat:@"%@%@ %@%@",[SoftManager shareSoftManager].coinName, str1,[SoftManager shareSoftManager].coinName,str2];
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
                        weakSelf.livingCourseStartBlock(weakSelf.infoDic);
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
        weakSelf.timeLB.text = [weakSelf getTimeStrWithday:weakSelf.day andHour:weakSelf.hour andMinute:weakSelf.minute andSecond:weakSelf.sec];
        
    });
}

- (void)timerInvalidate
{
    [self.timer invalidate];
    self.timer = nil;
}

- (NSString *)getTimeWith:(NSString *)timeStr
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    myDate = [myDate dateByAddingTimeInterval:3600 * 24];
    
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

- (NSString *)getTimeStrWithday:(NSInteger)day andHour:(NSInteger)hour andMinute:(NSInteger)minute andSecond:(NSInteger)second
{
    NSString * hourStr = hour > 9 ? [NSString stringWithFormat:@"%ld", hour + day * 24]:[NSString stringWithFormat:@"0%ld", hour];
    NSString * minStr = minute > 9 ? [NSString stringWithFormat:@"%ld", minute]:[NSString stringWithFormat:@"0%ld", minute];
    NSString * secStr = second > 9 ? [NSString stringWithFormat:@"%ld", second]:[NSString stringWithFormat:@"0%ld", second];
    
    
    NSString * timeString = [NSString stringWithFormat:@" 领取倒计时|%@ : %@ : %@  ", hourStr,minStr, secStr];
    return timeString;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void) dealloc
{
    NSLog(@"^^^^^ 销毁cell定时器");
}

@end
