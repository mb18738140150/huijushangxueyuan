//
//  MyIncomeHeaderTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/26.
//

#import "MyIncomeHeaderTableViewCell.h"

@interface MyIncomeHeaderTableViewCell()

@property (nonatomic, strong)UILabel * keyongLB;
@property (nonatomic, strong)UILabel * dailingquLB;
@property (nonatomic, strong)UILabel * totalLB;
@property (nonatomic, strong)UILabel * tixianLB;

@property (nonatomic, strong)UIButton *promotionBtn;
@property (nonatomic, strong)UIImageView * teacher_sepaImageView;
@property (nonatomic, strong)UIButton *teacherBtn;
@property (nonatomic, strong)UIButton *tixianBtn;


@property (nonatomic, strong)UIButton * sortBtn;


@end

@implementation MyIncomeHeaderTableViewCell

- (void)refreshUIWithInfo:(NSDictionary *)infoDic
{
    if (!self.zixunSegment) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView removeAllSubviews];
        
        UILabel * topLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        topLB.text = @"待领取金额，必须达到同级用户才可以领取";
        topLB.textColor = UIColorFromRGB(0x333333);
        topLB.textAlignment = NSTextAlignmentCenter;
        topLB.font = kMainFont_12;
        [self.contentView addSubview:topLB];
        
        UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 200)];
        contentView.backgroundColor = kCommonMainBlueColor;
        [self.contentView addSubview:contentView];
        
        float contentHeight = 160;
        float separateHeight = 10;
        
        self.keyongLB = [[UILabel alloc]initWithFrame:CGRectMake(0, separateHeight, kScreenWidth / 2, (contentHeight - 2 * separateHeight) / 2)];
        
        _keyongLB.textColor = UIColorFromRGB(0xffffff);
        _keyongLB.font = kMainFont;
        _keyongLB.textAlignment = NSTextAlignmentCenter;
        _keyongLB.numberOfLines = 0;
        [contentView addSubview:_keyongLB];
        
        self.dailingquLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2, separateHeight, kScreenWidth / 2, (contentHeight - 2 * separateHeight) / 2)];
        
        _dailingquLB.textColor = UIColorFromRGB(0xffffff);
        _dailingquLB.font = kMainFont;
        _dailingquLB.textAlignment = NSTextAlignmentCenter;
        _dailingquLB.numberOfLines = 0;
        [contentView addSubview:_dailingquLB];
        
        self.totalLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_keyongLB.frame), kScreenWidth / 2, (contentHeight - 2 * separateHeight) / 2)];
        
        _totalLB.textColor = UIColorFromRGB(0xffffff);
        _totalLB.font = kMainFont;
        _totalLB.textAlignment = NSTextAlignmentCenter;
        _totalLB.numberOfLines = 0;
        
        [contentView addSubview:_totalLB];
        
        self.tixianLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2, CGRectGetMaxY(_keyongLB.frame), kScreenWidth / 2, (contentHeight - 2 * separateHeight) / 2)];
        
        _tixianLB.textColor = UIColorFromRGB(0xffffff);
        _tixianLB.font = kMainFont;
        _tixianLB.textAlignment = NSTextAlignmentCenter;
        _tixianLB.numberOfLines = 0;
        [contentView addSubview:_tixianLB];
        
        UIView * markView = [[UIView alloc]initWithFrame:CGRectMake(0, contentView.hd_height - 35, kScreenWidth, 35)];
        markView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [contentView addSubview:markView];
        
        self.promotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _promotionBtn.frame = CGRectMake(20, markView.hd_y + 5, 70, 25);
        _promotionBtn.backgroundColor = UIColorFromRGB(0xffffff);
        [_promotionBtn setTitle:@"推广收益" forState:UIControlStateNormal];
        [_promotionBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
        _promotionBtn.layer.cornerRadius = _promotionBtn.hd_height / 2;
        _promotionBtn.layer.masksToBounds = YES;
        _promotionBtn.titleLabel.font = kMainFont_12;
        [contentView addSubview:_promotionBtn];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_promotionBtn.frame) + 5, _promotionBtn.hd_y + 5, 15, 15)];
        imageView.image = [UIImage imageNamed:@"白色Sort"];
        self.teacher_sepaImageView = imageView;
        [contentView addSubview:imageView];
        
        self.teacherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _teacherBtn.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 5, markView.hd_y + 5, 70, 25);
        _teacherBtn.backgroundColor = [UIColor clearColor];
        [_teacherBtn setTitle:@"老师收益" forState:UIControlStateNormal];
        [_teacherBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _teacherBtn.layer.cornerRadius = _teacherBtn.hd_height / 2;
        _teacherBtn.layer.masksToBounds = YES;
        _teacherBtn.titleLabel.font = kMainFont_12;
        
        [contentView addSubview:_teacherBtn];
        
        
        self.tixianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tixianBtn.frame = CGRectMake(kScreenWidth - 90, markView.hd_y + 5, 70, 25);
        _tixianBtn.backgroundColor = [UIColor clearColor];
        [_tixianBtn setTitle:@"去提现" forState:UIControlStateNormal];
        _tixianBtn.titleLabel.font = kMainFont_12;
        
        [_tixianBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _tixianBtn.layer.cornerRadius = 5;
        _tixianBtn.layer.masksToBounds = YES;
        _tixianBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        _tixianBtn.layer.borderWidth = 1;
        [contentView addSubview:_tixianBtn];
        
        [_promotionBtn addTarget:self action:@selector(promisionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_teacherBtn addTarget:self action:@selector(promisionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tixianBtn addTarget:self action:@selector(promisionAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.zixunSegment = [[ZWMSegmentView alloc] initWithFrame:CGRectMake(17.5, CGRectGetMaxY(contentView.frame), self.contentView.hd_width - 35, 44) titles:@[@"奖励记录",@"提现记录"]];
        _zixunSegment.backgroundColor=[UIColor whiteColor];
        _zixunSegment.segmentTintColor = UIColorFromRGB(0x333333);
        _zixunSegment.segmentNormalColor = UIColorFromRGB(0x999999);
        _zixunSegment.indicateColor = kCommonMainBlueColor;
        [self addSubview:_zixunSegment];
        
        UIView * sortView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_zixunSegment.frame), kScreenWidth, 30)];
        sortView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:sortView];
        
        self.sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortBtn.frame = CGRectMake(kScreenWidth - 70, 0, 60, sortView.hd_height);
        [_sortBtn setImage:[UIImage imageNamed:@"灰色Sort"] forState:UIControlStateNormal];
        [_sortBtn setImage:[UIImage imageNamed:@"blueSort"] forState:UIControlStateSelected];
        [_sortBtn setTitle:@"正序" forState:UIControlStateNormal];
        [_sortBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_sortBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateSelected];
        _sortBtn.titleLabel.font = kMainFont;
        [sortView addSubview:_sortBtn];
        [_sortBtn addTarget:self action:@selector(promisionAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    NSString * keyongStr = [NSString stringWithFormat:@"可用额度(元)\n\n%@", [infoDic objectForKey:@"balance"]];
    NSMutableAttributedString * mKeyongStr = [[NSMutableAttributedString alloc]initWithString:keyongStr];
    NSDictionary * attribute_keyong = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0xeeeeee)};
    [mKeyongStr setAttributes:attribute_keyong range:NSMakeRange(0, 7)];
    _keyongLB.attributedText = mKeyongStr;
    
    NSString * dailingquStr = [NSString stringWithFormat:@"待领取(元)\n\n%@", [infoDic objectForKey:@"unclaimed"]];
    NSMutableAttributedString * mdailingquStr = [[NSMutableAttributedString alloc]initWithString:dailingquStr];
    NSDictionary * attribute_dailingqu = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0xeeeeee)};
    [mdailingquStr setAttributes:attribute_dailingqu range:NSMakeRange(0, 6)];
    _dailingquLB.attributedText = mdailingquStr;
    
    NSString * totalStr = [NSString stringWithFormat:@"累计总收益(元)\n\n%@", [infoDic objectForKey:@"income_sum"]];
    NSMutableAttributedString * mtotalStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSDictionary * attribute_total = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0xeeeeee)};
    [mtotalStr setAttributes:attribute_total range:NSMakeRange(0, 8)];
    _totalLB.attributedText = mtotalStr;
    
    NSString * tixianStr = [NSString stringWithFormat:@"累计提现(元)\n\n%@", [infoDic objectForKey:@"cash_sum"]];
    NSMutableAttributedString * mtixianStr = [[NSMutableAttributedString alloc]initWithString:tixianStr];
    NSDictionary * attribute_tixian = @{NSFontAttributeName:kMainFont,NSForegroundColorAttributeName:UIColorFromRGB(0xeeeeee)};
    [mtixianStr setAttributes:attribute_tixian range:NSMakeRange(0, 7)];
    _tixianLB.attributedText = mtixianStr;
    
    if (![UserManager sharedManager].isTeacher) {
        _teacherBtn.hidden = YES;
        _teacher_sepaImageView.hidden = YES;
    }
}

- (void)resetSort:(NSString *)sort
{
    if ([sort isEqualToString:@"asc"]) {
        self.sortBtn.selected = YES;
    }else
    {
        self.sortBtn.selected = NO;
    }
}

- (void)resetIsTeacher:(BOOL )isTeacher
{
    if (isTeacher) {
        _promotionBtn.backgroundColor = [UIColor clearColor];
        [_promotionBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
        
        _teacherBtn.backgroundColor = UIColorFromRGB(0xffffff);
        [_teacherBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
    }else
    {
        _promotionBtn.backgroundColor = UIColorFromRGB(0xffffff);
        [_promotionBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
        
        _teacherBtn.backgroundColor = [UIColor clearColor];
        [_teacherBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }
}

- (void)promisionAction:(UIButton *)button
{
    button.selected = !button.selected;
    if ([button isEqual:_sortBtn]) {
        if (self.sortBlock) {
            self.sortBlock(button.isSelected);
        }
        return;
    }
    if ([button isEqual:_tixianBtn]) {
        if (self.tixianBlock) {
            self.tixianBlock(@{});
        }
        return;
    }
    if ([button isEqual:_promotionBtn]) {
        [self.zixunSegment setSelectedAtIndex:0];
        [self resetIsTeacher:NO];
        if (self.promisionBlock) {
            self.promisionBlock(@{});
        }
    }else
    {
        [self.zixunSegment setSelectedAtIndex:0];
        [self resetIsTeacher:YES];
        if (self.teacherBlock) {
            self.teacherBlock(@{});
        }
    }
    
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
