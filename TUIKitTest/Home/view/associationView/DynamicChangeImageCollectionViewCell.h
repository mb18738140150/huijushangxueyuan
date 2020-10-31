//
//  DynamicChangeImageCollectionViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicChangeImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView * iconImage;
@property (nonatomic, strong)UIButton * closeBtn;
@property (nonatomic, strong)UIImage * info;
@property (nonatomic, copy)void(^closeImageBlock)(UIImage * info);
- (void)refreshUIWith:(UIImage *)info andCanClose:(BOOL)canClose;

@end

NS_ASSUME_NONNULL_END
