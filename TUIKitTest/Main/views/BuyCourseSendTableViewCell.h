//
//  BuyCourseSendTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyCourseSendTableViewCell : UITableViewCell

@property (nonatomic, strong)UIButton * musBtn;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, strong)UIButton * addBtn;
@property (nonatomic, copy)void(^countBlock)(int count);
- (void)refreshUWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
