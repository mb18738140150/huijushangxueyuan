//
//  LivingImageListView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import "LivingImageListView.h"
#import "LivingImageListTableViewCell.h"
#define kLivingImageListTableViewCell @"LivingImageListTableViewCell"


@interface LivingImageListView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataSource;


@end

@implementation LivingImageListView

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LivingImageListTableViewCell class] forCellReuseIdentifier:kLivingImageListTableViewCell];
    [self addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LivingImageListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kLivingImageListTableViewCell forIndexPath:indexPath];
    [cell resetUIWithInfo:self.dataSource[indexPath.row]];
    __weak typeof(self)weakSelf = self;
    cell.loadImageSuccessBlock = ^(CGSize size) {
        NSMutableDictionary * mInfo = [weakSelf.dataSource objectAtIndex:indexPath.row];
        [mInfo setValue:@(size.width) forKey:@"width"];
        [mInfo setValue:@(size.height) forKey:@"height"];
        
        [weakSelf.tableView reloadData];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * mInfo = [self.dataSource objectAtIndex:indexPath.row];
    float width = [[mInfo objectForKey:@"width"] floatValue];
    float height = [[mInfo objectForKey:@"height"] floatValue];
    if (width > 0) {
        return kScreenWidth * height / width;
    }else
    {
        return 64;
    }
}

- (void)resetDataSource:(NSArray *)imageArray
{
    [self.dataSource removeAllObjects];
    for (NSDictionary * info in imageArray) {
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
        [self.dataSource addObject:mInfo];
    }
}

@end
