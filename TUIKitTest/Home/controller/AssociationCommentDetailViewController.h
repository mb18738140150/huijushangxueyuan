//
//  AssociationCommentDetailViewController.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssociationCommentDetailViewController : ViewController

@property (nonatomic, strong)NSDictionary * associationInfo;
@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy)void(^commentBlock)(NSDictionary * info);
@property (nonatomic, copy)void(^deleteBlock)(NSDictionary * info);

@end

NS_ASSUME_NONNULL_END
