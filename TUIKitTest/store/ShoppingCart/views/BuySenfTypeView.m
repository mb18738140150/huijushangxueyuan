//
//  BuySenfTypeView.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/3.
//

#import "BuySenfTypeView.h"

@interface BuySenfTypeView()

@property (nonatomic, strong)NSArray * array;

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)NSMutableArray * btnArray;
@property (nonatomic, strong)UIColor * color;

@end

@implementation BuySenfTypeView

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)array andMainColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        self.color = color;
        self.array = array;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    [self removeAllSubviews];
    [self.btnArray removeAllObjects];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width, self.hd_height)];
    self.backView.backgroundColor = self.color;
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    [self addSubview:_backView];
    
    float btnWdth = (self.hd_width - 2) / self.array.count;
    for (int i = 0; i < self.array.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnWdth + 1, 1, btnWdth, self.hd_height - 2);
        btn.tag = 1000 + i;
        [btn setTitle:self.array[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.color forState:UIControlStateNormal];
        btn.titleLabel.font = kMainFont;
        if (i == 0) {
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer * layer = [[CAShapeLayer alloc]init];
            layer.frame = btn.bounds;
            layer.path = path.CGPath;
            
            [btn.layer setMask:layer];
        }else if (i == self.array.count - 1) {
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer * layer = [[CAShapeLayer alloc]init];
            layer.frame = btn.bounds;
            layer.path = path.CGPath;
            [btn.layer setMask:layer];
        }
        
        [btn addTarget:self action:@selector(btnClicl:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:btn];
        [self.btnArray addObject:btn];
    }
    
    [self refreshUIWith:0];
    
}

- (void)btnClicl:(UIButton *)selectBtn
{
    NSInteger index = [self.btnArray indexOfObject:selectBtn];
    [self refreshUIWith:index];
    self.index = selectBtn.tag - 1000;
    if (self.btnSelectBlock) {
        self.btnSelectBlock(selectBtn.tag - 1000);
    }
}

- (void)refreshUIWith:(NSInteger )index
{
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton * btn = self.btnArray[i];
        
        if (i == index) {
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            btn.backgroundColor = self.color;
        }else
        {
            [btn setTitleColor:self.color forState:UIControlStateNormal];
            btn.backgroundColor = UIColorFromRGB(0xffffff);
        }
    }
}

@end
