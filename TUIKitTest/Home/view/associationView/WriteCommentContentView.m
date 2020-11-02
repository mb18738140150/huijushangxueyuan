//
//  WriteCommentContentView.m
//  lanhailieren
//
//  Created by aaa on 2020/4/17.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "WriteCommentContentView.h"

@interface WriteCommentContentView()<UITextViewDelegate>

@end

@implementation WriteCommentContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andInfo:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        self.infoDic = info;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width,1)];
    topLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:topLine];
    
    MKPPlaceholderTextView *textView = [[MKPPlaceholderTextView alloc]init];
    textView.placeholder = @"发布评论...";
    textView.frame = CGRectMake(10, 5, kScreenWidth - 60, 40);
    textView.delegate = self;
    textView.font = kMainFont_12;
    textView.placeholderColor = UIColorFromRGB(0x666666);
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    textView.layer.borderWidth = 1;
    [textView resetPlaceholderLabel];
    [textView setPlaceholderTextAlignment:NSTextAlignmentCenter];
    textView.returnKeyType = UIReturnKeySend;
    [self addSubview:textView];
    self.textView = textView;
    
    self.goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodBtn.frame = CGRectMake(kScreenWidth - 50, 12, 50, 25);
    [self.goodBtn setImage:[UIImage imageNamed:@"comment_点赞2"] forState:UIControlStateNormal];
    [self.goodBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    self.goodBtn.titleLabel.font = kMainFont;
    [self.goodBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [self addSubview:self.goodBtn];
    
    
    [self.goodBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self bringSubviewToFront:self.textView];
}

- (void)refreshUIWithInfo:(NSDictionary *)info
{
    self.infoDic = info;
    if([[[info objectForKey:@"zan_info"] objectForKey:@"is_zan"] intValue])
    {
        [self.goodBtn setImage:[UIImage imageNamed:@"comment_点赞2"] forState:UIControlStateNormal];
    }else
    {
        [self.goodBtn setImage:[UIImage imageNamed:@"comment_点赞1"] forState:UIControlStateNormal];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (self.commitBlock) {
            self.commitBlock(textView.text);
        }
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)operationAction:(UIButton *)button
{
    if ([button isEqual:self.goodBtn]) {
        if (self.goodBlock) {
            self.goodBlock(self.infoDic);
        }
    }else if ([button isEqual:self.collectBtn])
    {
        if (self.collectBlock) {
            self.collectBlock(self.infoDic);
        }
    }
    else if ([button isEqual:self.shareBtn])
    {
        if (self.shareBlock) {
            self.shareBlock(self.infoDic);
        }
    }
}

- (void)textViewResignFirstResponder
{
    [self.textView resignFirstResponder];
}
- (void)textViewBecomeFirstResponder
{
    [self.textView becomeFirstResponder];
}
- (void)hideOperationBtn
{
    self.textView.frame = CGRectMake(10, 10, kScreenWidth  - 20, 30);
}
- (void)showOperationBtn
{
    self.textView.frame = CGRectMake(10, 10, kScreenWidth / 2 - 20, 30);
}


@end
