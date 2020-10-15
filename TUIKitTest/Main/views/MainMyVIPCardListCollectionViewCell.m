//
//  MainMyVIPCardListCollectionViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import "MainMyVIPCardListCollectionViewCell.h"
#import "MyVIPCardCollectionViewCell.h"

@interface MainMyVIPCardListCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSArray * dataSource;

@end

@implementation MainMyVIPCardListCollectionViewCell

- (void)resetUIWithInfoArray:(NSArray *)array
{
    self.dataSource = array;
    [self.contentView removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel * topLN = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 30)];
    topLN.text = @"我的会员卡";
    topLN.textColor = UIColorFromRGB(0x333333);
    topLN.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:topLN];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 20;
    layout.itemSize = CGSizeMake(kScreenWidth / 3, (kScreenWidth / 3 - 30) / 3 + 50 + 30 );
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLN.frame), kScreenWidth, (kScreenWidth / 3 - 30) / 3 + 50 + 30) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MyVIPCardCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyVIPCardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    [cell refreshUIWith:self.dataSource[indexPath.item]];
    return cell;
}

@end
