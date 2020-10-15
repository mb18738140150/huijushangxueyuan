//
//  HomeTeacherListCollectionViewCell.m
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "HomeTeacherListCollectionViewCell.h"
#import "TeacherCollectionViewCell.h"
#define kTeacherCollectionViewCellID @"TeacherCollectionViewCellID"

@interface HomeTeacherListCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * collectionview;
@property (nonatomic, strong)NSArray * dataArray;

@end

@implementation HomeTeacherListCollectionViewCell

- (void)refreshWithinfo:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    
    self.dataArray = [info objectForKey:@"data"];
    
    UICollectionViewFlowLayout * layuout = [[UICollectionViewFlowLayout alloc]init];
    layuout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layuout.itemSize = CGSizeMake(70, 116);
    layuout.minimumInteritemSpacing = 20;
    
    self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(17.5, 0, self.hd_width - 35, 116) collectionViewLayout:layuout];
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    [self.collectionview registerClass:[TeacherCollectionViewCell class] forCellWithReuseIdentifier:kTeacherCollectionViewCellID];
    [self.contentView addSubview:self.collectionview];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTeacherCollectionViewCellID forIndexPath:indexPath];
    [cell refreshWithInfo:self.dataArray[indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click %@", self.dataArray[indexPath.item]);
}

@end
