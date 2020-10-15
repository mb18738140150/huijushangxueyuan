//
//  SearchAndCategoryView.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "SearchAndCategoryView.h"

@interface SearchAndCategoryView()<UITextFieldDelegate>

@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UITextField * textTF;
@property (nonatomic, strong)UIButton * searchImageBtn;
@property (nonatomic, strong)UIButton * cleanKeyBtn;
@property (nonatomic, strong)UIButton * cancelBtn;


@end

@implementation SearchAndCategoryView

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
    self.backgroundColor = [UIColor whiteColor];
       
       self.backView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 10, self.hd_width - 35 , 25)];
       self.backView.backgroundColor = UIColorFromRGB(0xf2f2f2);
       self.backView.layer.cornerRadius = self.backView.hd_height / 2;
       self.backView.layer.masksToBounds = YES;
       [self addSubview:self.backView];
       
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
    
    UIView * seperateLine = [[UIView alloc]initWithFrame:CGRectMake(self.backView.hd_x, self.hd_height - 4, self.backView.hd_width, 1)];
    seperateLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:seperateLine];
}

- (void)refreshWith:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    NSMutableArray * titleArray = [NSMutableArray array];
    
     for (NSDictionary * info in dataArray) {
         [titleArray addObject:[info objectForKey:@"name"]];
     }
    self.zixunSegment = [[ZWMSegmentView alloc] initWithFrame:CGRectMake(17.5, CGRectGetMaxY(self.backView.frame), self.backView.hd_width, 44) titles:titleArray];
       __weak typeof(self)weakSelf = self;
       _zixunSegment.backgroundColor=[UIColor whiteColor];
       _zixunSegment.indicateColor = UIRGBColor(237, 0, 0);
    
//       [_zixunSegment selectedAtIndex:^(NSUInteger index, UIButton * _Nonnull button) {
//           if (weakSelf.scategorySelectBlock) {
//               weakSelf.scategorySelectBlock(weakSelf.dataArray[index]);
//           }
//       }];
       [self addSubview:_zixunSegment];
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
