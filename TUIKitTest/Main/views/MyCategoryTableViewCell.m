//
//  MyCategoryTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import "MyCategoryTableViewCell.h"

#import "CategoryView.h"

@interface MyCategoryTableViewCell()

@property (nonatomic, strong)CategoryView * myNotificationView;
@property (nonatomic, strong)CategoryView * myCourseView;

@property (nonatomic, strong)UIView * backView;

@end

@implementation MyCategoryTableViewCell


- (void)resetUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(12, 5, self.hd_width - 24, 86)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.shadowColor = UIColorFromRGB(0xf1f1f1).CGColor;
    self.backView.layer.shadowOpacity = 3;
    self.backView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.backView.layer.shadowRadius = 3;
    
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(self.backView.hd_width / 4 - (kScreenWidth)/8 , 8, ((kScreenWidth)/4), kCellHeightOfCategoryView)];
    cateView.categoryId = CategoryType_myNotification;
    cateView.pageType = page_MyNotification;
    cateView.categoryName = @"我的消息";
    cateView.categoryCoverUrl = @"main_我的消息";
    [cateView setupNaviContents];
    if ([UserManager sharedManager].news_num > 0) {
        [cateView resetNumber:[NSString stringWithFormat:@"%d", [UserManager sharedManager].news_num]];
    }
    [self.backView addSubview:cateView];
    self.myNotificationView = cateView;
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(self.backView.hd_width / 2 - 1,10 ,2 ,self.backView.hd_height - 20)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.backView addSubview:separateView];
    
    CategoryView *mycateView = [[CategoryView alloc] initWithFrame:CGRectMake(self.backView.hd_width / 4 * 3 - (kScreenWidth)/8 , 8, ((kScreenWidth)/4), kCellHeightOfCategoryView)];
    mycateView.categoryId = CategoryType_myBuyCourse;
    mycateView.pageType = page_MyNotification;
    mycateView.categoryName = @"已购课程";
    mycateView.categoryCoverUrl = @"main_课程";
    [mycateView setupNaviContents];
    [self.backView addSubview:mycateView];
    self.myCourseView = mycateView;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
