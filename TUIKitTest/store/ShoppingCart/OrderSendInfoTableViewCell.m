//
//  OrderSendInfoTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/11/5.
//

#import "OrderSendInfoTableViewCell.h"

@implementation OrderSendInfoTableViewCell

-(void)refreshUIWithInfo:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView removeAllSubviews];
    self.info = info;
    
    NSDictionary * addressInfo;
    if ([[self.info objectForKey:@"buy_type"] intValue] == 1) {
        addressInfo = [self.info objectForKey:@"express"];
    }else
    {
        addressInfo = [self.info objectForKey:@"took"];
    }
    // 150
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.hd_width - 20, self.hd_height - 10)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    UILabel * stateLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, backView.hd_width - 20, 15)];
    stateLB.textColor = UIColorFromRGB(0x111111);
    stateLB.font = [UIFont boldSystemFontOfSize:14];
    [backView addSubview:stateLB];
    
    UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(stateLB.frame), backView.hd_width - 20, 15)];
    nameLB.text = [NSString stringWithFormat:@"姓名：%@", [addressInfo objectForKey:@"name"]];
    nameLB.textColor = UIColorFromRGB(0x666666);
    nameLB.font = kMainFont;
    [backView addSubview:nameLB];
    
    UILabel * mobileLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(nameLB.frame), backView.hd_width - 20, 15)];
    mobileLB.text = [NSString stringWithFormat:@"电话：%@", [addressInfo objectForKey:@"mobile"]];
    mobileLB.textColor = UIColorFromRGB(0x666666);
    mobileLB.font = kMainFont;
    [backView addSubview:mobileLB];
    
    UILabel * addressLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(mobileLB.frame), backView.hd_width - 20, 15)];
    addressLB.textColor = UIColorFromRGB(0x666666);
    addressLB.font = kMainFont;
    [backView addSubview:addressLB];
    
    UILabel * sendCompanyLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(addressLB.frame), backView.hd_width - 20, 15)];
    sendCompanyLB.text = [NSString stringWithFormat:@"快递商：%@", [addressInfo objectForKey:@"express_name"]];
    sendCompanyLB.textColor = UIColorFromRGB(0x666666);
    sendCompanyLB.font = kMainFont;
    [backView addSubview:sendCompanyLB];
    
    UILabel * sendNumLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + CGRectGetMaxY(sendCompanyLB.frame), backView.hd_width - 20, 15)];
    sendNumLB.textColor = UIColorFromRGB(0x666666);
    sendNumLB.text = [NSString stringWithFormat:@"快递单号：%@", [addressInfo objectForKey:@"express_order"]];
    sendNumLB.font = kMainFont;
    [backView addSubview:sendNumLB];
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(addressLB.frame) + 10, backView.hd_width - 20, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
    sendCompanyLB.hidden = YES;
    sendNumLB.hidden = YES;
    if ([[info objectForKey:@"status"] isEqualToString:@"shipped"] && [[info objectForKey:@"buy_type"] intValue] == 1) {
        sendCompanyLB.hidden = NO;
        sendNumLB.hidden = NO;
        separateView.frame = CGRectMake(10, CGRectGetMaxY(sendNumLB.frame) + 10, backView.hd_width - 20, 1);
    }
    
    UIButton * connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connectBtn.frame = CGRectMake(backView.hd_width / 2 - 50, CGRectGetMaxY(separateView.frame), 100, 40);
    [connectBtn setImage:[UIImage imageNamed:@"address_dianhua"] forState:UIControlStateNormal];
    [connectBtn setTitle:@" 联系商家" forState:UIControlStateNormal];
    [connectBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    connectBtn.titleLabel.font = kMainFont;
    [connectBtn addTarget:self action:@selector(connectAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:connectBtn];
    
    
    if ([[info objectForKey:@"buy_type"] intValue] == 1) {
        stateLB.text = @"配送信息";
        addressLB.text = [NSString stringWithFormat:@"配送地址：%@", [addressInfo objectForKey:@"address"]];
    }else
    {
        stateLB.text = @"自提信息";
        addressLB.text = [NSString stringWithFormat:@"自提地址：%@", [addressInfo objectForKey:@"address"]];
    }
}

- (void)connectAction
{
    if (self.connectBlock) {
        self.connectBlock(self.info);
    }
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
