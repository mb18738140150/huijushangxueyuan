//
//  MyOrderStateTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import "MyOrderStateTableViewCell.h"
#import "CategoryView.h"

@interface MyOrderStateTableViewCell()
@property (nonatomic, strong)UIView * backView;

@end

@implementation MyOrderStateTableViewCell

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

    NSArray * dataArray = @[@{@"image":@"main_代付款",@"title":@"待付款"},@{@"image":@"main_待发货",@"title":@"待发货"},@{@"image":@"main_待收货",@"title":@"待收货"},@{@"image":@"main_订单icon",@"title":@"所有订单"},@{@"image":@"main_icon",@"title":@"购物车"}];
    
    for (int i = 0; i < 5; i++) {
        NSDictionary * info = dataArray[i];
        CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(self.backView.hd_width / 5 * i , 8, ((self.backView.hd_width)/5), kCellHeightOfCategoryView)];
        cateView.categoryId = 1000 + i;
        cateView.pageType = Page_MyOrderState;
        cateView.categoryName = [info objectForKey:@"title"];
        cateView.categoryCoverUrl = [info objectForKey:@"image"];
        [cateView setupNaviContents];
        [cateView resetImageSize:CGSizeMake(25, 25)];
        [self.backView addSubview:cateView];
    }
    
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(self.backView.hd_width / 5 * 4,10 ,1 ,self.backView.hd_height - 20)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.backView addSubview:separateView];
    
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
