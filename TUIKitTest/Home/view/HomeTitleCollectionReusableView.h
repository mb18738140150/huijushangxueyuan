//
//  HomeTitleCollectionReusableView.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTitleCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong)UILabel * titleView;
@property (nonatomic, strong)UIButton * moreBtn;
@property (nonatomic, copy)void (^moreBlock)(NSDictionary * info);
@property (nonatomic, strong)NSDictionary * info;
- (void)resetUIWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
