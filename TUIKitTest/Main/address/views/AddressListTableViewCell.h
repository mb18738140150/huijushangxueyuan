//
//  AddressListTableViewCell.h
//  lanhailieren
//
//  Created by aaa on 2020/3/6.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * mapImageView;
@property (nonatomic, strong)UILabel * informationLB;

@property (nonatomic, strong)UILabel * mobilLB;

@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UIButton * editBtn;
@property (nonatomic, strong)UIView * sepeLine;
@property (nonatomic, strong)UIImageView * seperateImageView;
@property (nonatomic, strong)UIView * bottomLine;

@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy)void (^EditAddressBlock)(NSDictionary * info);

- (void)refreshUIWithInfo:(NSDictionary *)infoDic;

- (void)refreshConfirmOrderUIWithInfo:(NSDictionary *)infoDic;

- (void)hideEditBtn;
- (void)showSeperateImageView;

@end

