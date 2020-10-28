//
//  PromotionApplyTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import "PromotionApplyTableViewCell.h"
#import "ChooseCountryPhoneNum.h"

@interface PromotionApplyTableViewCell()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField * nameTF;
@property (nonatomic, strong)UIButton * chooseCountryBtn;
@property (nonatomic, strong)UITextField * phoneTF;
@property (nonatomic, strong)UITextField *verifyTF;
@property (nonatomic, strong)UIButton *getVerifyCodeBtn;

@property (nonatomic, strong)UIButton *applyBtn;


@end

@implementation PromotionApplyTableViewCell

- (void)refreshApplyUIWithInfo:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellAccessoryNone;
    [self.contentView removeAllSubviews];
    
    UIImage * backImage = [UIImage imageNamed:@"底图"];
    float imageHeight = backImage.size.height * 1.0 / backImage.size.width * kScreenWidth;
    
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    backImageView.image = backImage;
    [self.contentView addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
    [backImageView addGestureRecognizer:tap];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(20, backImageView.hd_height * 0.4, kScreenWidth - 40, backImageView.hd_height * 0.5)];
    contentView.backgroundColor = UIColorFromRGB(0xffffff);
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    [self.contentView addSubview:contentView];
    CGFloat space = contentView.hd_height / 14;
    
    // name
    UIView * nameView = [[UIView alloc]initWithFrame:CGRectMake(15, space, contentView.hd_width - 30, space * 2)];
    nameView.backgroundColor = UIColorFromRGB(0xffffff);
    nameView.layer.cornerRadius = 5;
    nameView.layer.masksToBounds = YES;
    nameView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    nameView.layer.borderWidth = 1;
    [contentView addSubview:nameView];
    
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 1, nameView.hd_width - 30, nameView.hd_height - 2)];
    self.nameTF.returnKeyType = UIReturnKeyDone;
    _nameTF.textColor = UIColorFromRGB(0x333333);
    _nameTF.placeholder = @"请输入姓名";
    _nameTF.font = kMainFont;
    [nameView addSubview:_nameTF];
    
    // phone
    UIView * phoneView = [[UIView alloc]initWithFrame:CGRectMake(15, space * 4, contentView.hd_width - 30, space * 2)];
    phoneView.backgroundColor = UIColorFromRGB(0xffffff);
    phoneView.layer.cornerRadius = 5;
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    phoneView.layer.borderWidth = 1;
    [contentView addSubview:phoneView];
    
    self.chooseCountryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseCountryBtn.frame = CGRectMake(10, 1, 60, phoneView.hd_height - 2);
    _chooseCountryBtn.backgroundColor = UIColorFromRGB(0xffffff);
    _chooseCountryBtn.titleLabel.font = kMainFont;
    [_chooseCountryBtn setTitle:@"+86" forState:UIControlStateNormal];
    [_chooseCountryBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_chooseCountryBtn setImage:[UIImage imageNamed:@"down箭头"] forState:UIControlStateNormal];
    [phoneView addSubview:_chooseCountryBtn];
    [self resetChooseBtn];
    
    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_chooseCountryBtn.frame) + 15, 1, phoneView.hd_width - 30, phoneView.hd_height - 2)];
    self.phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.textColor = UIColorFromRGB(0x333333);
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.font = kMainFont;
    [phoneView addSubview:_phoneTF];
    
    // verifycode
    UIView * codeView = [[UIView alloc]initWithFrame:CGRectMake(15, space * 7, contentView.hd_width - 45 - 90, space * 2)];
    codeView.backgroundColor = UIColorFromRGB(0xffffff);
    codeView.layer.cornerRadius = 5;
    codeView.layer.masksToBounds = YES;
    codeView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    codeView.layer.borderWidth = 1;
    [contentView addSubview:codeView];
    
    self.verifyTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 1, codeView.hd_width - 30, codeView.hd_height - 2)];
    self.verifyTF.returnKeyType = UIReturnKeyDone;
    _verifyTF.textColor = UIColorFromRGB(0x333333);
    _verifyTF.placeholder = @"请输入手机验证码";
    _verifyTF.font = kMainFont;
    [codeView addSubview:_verifyTF];
    
    
    self.getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getVerifyCodeBtn.frame = CGRectMake(CGRectGetMaxX(codeView.frame) + 15, codeView.hd_y, 90, codeView.hd_height);
    _getVerifyCodeBtn.backgroundColor = kCommonMainBlueColor;
    [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _getVerifyCodeBtn.titleLabel.font = kMainFont_12;
    _getVerifyCodeBtn.layer.cornerRadius = 5;
    _getVerifyCodeBtn.layer.masksToBounds = YES;
    [contentView addSubview:_getVerifyCodeBtn];
    
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _applyBtn.frame = CGRectMake(15, space * 11, contentView.hd_width - 30, codeView.hd_height);
    _applyBtn.backgroundColor = kCommonMainBlueColor;
    [_applyBtn setTitle:@"申请成为推广员" forState:UIControlStateNormal];
    [_applyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _applyBtn.titleLabel.font = kMainFont;
    _applyBtn.layer.cornerRadius = 5;
    _applyBtn.layer.masksToBounds = YES;
    [contentView addSubview:_applyBtn];
    
    
    [self.chooseCountryBtn addTarget:self action:@selector(choosePhoneNumAction) forControlEvents:UIControlEventTouchUpInside];
    [self.getVerifyCodeBtn addTarget:self action:@selector(getVerifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameTF.delegate = self;
    self.phoneTF.delegate = self;
    self.verifyTF.delegate = self;
    
    UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(kScreenWidth / 2 - 60, backImageView.hd_height * 0.95 - 15, 120, 30);
    [checkBtn setTitle:@"查看推广规则" forState:UIControlStateNormal];
    [checkBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    checkBtn.titleLabel.font = kMainFont_12;
    [self.contentView addSubview:checkBtn];
    
    [checkBtn addTarget:self action:@selector(checkaction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshCheckUIWithInfo:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellAccessoryNone;
    [self.contentView removeAllSubviews];
    
    UIImage * backImage = [UIImage imageNamed:@"底图"];
    float imageHeight = backImage.size.height * 1.0 / backImage.size.width * kScreenWidth;
    
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    backImageView.image = backImage;
    [self.contentView addSubview:backImageView];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(20, backImageView.hd_height * 0.4, kScreenWidth - 40, backImageView.hd_height * 0.5)];
    contentView.backgroundColor = UIColorFromRGB(0xffffff);
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    [self.contentView addSubview:contentView];
    
    UIImageView * stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(contentView.hd_width / 2 - 25, 50, 50, 50)];
    stateImageView.image = [UIImage imageNamed:@"promotionCheck"];
    [contentView addSubview:stateImageView];
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(stateImageView.frame) + 20, contentView.hd_width, 20)];
    titleLB.text = @"申请已提交，请等待审核结果";
    titleLB.textColor = UIColorFromRGB(0x333333);
    titleLB.font = kMainFont_12;
    titleLB.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLB];
    
    UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(kScreenWidth / 2 - 60, backImageView.hd_height * 0.95 - 15, 120, 30);
    [checkBtn setTitle:@"查看推广规则" forState:UIControlStateNormal];
    [checkBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    checkBtn.titleLabel.font = kMainFont_12;
    [self.contentView addSubview:checkBtn];
    
    [checkBtn addTarget:self action:@selector(checkaction) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)resetChooseBtn
{
    NSString * title = self.chooseCountryBtn.titleLabel.text;
    CGFloat width = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, _chooseCountryBtn.hd_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.width;
    
    _chooseCountryBtn.imageEdgeInsets = UIEdgeInsetsMake(0, width, 0, -width);
    _chooseCountryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
}

- (void)getVerifyCodeAction
{
    [self dismissAction];
    if (self.phoneTF.text.length<= 0) {
        [SVProgressHUD showInfoWithStatus:@"手机号码不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    if (self.getVerifyACodeBlock) {
        self.getVerifyACodeBlock(@{@"phone":self.phoneTF.text});
    }
}


- (void)applyAction
{
    [self dismissAction];
    if (self.nameTF.text.length <= 0 || self.phoneTF.text.length<= 0) {
        [SVProgressHUD showInfoWithStatus:@"姓名手机号码均不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    if (self.verifyTF.text.length <= 0 ) {
        [SVProgressHUD showInfoWithStatus:@"验证码不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    if (self.promotionApplyBlock) {
        self.promotionApplyBlock(@{@"name":self.nameTF.text,@"phone":self.phoneTF.text,@"code":self.verifyTF.text});
    }
    
}

- (void)choosePhoneNumAction
{
    __weak typeof(self)weakSelf = self;
    ChooseCountryPhoneNum * view = [[ChooseCountryPhoneNum alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:view];
    view.chooseCountryBlock = ^(NSDictionary * _Nonnull info) {
        [weakSelf.chooseCountryBtn setTitle:[NSString stringWithFormat:@"+%@", [info objectForKey:@"phoneCode"]] forState:UIControlStateNormal];
        [weakSelf resetChooseBtn];
    };
    [self dismissAction];
}


- (void)checkaction
{
    if (self.CheckRulerBlock) {
        self.CheckRulerBlock(@{});
    }
}

- (void)dismissAction
{
    [self.nameTF resignFirstResponder];
    [self.verifyTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
