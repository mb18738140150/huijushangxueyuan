//
//  ArticleAudioTableViewCell.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleAudioTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, strong)UIButton * playBtn;
@property (nonatomic, strong)UILabel * currentLB;
@property (nonatomic, strong)UILabel * durationLB;
@property (nonatomic, strong)UISlider *progressSlider;

@property (nonatomic, copy)void (^playActionBlock)(NSDictionary *info);
- (void)refreshUIWith:(NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END
