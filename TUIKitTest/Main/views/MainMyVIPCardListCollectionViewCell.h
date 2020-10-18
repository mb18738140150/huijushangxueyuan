//
//  MainMyVIPCardListCollectionViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainMyVIPCardListCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy)void (^myVIPCardClickBlock)(NSDictionary *info);
- (void)resetUIWithInfoArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
