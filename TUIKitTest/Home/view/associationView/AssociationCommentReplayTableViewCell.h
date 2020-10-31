//
//  AssociationCommentReplayTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/29.
//

#import <UIKit/UIKit.h>
#import "WFReplyBody.h"
#import "YMTextData.h"
#import "WFMessageBody.h"
#import "WFTextView.h"

NS_ASSUME_NONNULL_BEGIN


@interface AssociationCommentReplayTableViewCell : UITableViewCell<WFCoretextDelegate>

@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * contentLB;
@property (nonatomic, strong)UILabel * timeLb;
@property (nonatomic, strong)UIButton * commentBtn;

@property (nonatomic, strong)NSDictionary * info;
@property (nonatomic, copy)void(^commentBlock)(NSDictionary * info);
@property (nonatomic, copy)void(^operationCommentBlock)(NSDictionary * info,NSDictionary * dynamicInfo);

- (void)refreshUIWith:(YMTextData *)ymData;
@end

NS_ASSUME_NONNULL_END
