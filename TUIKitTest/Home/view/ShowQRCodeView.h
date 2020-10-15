//
//  ShowQRCodeView.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowQRCodeView : UIView

@property (nonatomic, strong)NSString * imageUrl;
- (instancetype)initWithFrame:(CGRect)frame andUrl:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
