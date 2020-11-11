//
//  ShoppingCarBottomView.h
//  lanhailieren
//
//  Created by aaa on 2020/3/10.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarBottomView : UIView

@property (nonatomic, strong)UIButton * selectAllBtn;
@property (nonatomic, strong)UILabel * priceLabel;

@property (nonatomic, strong)UIButton * deleteBtn;
@property (nonatomic, strong)UIButton * buyBtn;
@property (nonatomic, strong)UILabel * countLB;

@property (nonatomic, copy)void (^selectAllBlock)(BOOL select);
@property (nonatomic, copy)void (^deleteShoppingCarBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^buyShoppingCarBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^addShoppingCarBlock)(NSDictionary *info);

- (void)refreshPrice:(NSDictionary *)infoDic;

- (void)refreshGoodPrice:(NSDictionary *)infoDic;
- (void)refreshTotalCount;

- (void)refreshEditState:(BOOL)isEditing;

- (instancetype)initWithFrame:(CGRect)frame andBuy:(BOOL)buy;

- (instancetype)initWithFrame:(CGRect)frame andFoodIntroduce:(BOOL)introduce;


@end
