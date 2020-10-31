//
//  DeleteAssociationDynamicView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/30.
//

#import "DeleteAssociationDynamicView.h"

@interface DeleteAssociationDynamicView()

@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UIButton * deleteBtn;
@property (nonatomic, strong)UIButton * cancelBtn;


@end

@implementation DeleteAssociationDynamicView

- (instancetype)initWithFrame:(CGRect)frame andInfo:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        self.infoDic = info;
        [self prepareUI];
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
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 135, kScreenWidth, 135)];
    bottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton * jingpinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jingpinBtn.frame = CGRectMake(0, 5, kScreenWidth, 40);
    jingpinBtn.backgroundColor = UIColorFromRGB(0xffffff);
    [jingpinBtn setTitle:@"设为精选" forState:UIControlStateNormal];
    [jingpinBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    jingpinBtn.titleLabel.font = kMainFont;
    [bottomView addSubview:jingpinBtn];
    
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 50, kScreenWidth, 40);
    deleteBtn.backgroundColor = UIColorFromRGB(0xffffff);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = kMainFont;
    [bottomView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 95, kScreenWidth, 40);
    cancelBtn.backgroundColor = UIColorFromRGB(0xffffff);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kMainFont;
    [bottomView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    if ([UserManager sharedManager].is_admin) {
        if ([[self.infoDic objectForKey:@"is_show"] intValue] == 1) {
            [jingpinBtn setTitle:@"设为精选" forState:UIControlStateNormal];
        }else
        {
            [jingpinBtn setTitle:@"取消精选" forState:UIControlStateNormal];
        }
    }else
    {
        bottomView.frame = CGRectMake(0, kScreenHeight - 90, kScreenWidth, 90);
        deleteBtn.frame = CGRectMake(0, 5, kScreenWidth, 40);
        cancelBtn.frame = CGRectMake(0, 50, kScreenWidth, 40);
    }
    
    [jingpinBtn addTarget:self action:@selector(jingpinAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshDelete
{
    _bottomView.frame = CGRectMake(0, kScreenHeight - 90, kScreenWidth, 90);
    _deleteBtn.frame = CGRectMake(0, 5, kScreenWidth, 40);
    _cancelBtn.frame = CGRectMake(0, 50, kScreenWidth, 40);
}

- (void)closeAction
{
    if (self.dismissBlock) {
        self.dismissBlock(@{});
    }
    [self removeFromSuperview];
}

- (void)deleteAction
{
    if (self.deleteBlock) {
        self.deleteBlock(self.infoDic);
    }
    [self removeFromSuperview];
}

- (void)jingpinAction
{
    if (self.jingpinBlock) {
        self.jingpinBlock(self.infoDic);
    }
    [self removeFromSuperview];
}

@end
