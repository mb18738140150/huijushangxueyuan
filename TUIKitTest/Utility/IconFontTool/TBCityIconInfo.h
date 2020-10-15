//
//  TBCityIconInfo.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TBCityIconInfo : NSObject


@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;
+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
