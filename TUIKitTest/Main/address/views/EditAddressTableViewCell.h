//
//  EditAddressTableViewCell.h
//  lanhailieren
//
//  Created by aaa on 2020/3/6.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddressTableViewCell : UITableViewCell

@property(nonatomic, strong)UILabel* titleLB;
@property(nonatomic, strong)UITextField* contentTF;
@property(nonatomic, strong)UIButton* btn;

@property(nonatomic, strong)UIButton* morenBtn;

@property (nonatomic, copy)void (^addressBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^morenBlock)(NSDictionary * info);

@property (nonatomic, copy)void (^textBlock)(NSString * str);

- (void)refreshUIWith:(NSDictionary *)info;
- (void)chooceAddress;
- (void)setMorenAction:(BOOL)ismoren;
- (void)setDeleteAction;

@end

