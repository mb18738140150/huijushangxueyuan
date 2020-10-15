//
//  CustomTUITextMessageCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/5.
//

#import "TUITextMessageCell.h"
#import "MyCustomCellData.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomTUITextMessageCell : TUITextMessageCell

@property UIButton *shangBtn;

@property MyCustomCellData *customData;
- (void)fillWithData:(TUITextMessageCellData *)data;

@end

NS_ASSUME_NONNULL_END
