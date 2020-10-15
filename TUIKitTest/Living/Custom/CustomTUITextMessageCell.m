//
//  CustomTUITextMessageCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/5.
//

#import "CustomTUITextMessageCell.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
#import "UIColor+TUIDarkMode.h"
#import "THeader.h"

@implementation CustomTUITextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _shangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shangBtn.frame = CGRectMake(self.avatarView.hd_x / 4, CGRectGetMaxY(self.avatarView.frame) + 5, self.avatarView.hd_width / 2, self.avatarView.hd_height / 2);
        _shangBtn.layer.cornerRadius = _shangBtn.hd_height / 2;
        _shangBtn.layer.masksToBounds = YES;
        _shangBtn.backgroundColor = [UIColor grayColor];
        [_shangBtn setTitle:@"赏" forState:UIControlStateNormal];
        [_shangBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [self.contentView addSubview:_shangBtn];

    }
    return self;
}

- (void)fillWithData:(TUITextMessageCellData *)data;
{
    //set data
    [super fillWithData:data];
    self.textData = data;
    self.content.attributedText = data.attributedString;
    self.content.textColor = data.textColor;
//  font set in attributedString
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _shangBtn.frame = CGRectMake(self.avatarView.hd_width / 4 + self.avatarView.hd_x, CGRectGetMaxY(self.avatarView.frame) + 5, self.avatarView.hd_width / 2, self.avatarView.hd_height / 2);
    _shangBtn.layer.cornerRadius = _shangBtn.hd_height / 2;
    _shangBtn.layer.masksToBounds = YES;
//    _shangBtn.backgroundColor = [UIColor grayColor];
//    [_shangBtn setTitle:@"赏" forState:UIControlStateNormal];
//    [_shangBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.contentView addSubview:_shangBtn];
}
@end
