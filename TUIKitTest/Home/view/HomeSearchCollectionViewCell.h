//
//  HomeSearchCollectionViewCell.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeSearchCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy)void(^cancelSearchBlock)(NSDictionary *info);
@property (nonatomic, copy)void(^searchBlock)(NSString *key);
- (void)refreshUIWithData:(NSDictionary *)info;
- (void)resignFirstResponder;
@end

NS_ASSUME_NONNULL_END
