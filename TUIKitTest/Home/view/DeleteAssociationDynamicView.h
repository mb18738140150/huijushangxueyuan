//
//  DeleteAssociationDynamicView.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeleteAssociationDynamicView : UIView

@property (nonatomic, strong)NSDictionary *infoDic;
@property (nonatomic, copy)void (^jingpinBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^deleteBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^dismissBlock)(NSDictionary * info);

- (instancetype)initWithFrame:(CGRect)frame andInfo:(NSDictionary *)info;
- (void)refreshDelete;

@end

NS_ASSUME_NONNULL_END
