//
//  EditAddressTableViewCell.m
//  lanhailieren
//
//  Created by aaa on 2020/3/6.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "EditAddressTableViewCell.h"

@interface EditAddressTableViewCell()<UITextFieldDelegate>


@end

@implementation EditAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshUIWith:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.contentView.frame = self.bounds;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 100, 15)];
    self.titleLB.text = [info objectForKey:@"title"];
    self.titleLB.font = kMainFont;
    self.titleLB.textColor = UIColorFromRGB(0x010101);
    [self.contentView addSubview:self.titleLB];
    
    self.contentTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, self.hd_width - 100, self.hd_height)];
    if ([[info objectForKey:@"placeholder"] intValue] == 1) {
        self.contentTF.placeholder =[info objectForKey:@"content"];
    }else
    {
        self.contentTF.text = [info objectForKey:@"content"];        
    }
    self.contentTF.font = kMainFont;
    self.contentTF.textColor = UIColorFromRGB(0x010101);
    self.contentTF.delegate = self;
    self.contentTF.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.contentTF];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = self.contentTF.frame;
    [self.contentView addSubview:self.btn];
    self.btn.hidden = YES;
    [self.btn addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.morenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.morenBtn.frame = CGRectMake(self.hd_width - 30, 17, 15, 15);
    [self.morenBtn setImage:[UIImage imageNamed:@"ic_unselected_address"] forState:UIControlStateNormal];
    [self.morenBtn setImage:[UIImage imageNamed:@"地址勾选"] forState:UIControlStateSelected];
    [self.morenBtn addTarget:self action:@selector(morenAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.morenBtn];
    self.morenBtn.hidden = YES;
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 1, self.hd_width, 1)];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView addSubview:bottomView];
    
}

- (void)addressAction
{
    if (self.addressBlock) {
        self.addressBlock(@{});
    }
}

- (void)morenAction
{
    if (self.morenBlock) {
        self.morenBlock(@{});
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"***\n %@", textField.text);
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"^^^^\n %@", textField.text);
    if (self.textBlock) {
        self.textBlock(textField.text);
    }
}


- (void)chooceAddress
{
    self.btn.hidden = NO;
}

- (void)setMorenAction:(BOOL)ismoren
{
    self.morenBtn.hidden = NO;
    self.morenBtn.selected = ismoren;
}

- (void)setDeleteAction
{
    self.titleLB.textColor = kCommonMainRedColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
