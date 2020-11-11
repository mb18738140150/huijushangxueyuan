//
//  ShoppingCarListTableViewCell.h
//  lanhailieren
//
//  Created by aaa on 2020/3/10.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageCountView.h"
@interface ShoppingCarListTableViewCell : UITableViewCell
@property (nonatomic, strong)UIButton * selectBtn;

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * tipLB;
@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, strong)PackageCountView * packageCountView;
@property (nonatomic, assign)int buyCount;

@property (nonatomic, strong)NSDictionary * info;

@property (nonatomic, copy)void(^countBlock)(int count);
@property (nonatomic, copy)void(^selectBtnClickBlock)(NSDictionary * info,BOOL select);
@property (nonatomic, copy)void(^deleteBlock)(NSDictionary * info);


- (void)refreshUIWithInfo:(NSDictionary *)info isCanSelect:(BOOL)select;
- (void)resetSelectState:(BOOL)select;
- (void)refreshOrderCellWith:(NSDictionary *)info;
- (void)refreshOrderDetailCellWith:(NSDictionary *)info;


@end
