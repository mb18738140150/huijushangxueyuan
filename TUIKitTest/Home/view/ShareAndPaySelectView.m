//
//  ShareAndPaySelectView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/23.
//

#import "ShareAndPaySelectView.h"
#import "CategoryView.h"

@interface ShareAndPaySelectView()

@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)CategoryView * weixinCatView;
@property (nonatomic, strong)CategoryView * zhiCatView;


@end

@implementation ShareAndPaySelectView


- (instancetype)initWithFrame:(CGRect)frame andIsShare:(BOOL)isShare
{
    self = [super initWithFrame:frame];
    if (self) {
        if (isShare) {
            [self prepareShareUI];
        }else
        {
            
            [self prepareUI];
        }
    }
    return self;
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
    [backView addGestureRecognizer:tap];
    
    UIView * giftView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200)];
    giftView.backgroundColor = [UIColor whiteColor];
    [self addSubview:giftView];
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:giftView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = giftView.bounds;
    shapLayer.path = bezierpath.CGPath;
    [giftView.layer setMask: shapLayer];
    
    UILabel * topLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 40)];
    topLB.backgroundColor = UIColorFromRGB(0xf2f2f2);
    topLB.text = @"请选择支付方式";
    topLB.font = kMainFont;
    topLB.textColor = UIColorFromRGB(0x333333);
    topLB.textAlignment = NSTextAlignmentCenter;
    [giftView addSubview:topLB];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kScreenWidth - 30, 10, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [giftView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(kScreenWidth / 5 , 70, ((kScreenWidth)/5), kCellHeightOfCategoryView)];
    cateView.categoryId = CategoryType_wechatPay;
    cateView.pageType = Page_ShareAndPay;
    cateView.categoryName = @"微信支付";
    cateView.categoryCoverUrl = @"weixinzhifu";
    [cateView setupNaviContents];
    [giftView addSubview:cateView];
    self.weixinCatView = cateView;
    
    CategoryView *zhiView = [[CategoryView alloc] initWithFrame:CGRectMake(kScreenWidth / 5 * 3 , 70, ((kScreenWidth)/5), kCellHeightOfCategoryView)];
    zhiView.categoryId = CategoryType_zhifubPay;
    zhiView.pageType = Page_ShareAndPay;
    zhiView.categoryName = @"支付宝支付";
    zhiView.categoryCoverUrl = @"zhifubao";
    [zhiView setupNaviContents];
    [giftView addSubview:zhiView];
    self.zhiCatView = zhiView;
    
}

- (void)prepareShareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
    [backView addGestureRecognizer:tap];
    
    UIView * giftView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200)];
    giftView.backgroundColor = [UIColor whiteColor];
    [self addSubview:giftView];
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:giftView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.frame = giftView.bounds;
    shapLayer.path = bezierpath.CGPath;
    [giftView.layer setMask: shapLayer];
    
    
    
    UILabel * topLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 40)];
    topLB.backgroundColor = UIColorFromRGB(0xf2f2f2);
    topLB.text = @"请选择分享方式";
    topLB.font = kMainFont;
    topLB.textColor = UIColorFromRGB(0x333333);
    topLB.textAlignment = NSTextAlignmentCenter;
    [giftView addSubview:topLB];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kScreenWidth - 30, 10, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [giftView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(kScreenWidth / 5 , 70, ((kScreenWidth)/5), kCellHeightOfCategoryView)];
    cateView.categoryId = CategoryType_shareFriend;
    cateView.pageType = Page_ShareAndPay;
    cateView.categoryName = @"微信朋友";
    cateView.categoryCoverUrl = @"微信";
    [cateView setupNaviContents];
    [giftView addSubview:cateView];
    self.weixinCatView = cateView;
    
    CategoryView *zhiView = [[CategoryView alloc] initWithFrame:CGRectMake(kScreenWidth / 5 * 3 , 70, ((kScreenWidth)/5), kCellHeightOfCategoryView)];
    zhiView.categoryId = CategoryType_shareCircle;
    zhiView.pageType = Page_ShareAndPay;
    zhiView.categoryName = @"朋友圈";
    zhiView.categoryCoverUrl = @"朋友圈";
    [zhiView setupNaviContents];
    [giftView addSubview:zhiView];
    self.zhiCatView = zhiView;
    
}


- (void)closeAction{
    [self removeFromSuperview];
}


@end
