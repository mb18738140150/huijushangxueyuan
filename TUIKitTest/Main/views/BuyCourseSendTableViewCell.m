//
//  BuyCourseSendTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "BuyCourseSendTableViewCell.h"

@interface BuyCourseSendTableViewCell()

@property (nonatomic, strong) UIView * backView;

@end

@implementation BuyCourseSendTableViewCell

- (void)refreshUWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView removeAllSubviews];
    
    UIView * backView= [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 , 100, 15)];
    label1.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"title"]];
    label1.textColor = UIColorFromRGB(0x333333);
    label1.font = kMainFont;
    [backView addSubview:label1];
    [label1 sizeToFit];
     
    UILabel * maxLB = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame) + 10, 100, 15)];
    maxLB.text = [NSString stringWithFormat:@"%@%@",[SoftManager shareSoftManager].coinName, [info objectForKey:@"pay_money"]];
    maxLB.textColor = kCommonMainOringeColor;
    maxLB.font = kMainFont;
    [backView addSubview:maxLB];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(maxLB.frame) + 10, backView.hd_width , 1)];
    line.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:line];
    
    UILabel * countlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(line.frame)  , 100, 30)];
    countlabel1.text = @"选择数量";
    countlabel1.textColor = UIColorFromRGB(0x333333);
    countlabel1.font = kMainFont;
    [backView addSubview:countlabel1];
    [countlabel1 sizeToFit];
    
    self.musBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.musBtn.frame = CGRectMake(backView.hd_width - 150, countlabel1.hd_y, 40, 30);
    [self.musBtn setTitle:@"-" forState:UIControlStateNormal];
    self.musBtn.titleLabel.font = kMainFont_16;
    [self.musBtn setTitleColor:UIColorFromRGB(0x111111) forState:UIControlStateNormal];
    
    UIBezierPath *bezier1 = [UIBezierPath bezierPathWithRoundedRect:self.musBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(_musBtn.hd_height / 2, _musBtn.hd_height / 2)];
    CAShapeLayer * layer1 = [[CAShapeLayer alloc]init];
    layer1.frame = self.musBtn.bounds;
    layer1.path = bezier1.CGPath;
    self.musBtn.layer.mask = layer1;
    self.musBtn.layer.borderWidth = 1;
    self.musBtn.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
    [backView addSubview:self.musBtn];
    
    self.countLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.musBtn.frame) - 1, countlabel1.hd_y, 60, 30)];
    self.countLB.text = @"1";
    self.countLB.layer.borderWidth = 1;
    self.countLB.font = kMainFont;
    self.countLB.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
    self.countLB.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.countLB];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(CGRectGetMaxX(self.countLB.frame) - 1, countlabel1.hd_y, 40, 30);
//    [self.addBtn setImage:[UIImage imageNamed:@"count_add"] forState:UIControlStateNormal];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    self.addBtn.titleLabel.font = kMainFont_16;
    [self.addBtn setTitleColor:UIColorFromRGB(0x111111) forState:UIControlStateNormal];
    UIBezierPath *bezier2 = [UIBezierPath bezierPathWithRoundedRect:self.musBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(_addBtn.hd_height / 2, _addBtn.hd_height / 2)];
    CAShapeLayer * layer2 = [[CAShapeLayer alloc]init];
    layer2.frame = self.musBtn.bounds;
    layer2.path = bezier2.CGPath;
    self.addBtn.layer.mask = layer2;
    self.addBtn.layer.borderWidth = 1;
    self.addBtn.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
    [backView addSubview:self.addBtn];
    
    [self.musBtn addTarget:self action:@selector(musAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)reset
{
    self.countLB.text = @"1";
}

- (void)musAction
{
    if (self.countLB.text.intValue >1) {
        int count = self.countLB.text.intValue - 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.countLB.text = [NSString stringWithFormat:@"%d", count];
            [self changeCount];
        });
    }
}

- (void)addAction
{
    int count = self.countLB.text.intValue + 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.countLB.text = [NSString stringWithFormat:@"%d", count];
        [self changeCount];
    });
}

- (void)changeCount
{
    if (self.countBlock) {
        self.countBlock(self.countLB.text.intValue);
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
