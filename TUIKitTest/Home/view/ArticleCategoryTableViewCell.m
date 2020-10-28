//
//  ArticleCategoryTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/26.
//

#import "ArticleCategoryTableViewCell.h"
#import "YMTextData.h"
#import "WFTextView.h"
#import "ILRegularExpressionManager.h"
#import "NSString+NSString_ILExtension.h"

@interface ArticleCategoryTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSArray * dataSource;

@end

@implementation ArticleCategoryTableViewCell

- (void)refreshUIWith:(NSDictionary *)infoDic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView removeAllSubviews];
    
    UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 20)];
    tipLB.text = @"分类";
    tipLB.font = kMainFont_12;
    tipLB.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:tipLB];
    
    NSArray * category = [[infoDic objectForKey:@"categories"] objectForKey:@"data"];
    self.dataSource = category;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipLB.frame) + 10, 0, kScreenWidth - 65, 20) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.contentView addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    cell.backgroundColor = UIColorFromRGB(0xffffff);
    NSString * contentStr = [NSString stringWithFormat:@"#%@#", [self.dataSource[indexPath.item] objectForKey:@"name"]];
    CGFloat width = [contentStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.width;
    
    UILabel * contentLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width + 10, 20)];
    contentLB.font = kMainFont;
    contentLB.text = contentStr;
    contentLB.textColor = kCommonMainBlueColor;
    contentLB.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:contentLB];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * contentStr = [NSString stringWithFormat:@"#%@#", [self.dataSource[indexPath.item] objectForKey:@"name"]];
    CGFloat width = [contentStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.width;
    
    return CGSizeMake(width + 10, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.categoryClickBLock) {
        self.categoryClickBLock(self.dataSource[indexPath.item]);
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
