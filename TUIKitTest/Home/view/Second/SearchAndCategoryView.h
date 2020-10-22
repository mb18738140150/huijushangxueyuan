//
//  SearchAndCategoryView.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchAndCategoryView : UIView

@property (nonatomic, copy)void(^searchBlock)(NSString *key);
@property (nonatomic, copy)void(^scategorySelectBlock)(NSDictionary *info);
- (void)resignFirstResponder;
@property (nonatomic, strong)ZWMSegmentView * zixunSegment;
@property (nonatomic, strong)NSArray * dataArray;
- (void)refreshWith:(NSArray *)dataArray;
- (void)hideSearchView;
- (void)hideSeparateView;

- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName;

- (void)setSegmentColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
