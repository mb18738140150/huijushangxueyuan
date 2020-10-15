//
//  LivingShareListView.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivingShareListView : UIView

@property (nonatomic, copy)void (^moreShareListBlock)(BOOL isFirst);
- (void)addDataSource:(NSArray *)newDataSource withFirstPage:(BOOL)firstPage;

@end

NS_ASSUME_NONNULL_END
