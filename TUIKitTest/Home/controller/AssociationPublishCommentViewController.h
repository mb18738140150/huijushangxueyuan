//
//  AssociationPublishCommentViewController.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssociationPublishCommentViewController : ViewController

@property (nonatomic, copy)void(^publishBlock)(NSDictionary *info);
@property (nonatomic, strong)NSDictionary * info;

@end

NS_ASSUME_NONNULL_END
