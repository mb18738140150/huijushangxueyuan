//
//  HomeSearchCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeSearchCollectionViewCell.h"

@interface HomeSearchCollectionViewCell()<UITextFieldDelegate>

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UITextField * textTF;
@property (nonatomic, strong)UIButton * searchImageBtn;
@property (nonatomic, strong)UIButton * cleanKeyBtn;
@property (nonatomic, strong)UIButton * cancelBtn;

@property (nonatomic, strong)UIButton * btn;



@end

@implementation HomeSearchCollectionViewCell

- (void)refreshUIWithData:(NSDictionary *)info
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 15, self.hd_width - 35 , self.hd_height - 35)];
    self.backView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.backView.layer.cornerRadius = self.backView.hd_height / 2;
    self.backView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.backView];
    
    self.searchImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchImageBtn.frame = CGRectMake(self.backView.hd_height / 2, self.backView.hd_height / 2 - 10, 20, 20);
    [self.searchImageBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.backView addSubview:self.searchImageBtn];
    
    self.textTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.searchImageBtn.frame) + 5, 0, self.backView.hd_width - self.hd_height - 40, self.backView.hd_height)];
    self.textTF.placeholder = @"输入搜索内容";
    self.textTF.textColor = UIColorFromRGB(0x333333);
    self.textTF.font = kMainFont;
    self.textTF.delegate = self;
    self.textTF.returnKeyType = UIReturnKeySearch;
    [self.backView addSubview:self.textTF];
    if ([info objectForKey:@"keyword"]) {
        self.textTF.text = [info objectForKey:@"keyword"];
    }
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.hd_width, self.hd_height);
    [btn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.btn = btn;
    btn.hidden = YES;
}
- (void)showClickBtn
{
    self.btn.hidden = NO;
}
- (void)searchAction
{
    if (self.searchBlock) {
        self.searchBlock(@"");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.searchBlock) {
        self.searchBlock(textField.text);
    }
    return YES;
}

- (void)resignFirstResponder
{
    [self.textTF resignFirstResponder];
}


@end
