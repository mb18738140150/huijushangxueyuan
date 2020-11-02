//
//  AssociationRelevanceCourseView.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/2.
//

#import "AssociationRelevanceCourseView.h"
#import "AssociationRelevanceCourseTableViewCell.h"
#define kAssociationRelevanceCourseTableViewCell @"AssociationRelevanceCourseTableViewCell"


@interface AssociationRelevanceCourseView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * array;

@end

@implementation AssociationRelevanceCourseView

- (instancetype)initWithFrame:(CGRect)frame andCourseArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.array = array;
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
    
    UIView * courseView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight / 2, kScreenWidth, kScreenHeight / 2)];
    courseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:courseView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AssociationRelevanceCourseTableViewCell class] forCellReuseIdentifier:kAssociationRelevanceCourseTableViewCell];
    [courseView addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssociationRelevanceCourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kAssociationRelevanceCourseTableViewCell forIndexPath:indexPath];
    [cell resetCellContent:self.array[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 0, 200, 50)];
    titleLB.text = @"相关商品";
    titleLB.font = kMainFont_16;
    titleLB.textColor = UIColorFromRGB(0x333333);
    [headerView addSubview:titleLB];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.courseBlock) {
        self.courseBlock(self.array[indexPath.row]);
    }
    [self closeAction];
}

- (void)closeAction{
    [self removeFromSuperview];
}
@end
