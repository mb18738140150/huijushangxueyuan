//
//  LiveGiftSelectView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/7.
//

#import "LiveGiftSelectView.h"
#import "GiftCollectionViewCell.h"
#define kGiftCollectionViewCell @"GiftCollectionViewCell"
#import "PackageCountView.h"

@interface LiveGiftSelectView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSArray * dataSource;

@property (nonatomic, strong)PackageCountView * packageCountView;
@property (nonatomic, strong)UILabel * totalPrice;
@property (nonatomic, strong)UIButton * payBtn;

@property (nonatomic, strong)NSIndexPath * selectIndexPath;
@property (nonatomic, assign)int count;

@end

@implementation LiveGiftSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self prepareUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.count = 1;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:backView];
    
    UIView * giftView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height * 3  / 5, kScreenWidth, 125 + 70)];
    giftView.backgroundColor = [UIColor whiteColor];
    [self addSubview:giftView];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenWidth / 4, 125);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 125) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:kGiftCollectionViewCell];
    [giftView addSubview:self.collectionView];
    
    
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) + 10, kScreenWidth, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [giftView addSubview:seperateView];
    
    UILabel * countLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(seperateView.frame), 50, 60)];
    countLB.text = @"数量";
    countLB.textColor = UIColorFromRGB(0x666666);
    countLB.textAlignment = NSTextAlignmentCenter;
    countLB.font = kMainFont_12;
    [giftView addSubview:countLB];
    
    __weak typeof(self)weakSelf = self;
    self.packageCountView = [[PackageCountView alloc]initWithFrame:CGRectMake(50 ,countLB.hd_centerY - 12 , 85, 30)];
    self.packageCountView.countBlock = ^(int count) {
        weakSelf.count = count;
        [weakSelf resetTotalPrice];
    };
    [giftView addSubview:self.packageCountView];
    
    UILabel * totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.packageCountView.frame) + 10, countLB.hd_centerY - 10, 150, 20)];
    totalPrice.textColor = UIColorFromRGB(0x666666);
    totalPrice.font = kMainFont_12;
    [giftView addSubview:totalPrice];
    self.totalPrice = totalPrice;
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.frame = CGRectMake(giftView.hd_width - 100, countLB.hd_centerY - 15, 80, 30);
    [self.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    self.payBtn.titleLabel.textColor = [UIColor whiteColor];
    self.payBtn.titleLabel.font = kMainFont_12;
    self.payBtn.backgroundColor = UIColorFromRGB(0xF19937);
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.masksToBounds = YES;
    [giftView addSubview:self.payBtn];
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(giftView.hd_width - 40, 0, 40, 40);
    closeBtn.backgroundColor = [UIColor whiteColor];
    [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [giftView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeAction
{
    [self removeFromSuperview];
}

- (void)payAction
{
    NSDictionary * seleInfo = [self.dataSource objectAtIndex:self.selectIndexPath.row];
    NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:seleInfo];
    [mInfo setValue:@(self.count) forKey:@"count"];
    if (self.payBlock) {
        self.payBlock(mInfo);
    }
    [self closeAction];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)resetWithInfoArray:(NSArray *)giftArray
{
    self.dataSource = giftArray;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiftCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGiftCollectionViewCell forIndexPath:indexPath];
    [cell resetWithInfo:self.dataSource[indexPath.item]];
    
    if([indexPath isEqual:self.selectIndexPath])
    {
        [cell resetSelect];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.selectIndexPath isEqual:indexPath]) {
        [self.packageCountView reset];
        self.count = 1;
    }
    
    self.selectIndexPath = indexPath;
    [self.collectionView reloadData];
    
    [self resetTotalPrice];
}

- (void)resetTotalPrice
{
    NSDictionary * selectGiftInfoi = self.dataSource[self.selectIndexPath.item];
    float price = [[selectGiftInfoi objectForKey:@"price"] floatValue];
    
    NSString * totalPriceStr = [NSString stringWithFormat:@"合计 ￥%.2f", self.count * price];
    NSDictionary * attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0xF19937)};
    NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc]initWithString:totalPriceStr];
    [mStr addAttributes:attribute range:NSMakeRange(2, totalPriceStr.length - 2)];
    self.totalPrice.attributedText = mStr;
}

@end
