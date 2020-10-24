//
//  UIUtility.m
//  Accountant
//
//  Created by aaa on 2017/3/3.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UIUtility.h"
#import "UIMacro.h"

@implementation UIUtility

+ (UITableViewCell *)getCellWithCellName:(NSString *)reuseName inTableView:(UITableView *)table andCellClass:(Class)cellClass
{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:reuseName];
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)getHeightWithText:(NSString *)content font:(UIFont *)textFont width:(CGFloat)width
{
    if ([[content class] isEqual:[NSNull class]]) {
        return 0;
    }
    if(content == nil)
       {
           return 0;
       }
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: textFont} context:nil];
    return textRect.size.height;
}

+ (CGFloat)getWidthWithText:(NSString *)content font:(UIFont *)textFont height:(CGFloat)height
{
    if ([[content class] isEqual:[NSNull class]]) {
        return 0;
    }
    if(content == nil)
       {
           return 0;
       }
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: textFont} context:nil];
    return textRect.size.width;
}

+ (CGFloat)getSpaceLabelHeght:(NSString *)content font:(UIFont *)font width:(CGFloat)width
{
    if ([[content class] isEqual:[NSNull class]]) {
        return 0;
    }
    if(content == nil)
    {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = kUILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary * dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
}

+ (NSAttributedString *)getSpaceLabelStr:(NSString *)content withFont:(UIFont *)font color:(UIColor *)color
{
    if ([[content class] isEqual:[NSNull class]]) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    if(content == nil)
    {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = kUILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSForegroundColorAttributeName:color,NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString * attributeStr = [[NSAttributedString alloc]initWithString:content attributes:dic];
    return attributeStr;
}

+ (NSAttributedString *)getSpaceLabelStr:(NSString *)content withFont:(UIFont *)font withAlignment:(NSTextAlignment)aligment
{
    if ([[content class] isEqual:[NSNull class]]) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    if(content == nil)
    {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = aligment;
    paraStyle.lineSpacing = kUILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString * attributeStr = [[NSAttributedString alloc]initWithString:content attributes:dic];
    return attributeStr;
}

+ (NSAttributedString *)getSpaceLabelStr:(NSString *)content withFont:(UIFont *)font withFirstLineHeadIndent:(CGFloat)headIndent
{
    if ([[content class] isEqual:[NSNull class]]) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    if(content == nil)
    {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = kUILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = headIndent;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString * attributeStr = [[NSAttributedString alloc]initWithString:content attributes:dic];
    return attributeStr;
}


+ (NSAttributedString *)getSpaceLabelStr:(NSString *)content withFont:(UIFont *)font
{
    if (content == nil) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    if(content == nil)
    {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = kUILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString * attributeStr = [[NSAttributedString alloc]initWithString:content attributes:dic];
    return attributeStr;
}

+ (NSString *)getGetRequest_Str:(NSDictionary *)dic
{
    NSMutableArray * propetyArr = [NSMutableArray array];
    
    NSArray * keyArrar = [dic allKeys];
    
    //升序排列
    NSArray * sortKeyArrar = [keyArrar sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
        return [obj1 compare:obj2]; //升序
    }];

    for (NSString * key in sortKeyArrar) {
        NSString * str = [key stringByAppendingFormat:@"=%@", [dic objectForKey:key]];
        [propetyArr addObject:str];
    }
    
    NSString * sha1Str = [propetyArr componentsJoinedByString:@"&"];


    return sha1Str;;
}

+ (NSString *)getAES_Str:(NSDictionary *)dic
{
    NSMutableArray * propetyArr = [NSMutableArray array];
    
    NSArray * keyArrar = [dic allKeys];
    
    //升序排列
    NSArray * sortKeyArrar = [keyArrar sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
        return [obj1 compare:obj2]; //升序
    }];

    for (NSString * key in sortKeyArrar) {
        NSString * str = [key stringByAppendingFormat:@"=%@", [dic objectForKey:key]];
        [propetyArr addObject:str];
    }
    
    NSString * sha1Str = [propetyArr componentsJoinedByString:@"&"];
    
    
    if (sha1Str.length > 0) {
        sha1Str = [sha1Str stringByAppendingString:@"&key=1bc29b36f623ba82aaf6724fd3b16718"];
    }else
    {
        sha1Str = @"key=1bc29b36f623ba82aaf6724fd3b16718";
    }
    
    sha1Str = [sha1Str SHA1_Cap];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
//    sha1Str = [NSString stringWithFormat:@"{\"time\":\"%@\",\"token\":\"%@\"}", timeString, sha1Str];
    
    NSDictionary * firstdic = @{@"time":timeString,@"token":sha1Str};
    NSString * dicJsonStr = [firstdic JSONString];
    
    NSString * aesStr = [dicJsonStr AES_encryptStringWithString:dicJsonStr andKey:@"PSf_wsIsE:u]G0xz"];

    return aesStr;;
}

+ (NSMutableAttributedString *)getLineSpaceLabelStr:(NSMutableAttributedString *)content withFont:(UIFont *)font
{
    if (content == nil) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    if(content == nil)
    {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = kUILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    
    [content setAttributes:dic range:NSMakeRange(0, content.length)];
    return content;
}

+ (CGFloat)getLineSpaceLabelHeght:(NSString *)content font:(UIFont *)font width:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = kUILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary * dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f};
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
}


+ (NSString *)judgeStr:(id)str
{
    if ([str class] == [NSNull class] || str == nil ) {
        if ([str isKindOfClass:[NSNumber class]]) {
            return @"0";
        }
        return @"";
    }else
    {
        return [NSString stringWithFormat:@"%@", str];
    }
}

+ (void)codefileData:(NSString *)filePath
{
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    NSData * subData = [fileData subdataWithRange:NSMakeRange(0, 3)];
    char * bytes = (char *)[subData bytes];
    for (int i = 0; i < [subData length]; i++) {
        *bytes = *(bytes) ^ 1;
        bytes++;
    }
    NSFileHandle * fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToFileOffset:0];
    [fileHandle writeData:subData];
    [fileHandle closeFile];
}

// 通过代码将”0xff6a50“ 或者 ”#ff6a50“ 这样的字符串形式值，实现为自定义的颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSRegularExpression *RegEx = [NSRegularExpression regularExpressionWithPattern:@"^[a-fA-F|0-9]{6}$" options:0 error:nil];
    NSUInteger match = [RegEx numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, hexString.length)];

    if (match == 0) {return [UIColor clearColor];}

    NSString *rString = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [hexString substringWithRange:NSMakeRange(4, 2)];
    unsigned int r, g, b;
    BOOL rValue = [[NSScanner scannerWithString:rString] scanHexInt:&r];
    BOOL gValue = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    BOOL bValue = [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (rValue && gValue && bValue) {
        return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:alpha];
    } else {
        return [UIColor clearColor];
    }
}

+ (NSString *)getUnicodeStr:(NSString *)fontclass
{
    NSDictionary * dataDic = @{@"icon-remen":@"\U0000e647",
                               @"icon-zhengzaizhibo":@"\U0000e6e2",
                               @"icon-qun":@"\U0000e6e2",
                               @"icon-qianggou1":@"\U0000e6e8",
                               @"icon-remenx":@"\U0000e619",
                               @"icon-tupian2":@"\U0000e606",
                               @"icon-tuwenzixun":@"\U0000e67c",
                               @"icon-nav_activity":@"\U0000e690",
                               @"icon-Group-":@"\U0000e6ae",
                               @"icon-icon_zhibo-mian":@"\U0000e65b",
                               @"icon-shipin":@"\U0000e756",
                               @"icon-shengyin":@"\U0000eae0",
                               @"icon-ico-":@"\U0000e81d",
                               @"icon-gouwu":@"\U0000e7ed",
                               @"icon-cuxiaohuodong-huodongliebiao":@"\U0000e602",
                               @"icon-leibie":@"\U0000e649",
                               @"icon-fenlan":@"\U0000e867",
                               @"icon-shangcheng":@"\U0000e6c7",
                               @"icon--":@"\U0000e623",
                               @"icon-weimingmingwenjianjia_lanmu":@"\U0000e638",
                               @"icon-video-fill":@"\U0000e63e",
                               @"icon-huodong3":@"\U0000e611",
                               @"icon-tuwenzixun1":@"\U0000e683",
                               @"icon-pintuan":@"\U0000e60f",
                               @"icon-pintuan1":@"\U0000eb5b",
                               @"icon-tuwenliebiao":@"\U0000e66c",
                               @"icon-shipin1":@"\U0000e61b",
                               @"icon-15":@"\U0000e626",
                               @"icon-zhibo":@"\U0000e74f",
                               @"icon-kanjia":@"\U0000e76b",
                               @"icon-yuyin":@"\U0000e60b",
                               @"icon-remenhuodong":@"\U0000e60c",
                               @"icon-tejiashenqingdan":@"\U0000e69d",
                               @"icon-morentupian":@"\U0000e60d",
                               @"icon-gongjulan-qibiao":@"\U0000e634",
                               @"icon-w_shipinke":@"\U0000e67d",
                               @"icon-shipin2":@"\U0000e610",
                               @"icon-dashujukeshihuaico-":@"\U0000e7ff",
                               @"icon-wode":@"\U0000e651",
                               @"icon-weibiaoti--":@"\U0000e612",
                               @"icon-wode1":@"\U0000e613",
                               @"icon-shouye":@"\U0000e6b9",
                               @"icon-shouye1":@"\U0000e627",
                               @"icon-wode2":@"\U0000e605",
                               @"icon-shouye2":@"\U0000e6a6",
                               @"icon-shouye3":@"\U0000e8c6",
                               @"icon-wode3":@"\U0000e617",
                               @"icon-dingdan2":@"\U0000e60a",
                               @"icon-dilanxianxingiconyihuifu_huabanfuben":@"\U0000e607",
                               @"icon-dingdan1":@"\U0000e636",
                               @"icon-faxian":@"\U0000e608",
                               @"icon-faxian1":@"\U0000e662",
                               @"icon-shipinbofangyingpian2":@"\U0000e78e",
                               @"icon-ai-img-list":@"\U0000e60e",
                               @"icon-ziyouhuodong":@"\U0000e658",
                               @"icon-shangcheng2":@"\U0000e680",
                               @"icon-campaign":@"\U0000e665",
                               @"icon-taiwangdahui-huodongdianjitai":@"\U0000e687",
                               @"icon-zhutihuodong":@"\U0000e67e",
                               @"icon-tupian1":@"\U0000e601",
                               @"icon-htmal5icon12":@"\U0000e632",
                               @"icon-zhengzaizhibo":@"\U0000e6e2",
                               @"icon-zhengzaizhibo":@"\U0000e6e2",
                               @"icon-zhengzaizhibo":@"\U0000e6e2",
                               @"icon-zhengzaizhibo":@"\U0000e6e2",
                               @"icon-zhengzaizhibo":@"\U0000e6e2"};
    
    for (NSString * key in [dataDic allKeys]) {
        if ([key isEqualToString:fontclass]) {
            return [dataDic objectForKey:key];
        }
    }
    
    
    return @"";
}

+ (NSString *)getCurrentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

@end
