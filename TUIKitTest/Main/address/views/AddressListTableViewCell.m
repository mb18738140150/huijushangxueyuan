//
//  AddressListTableViewCell.m
//  lanhailieren
//
//  Created by aaa on 2020/3/6.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "AddressListTableViewCell.h"

@implementation AddressListTableViewCell


- (void)refreshUIWithInfo:(NSDictionary *)infoDic
{
    self.infoDic = infoDic;
    [self.contentView removeAllSubviews];
    self.contentView.frame = self.bounds;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, self.hd_width - 30, self.hd_height - 10)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    backView.layer.borderWidth = 1;
    [self.contentView addSubview:backView];
    
    self.mapImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 15, 15)];
    self.mapImageView.image = [UIImage imageNamed:@"input_ditu"];
    [backView addSubview:self.mapImageView];
    
    self.informationLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    self.informationLB.font = kMainFont;
    self.informationLB.textColor = UIColorFromRGB(0x000000);
    
    NSString * str = [NSString stringWithFormat:@"%@    %@[默认]", [infoDic objectForKey:@"username"], [infoDic objectForKey:@"mobile"]];
    [backView addSubview:self.informationLB];
    if (![[infoDic objectForKey:@"defaulted"] boolValue]) {
        str = [NSString stringWithFormat:@"%@    %@", [infoDic objectForKey:@"username"], [infoDic objectForKey:@"mobile"]];
    }else
    {
        str = [NSString stringWithFormat:@"%@    %@[默认]", [infoDic objectForKey:@"username"], [infoDic objectForKey:@"mobile"]];
    }
    NSDictionary * nameAttribute = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:kCommonMainBlueColor};
    NSDictionary * morenAttribute = @{NSFontAttributeName:kMainFont_12,NSForegroundColorAttributeName:kCommonMainBlueColor};
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mStr addAttributes:nameAttribute range:NSMakeRange(0, [[infoDic objectForKey:@"username"] length])];
    if ([[infoDic objectForKey:@"defaulted"] boolValue]) {
        [mStr addAttributes:morenAttribute range:NSMakeRange(str.length - 4, 4)];
    }
    self.informationLB.attributedText = mStr;
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn.frame = CGRectMake(backView.hd_width - 54, 0, 54, 40);
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [backView addSubview:self.editBtn];
    self.editBtn.titleLabel.font = kMainFont;
    [self.editBtn addTarget:self action:@selector(editAddressAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * seperateVLine = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_informationLB.frame) + 10, backView.hd_width - 20, 1)];
    seperateVLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [backView addSubview:seperateVLine];
    self.sepeLine = seperateVLine;
    
    self.addressLB = [[UILabel alloc]initWithFrame:CGRectMake(self.informationLB.hd_x, CGRectGetMaxY(self.sepeLine.frame) + 0, backView.hd_width - 90, 60)];
    self.addressLB.font = kMainFont;
    self.addressLB.textColor = UIColorFromRGB(0x666666);
    
    self.addressLB.text = [NSString stringWithFormat:@"%@\n%@",[infoDic objectForKey:@"area"]?[infoDic objectForKey:@"area"]:@"",[infoDic objectForKey:@"address"]];
    self.addressLB.numberOfLines = 0;
    [backView addSubview:self.addressLB];
    
    
    UIImageView * goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backView.hd_width - 27, self.addressLB.hd_centerY - 7, 15, 15)];
    goImageView.image = [UIImage imageNamed:@"goImage"];
    [backView addSubview:goImageView];
    
    
    UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.hd_height - 1, self.contentView.hd_width, 1)];
    bottomLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
//    [self.contentView addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
    
    if (infoDic == nil) {
        UILabel * noAddressLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, self.hd_height - 2)];
        noAddressLB.text = @"请先选择地址";
        noAddressLB.font = kMainFont;
        noAddressLB.textColor = UIColorFromRGB(0x000000);
        noAddressLB.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:noAddressLB];
    }
    
    self.seperateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.contentView.hd_height - 2, self.contentView.hd_width, 2)];
    self.seperateImageView.image = [UIImage imageNamed:@"ic_place_border"];
    [self.contentView addSubview:self.seperateImageView];
    self.seperateImageView.hidden = YES;
    
    
}

- (void)refreshConfirmOrderUIWithInfo:(NSDictionary *)infoDic
{
    self.infoDic = infoDic;
    [self.contentView removeAllSubviews];
    self.contentView.frame = self.bounds;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.mapImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.hd_height / 2 - 7, 15, 15)];
    self.mapImageView.image = [UIImage imageNamed:@"main_地址"];
    [self.contentView addSubview:self.mapImageView];
    
    self.informationLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.mapImageView.frame) + 10, 10, 200, 30)];
    self.informationLB.font = kMainFont;
    self.informationLB.textColor = UIColorFromRGB(0x000000);
    self.informationLB.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"username"]];
    [self.contentView addSubview:self.informationLB];
    
    self.mobilLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 150, 10, 100, 30)];
    self.mobilLB.font = kMainFont_12;
    self.mobilLB.textColor = UIColorFromRGB(0x000000);
    self.mobilLB.textAlignment = NSTextAlignmentRight;
    self.mobilLB.text = [NSString stringWithFormat:@"%@", [UIUtility judgeStr:[infoDic objectForKey:@"mobile"]]];
    [self.contentView addSubview:self.mobilLB];
    
    self.addressLB = [[UILabel alloc]initWithFrame:CGRectMake(self.informationLB.hd_x, CGRectGetMaxY(self.informationLB.frame), self.contentView.hd_width - 90, 30)];
    self.addressLB.font = kMainFont_12;
    self.addressLB.textColor = UIColorFromRGB(0x666666);
    self.addressLB.numberOfLines = 0;
    self.addressLB.text = [NSString stringWithFormat:@"%@%@",[infoDic objectForKey:@"area"]?[infoDic objectForKey:@"area"]:@"",[infoDic objectForKey:@"address"]];
    [self.contentView addSubview:self.addressLB];
    
    
//    UIImageView * goImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.hd_width - 35, self.hd_height / 2 - 7, 15, 15)];
//    goImageView.image = [UIImage imageNamed:@"goImage"];
//    [self.contentView addSubview:goImageView];
    
    if (infoDic == nil || [[infoDic allKeys] count] == 0) {
        UILabel * noAddressLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, self.hd_height - 2)];
        noAddressLB.text = @"请先选择地址";
        noAddressLB.font = kMainFont;
        noAddressLB.textColor = UIColorFromRGB(0x000000);
        noAddressLB.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:noAddressLB];
    }
    
    self.seperateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.contentView.hd_height - 3, self.contentView.hd_width, 3)];
    self.seperateImageView.image = [UIImage imageNamed:@"ic_place_border"];
    [self.contentView addSubview:self.seperateImageView];
    self.seperateImageView.hidden = YES;
    
    
}

- (void)editAddressAction
{
    if (self.EditAddressBlock) {
        self.EditAddressBlock(self.infoDic);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)hideEditBtn
{
    self.sepeLine.hidden = YES;
    self.editBtn.hidden = YES;
}

- (void)showSeperateImageView
{
    self.seperateImageView.hidden = NO;
    self.bottomLine.hidden = YES;
}

@end
