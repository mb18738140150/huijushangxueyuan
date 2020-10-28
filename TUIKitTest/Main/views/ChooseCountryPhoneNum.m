//
//  ChooseCountryPhoneNum.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/27.
//

#import "ChooseCountryPhoneNum.h"

@interface ChooseCountryPhoneNum()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataSource;

@end

@implementation ChooseCountryPhoneNum

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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chineseCountryJson" ofType:@"txt"];
    NSError *error;
    NSString *fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSArray *dicData = [self dictionaryWithJsonString:fileString];
    if (!dicData) {
        return;
    }
    
    for (NSDictionary * info in dicData) {
        NSArray * array = [info objectForKey:@"data"];
        for (NSDictionary * numInfo in array) {
            [self.dataSource addObject:numInfo];
        }
    }
    
    self.backgroundColor = UIColorFromRGB(0xffffff);
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight + kNavigationBarHeight)];
    topView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:topView];
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 100, kStatusBarHeight, 200, kNavigationBarHeight)];
    titleLB.text = @"选择国家和地区";
    titleLB.font = [UIFont boldSystemFontOfSize:17];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLB];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, kStatusBarHeight + (kNavigationBarHeight - 20) / 2, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    
    UILabel * titleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, cell.hd_height)];
    titleLB.text = [self.dataSource[indexPath.row] objectForKey:@"countryName"];
    titleLB.textColor = UIColorFromRGB(0x666666);
    titleLB.font = kMainFont;
    [cell.contentView addSubview:titleLB];
    
    UILabel * numLB = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 0, 80, cell.hd_height)];
    numLB.text = [NSString stringWithFormat:@"+%@", [self.dataSource[indexPath.row] objectForKey:@"phoneCode"]];
    numLB.textColor = UIColorFromRGB(0x666666);
    numLB.font = kMainFont;
    numLB.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:numLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(5, cell.hd_height - 1, kScreenWidth - 10, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [cell.contentView addSubview:separateView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.chooseCountryBlock) {
        self.chooseCountryBlock(self.dataSource[indexPath.row]);
    }
    [self closeAction];
}

- (void)closeAction
{
    [self removeFromSuperview];
}

- (NSArray *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error;
    NSArray * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if(error) {
        return nil;
    }
    return dic;
}


@end
