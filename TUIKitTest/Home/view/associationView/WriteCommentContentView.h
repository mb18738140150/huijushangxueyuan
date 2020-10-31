//
//  WriteCommentContentView.h
//  lanhailieren
//
//  Created by aaa on 2020/4/17.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPPlaceholderTextView.h"

@interface WriteCommentContentView : UIView

@property (nonatomic, strong)MKPPlaceholderTextView * textView;

@property (nonatomic, strong)UIButton * goodBtn;
@property (nonatomic, strong)UIButton * commentBtn;
@property (nonatomic, strong)UIButton * collectBtn;
@property (nonatomic, strong)UIButton * shareBtn;

@property (nonatomic, copy)void (^goodBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^commentBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^collectBlock)(NSDictionary * info);
@property (nonatomic, copy)void (^shareBlock)(NSDictionary * info);

@property (nonatomic, copy)void (^commitBlock)(NSString * comment);

@property (nonatomic, strong)NSDictionary * infoDic;

- (void)textViewResignFirstResponder;
- (void)textViewBecomeFirstResponder;

- (instancetype)initWithFrame:(CGRect)frame andInfo:(NSDictionary *)info;

- (void)refreshUIWithInfo:(NSDictionary *)info;

- (void)hideOperationBtn;
- (void)showOperationBtn;

@end

