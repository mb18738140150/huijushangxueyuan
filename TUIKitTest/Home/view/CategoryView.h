//
//  CategoryView.h
//  Accountant
//
//  Created by aaa on 2017/3/6.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PageMain,
    PageCategory,
    PageMessage,
    PageLeft,
    Page_getIntegral,
    Page_Home,
    page_MyNotification,
    Page_MYBuyCourse,
    Page_MyOrderState,
    Page_Store,
    Page_Store_main,
    Page_ShareAndPay,
    Page_sendCourse,
}PageType;

@interface CategoryView : UIView

@property (nonatomic,strong) UIImageView            *coverImageView;
@property (nonatomic,strong) UILabel                *categoryNameLabel;
@property (nonatomic, strong) UILabel               *numberLabel;

@property (nonatomic,assign) int                     categoryId;
@property (nonatomic,strong) NSString               *categoryName;
@property (nonatomic,strong) NSString               *categoryCoverUrl;
@property (nonatomic, strong)NSString * icon;// 字体
@property (nonatomic, strong)NSString * color;// icon字体颜色
@property (nonatomic, strong)NSString * url;// 外部链接地址
@property (nonatomic, strong)NSString * url_type; //none:无跳转 outer:外部页面 inner:内部页面
@property (nonatomic, strong)NSString * icon_type; // image:图片 icon:图标
@property (nonatomic, strong)NSString * need_redirect;// 内部页面参数

@property (nonatomic, strong)NSDictionary * info;
@property (nonatomic,assign) PageType                pageType;

- (void)setupContents;
- (void)setupNaviContents;

- (void)setupSmallContent;

- (void)resetImageSize:(CGSize)size;
- (void)resetNumber:(NSString *)number;

@end
