//
//  LivingRightTabbarView.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/9.
//

#import "LivingRightTabbarView.h"


@interface LivingRightTabbarView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic, assign)BOOL isTeacher;

@property (nonatomic, strong)NSDictionary * info;

@end

@implementation LivingRightTabbarView

- (instancetype)initWithFrame:(CGRect)frame andIsTeacher:(BOOL)isTeacher andInfo:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        self.info = [[info objectForKey:@"setting"] objectForKey:@"shop"];
        self.isTeacher = isTeacher;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    
    self.backgroundColor = [UIColor clearColor];
    self.dataSource = [self getDataWithIsTeacher:self.isTeacher];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
    
}

- (NSArray *)getDataWithIsTeacher:(BOOL)isTeacher
{
    NSArray * dataSource ;
    
    if (isTeacher) {
        if ([[self.info objectForKey:@"open"] boolValue]) {
            
            if([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue])
            {
                dataSource = @[@{@"name":@"操作",@"color":UIRGBColor(248, 145, 48),@"type":@(RightTabbarOperationType_shutUp)},
                               @{@"name":@"模拟V",@"color":UIRGBColor(60, 186, 191),@"type":@(RightTabbarOperationType_moniV)},
                               @{@"name":@"模拟P",@"color":UIRGBColor(65, 78, 176),@"type":@(RightTabbarOperationType_moniP)},
                               @{@"name":@"VIP",@"color":UIRGBColor(249, 0, 137),@"type":@(RightTabbarOperationType_VIP)},
                               @{@"name":@"合伙人",@"color":UIRGBColor(4, 123, 22),@"type":@(RightTabbarOperationType_Hehuoren)},
                               @{@"name":@"客服",@"color":UIRGBColor(92, 75, 195),@"type":@(RightTabbarOperationType_store),@"image":@"livingShoppingCar"}];
                
            }else
            {
                dataSource = @[@{@"name":@"操作",@"color":UIRGBColor(248, 145, 48),@"type":@(RightTabbarOperationType_shutUp)},
                               @{@"name":@"模拟V",@"color":UIRGBColor(60, 186, 191),@"type":@(RightTabbarOperationType_moniV)},
                               @{@"name":@"模拟P",@"color":UIRGBColor(65, 78, 176),@"type":@(RightTabbarOperationType_moniP)},
                               @{@"name":@"客服",@"color":UIRGBColor(92, 75, 195),@"type":@(RightTabbarOperationType_store),@"image":@"livingShoppingCar"}];
            }
            
        }else
        {
            if([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue])
            {
                
                dataSource = @[@{@"name":@"操作",@"color":UIRGBColor(248, 145, 48),@"type":@(RightTabbarOperationType_shutUp)},
                               @{@"name":@"模拟V",@"color":UIRGBColor(60, 186, 191),@"type":@(RightTabbarOperationType_moniV)},
                               @{@"name":@"模拟P",@"color":UIRGBColor(65, 78, 176),@"type":@(RightTabbarOperationType_moniP)},
                               @{@"name":@"VIP",@"color":UIRGBColor(249, 0, 137),@"type":@(RightTabbarOperationType_VIP)},
                               @{@"name":@"合伙人",@"color":UIRGBColor(4, 123, 22),@"type":@(RightTabbarOperationType_Hehuoren)}];
            }else
            {
                dataSource = @[@{@"name":@"操作",@"color":UIRGBColor(248, 145, 48),@"type":@(RightTabbarOperationType_shutUp)},
                               @{@"name":@"模拟V",@"color":UIRGBColor(60, 186, 191),@"type":@(RightTabbarOperationType_moniV)},
                               @{@"name":@"模拟P",@"color":UIRGBColor(65, 78, 176),@"type":@(RightTabbarOperationType_moniP)}];
            }
        }
    }else
    {
        if ([[self.info objectForKey:@"open"] boolValue]) {
            if([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue])
            {
                dataSource = @[
                    @{@"name":@"VIP",@"color":UIRGBColor(249, 0, 137),@"type":@(RightTabbarOperationType_VIP)},
                    @{@"name":@"合伙人",@"color":UIRGBColor(4, 123, 22),@"type":@(RightTabbarOperationType_Hehuoren)},
                    @{@"name":@"客服",@"color":UIRGBColor(92, 75, 195),@"type":@(RightTabbarOperationType_store),@"image":@"livingShoppingCar"}];
            }else
            {
                dataSource = @[
                    @{@"name":@"客服",@"color":UIRGBColor(92, 75, 195),@"type":@(RightTabbarOperationType_store),@"image":@"livingShoppingCar"}];
            }
            
        }else
        {
            if([WXApi isWXAppSupportApi] && [WXApi isWXAppInstalled] && [[UserManager sharedManager] getUserId] != [kAppointUserID intValue])
            {
                dataSource = @[
                    @{@"name":@"VIP",@"color":UIRGBColor(249, 0, 137),@"type":@(RightTabbarOperationType_VIP)},
                    @{@"name":@"合伙人",@"color":UIRGBColor(4, 123, 22),@"type":@(RightTabbarOperationType_Hehuoren)}];
            }else
            {
                dataSource = @[];
            }
            
        }
    }
    
    return dataSource;
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
    UILabel * contentLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 33, 33)];
    NSDictionary * info = [self.dataSource objectAtIndex:indexPath.row];
    contentLB.text = [info objectForKey:@"name"];
    contentLB.font = kMainFont_10;
    contentLB.textColor = [UIColor whiteColor];
    contentLB.textAlignment = NSTextAlignmentCenter;
    contentLB.backgroundColor = [info objectForKey:@"color"];
    contentLB.layer.cornerRadius = contentLB.hd_height / 2;
    contentLB.layer.masksToBounds = YES;
    [cell.contentView addSubview:contentLB];
    cell.backgroundColor = [UIColor clearColor];
    
    if([info objectForKey:@"image"])
    {
        UIImageView * imageVIew = [[UIImageView alloc]initWithFrame:contentLB.frame];
        imageVIew.image = [UIImage imageNamed:[info objectForKey:@"image"]];
        imageVIew.layer.cornerRadius = imageVIew.hd_height / 2;
        imageVIew.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageVIew];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rightTabbarActionBlock) {
        self.rightTabbarActionBlock(self.dataSource[indexPath.row]);
    }
}

@end
