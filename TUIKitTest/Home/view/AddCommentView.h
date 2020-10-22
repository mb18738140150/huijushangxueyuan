//
//  AddCommentView.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddCommentView : UIView

@property (nonatomic, strong)NSDictionary * info;
@property (nonatomic, copy)void (^sendBlock)(NSDictionary * info);

@end

NS_ASSUME_NONNULL_END
