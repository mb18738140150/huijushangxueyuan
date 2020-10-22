//
//  payModeView.h
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayModeView : UIView

@property (nonatomic, strong)UIImageView * selectStateImageView;
@property (nonatomic, strong)UILabel * modeStrLB;

@property (nonatomic, strong)UIButton * selectStateBtn;
@property (nonatomic, strong)UIButton * backBtn;

- (void)refreshContentWithModeImage:(UIImage *)modeImage andModeStr:(NSString *)modeStr andSelectNomalImage:(UIImage *)nomalImage andSelect_selectesImage:(UIImage *)selectImage;
- (void)refreshContentWithModeImage:(UIImage *)modeImage andModeAttributeStr:(NSMutableAttributedString *)modeStr andSelectNomalImage:(UIImage *)nomalImage andSelect_selectesImage:(UIImage *)selectImage;

@end
