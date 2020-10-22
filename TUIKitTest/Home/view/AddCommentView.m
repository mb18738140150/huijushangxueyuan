//
//  AddCommentView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import "AddCommentView.h"
#import "MKPPlaceholderTextView.h"

@interface AddCommentView()<UITextViewDelegate>

@property (nonatomic, strong)UIView * contentView;
@property (nonatomic, strong)MKPPlaceholderTextView *opinionTextView;
@property (nonatomic, strong)UILabel * countLB;

@end

@implementation AddCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
    [backView addGestureRecognizer:tap];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
    imageView.image = [UIImage imageNamed:@"comment_评论1"];
    [_contentView addSubview:imageView];
    
    MKPPlaceholderTextView *textView = [[MKPPlaceholderTextView alloc]init];
    textView.placeholder = @"点赞太容易，评论显真情";
    textView.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 5, kScreenWidth - 55, 120);
    textView.delegate = self;
    textView.layer.cornerRadius = 1;
    textView.layer.masksToBounds = YES;
    self.opinionTextView = textView;
    [_contentView addSubview:textView];
    
    UILabel *countLB = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(textView.frame) + 10, self.hd_width - 30 - 40, 20)];
    countLB.text = @"0/200";
    countLB.textColor = UIColorFromRGB(0x666666);
    countLB.font = kMainFont_12;
    countLB.textAlignment = NSTextAlignmentRight;
    [_contentView addSubview:countLB];
    self.countLB = countLB;
    
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(CGRectGetMaxX(countLB.frame), CGRectGetMaxY(textView.frame), 50, 40);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = kMainFont;
    [sendBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:sendBtn];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)keyboardChangeFrame:(NSNotification*)noti;
{
    
    CGRect rect= [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSLog(@"%@", noti.userInfo);
    CGFloat keyboardheight = rect.origin.y;
    CGFloat duration=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGFloat curve=[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey]doubleValue];
    
    [UIView setAnimationCurve:curve];
    [UIView animateWithDuration:duration animations:^{
        self.contentView.hd_y = keyboardheight - 200;
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void)keyboardHide:(NSNotification *)noti
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.hd_y = kScreenHeight - 200;
        
    } completion:^(BOOL finished) {
        
    }];

}


- (void)sendAction
{
    [self removeFromSuperview];
    
    NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:self.info];
    if (self.opinionTextView.text.length == 0) {
        [mInfo setValue:@"" forKey:@"commentContent"];
    }else
    {
        [mInfo setValue:self.opinionTextView.text forKey:@"commentContent"];
    }
    if (self.sendBlock) {
        self.sendBlock(mInfo);
    }
}

- (void)dismissAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    [self resetCountLB:textView.text.length];
}

- (void)resetCountLB:(int)length
{
    _countLB.text = [NSString stringWithFormat:@"%d/200", length];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
