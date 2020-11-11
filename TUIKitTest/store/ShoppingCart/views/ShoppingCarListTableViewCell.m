//
//  ShoppingCarListTableViewCell.m
//  lanhailieren
//
//  Created by aaa on 2020/3/10.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ShoppingCarListTableViewCell.h"


@implementation ShoppingCarListTableViewCell

- (void)refreshUIWithInfo:(NSDictionary *)info isCanSelect:(BOOL)select
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.frame = self.bounds;
    self.info = info;
    
    if (select) {
        [self refreshSelectUIWithInfo:info];
    }else{
        [self refreshUIWithInfo:info];
    }
}

- (void)refreshSelectUIWithInfo:(NSDictionary *)info
{
    self.info = info;
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(10, self.hd_height / 2 - 7, 15, 15);
    [selectBtn setImage:[UIImage imageNamed:@"shoppingCar_selected"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"shoppingCar_unselected"] forState:UIControlStateNormal];
    self.selectBtn = selectBtn;
    [selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectBtn];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame) + 10, 10, 85, 60)];
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[info objectForKey:@"thumb"]]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"] options:SDWebImageAllowInvalidSSLCertificates];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y, self.hd_width - 120 - 35, 15)];
    self.titleLB.text = [info objectForKey:@"title"];
    self.titleLB.font = [UIFont systemFontOfSize:12];
    self.titleLB.textColor = UIColorFromRGB(0x000000);
    [self.contentView addSubview:self.titleLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y + 15, self.hd_width - 200, 15)];
    self.priceLB.font = [UIFont systemFontOfSize:12];
    self.priceLB.textColor = kCommonMainBlueColor;
    [self.contentView addSubview:self.priceLB];
    NSString * priceLB = [NSString stringWithFormat:@"￥%@", [info objectForKey:@"price"]];
    self.priceLB.text = priceLB;
    
    __weak typeof(self)weakSelf = self;
    self.packageCountView = [[PackageCountView alloc]initWithFrame:CGRectMake(self.priceLB.hd_x , CGRectGetMaxY(self.priceLB.frame), 85, 30)];
    self.packageCountView.countBlock = ^(int count) {
        weakSelf.buyCount = count;
        if (weakSelf.countBlock) {
            weakSelf.countBlock(count);
        }
    };
    self.packageCountView.countLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"count"]];
    
    [self.contentView addSubview:self.packageCountView];
    
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth - 40, self.packageCountView.hd_y + 10, 20, 20);
    [deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [self.contentView addSubview:deleteBtn];
    
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, self.contentView.hd_height - 1, self.hd_width - 30, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xececec);
    [self.contentView addSubview:seperateView];
}

- (void)refreshUIWithInfo:(NSDictionary *)info
{
   
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"]];
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y, self.hd_width - 120, 20)];
    self.titleLB.text = [info objectForKey:@"title"];
    self.titleLB.font = [UIFont systemFontOfSize:12];
    self.titleLB.textColor = UIColorFromRGB(0x000000);
    [self.contentView addSubview:self.titleLB];
    
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y + 40, self.hd_width - 200, 20)];
    self.priceLB.font = [UIFont systemFontOfSize:12];
    self.priceLB.textColor = kCommonMainBlueColor;
    [self.contentView addSubview:self.priceLB];
    NSString * priceLB = [NSString stringWithFormat:@"￥%@", [info objectForKey:@"price"]];
    self.priceLB.text = priceLB;
    
    self.tipLB = [[UILabel alloc]initWithFrame:CGRectMake(self.hd_width - 200, self.iconImageView.hd_y + 40, 180, 20)];
    self.tipLB.textColor = UIColorFromRGB(0x666666);
    self.tipLB.textAlignment = NSTextAlignmentRight;
    self.tipLB.text = [NSString stringWithFormat:@"x%@", [info objectForKey:@"count"]];
    self.tipLB.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.tipLB];
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, self.contentView.hd_height - 1, self.hd_width - 30, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xececec);
    [self.contentView addSubview:seperateView];
}

- (void)refreshOrderDetailCellWith:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.info = info;
   
    UIView * whriteView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, self.hd_height)];
    whriteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whriteView];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"]];
//    self.iconImageView.layer.cornerRadius = 5;
//    self.iconImageView.layer.masksToBounds = YES;
    [backView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y, backView.hd_width - 120, 20)];
    self.titleLB.text = [info objectForKey:@"title"];
    self.titleLB.font = [UIFont systemFontOfSize:12];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    [backView addSubview:self.titleLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y + 40, backView.hd_width - 200, 20)];
    self.priceLB.font = [UIFont systemFontOfSize:12];
    self.priceLB.textColor = UIColorFromRGB(0x666666);
    [backView addSubview:self.priceLB];
    NSString * priceLB = [NSString stringWithFormat:@"x%@", [UIUtility judgeStr:[info objectForKey:@"number"]]];
    self.priceLB.text = priceLB;
    
    self.tipLB = [[UILabel alloc]initWithFrame:CGRectMake(backView.hd_width - 200, self.iconImageView.hd_y + 40, 180, 20)];
    self.tipLB.textColor = UIColorFromRGB(0x111111);
    self.tipLB.textAlignment = NSTextAlignmentRight;
    NSString * price = [NSString stringWithFormat:@"%.2f", [[info objectForKey:@"pay_money"] floatValue] * [[info objectForKey:@"number"] intValue]];
    self.tipLB.text = [NSString stringWithFormat:@"￥%@", price];
    self.tipLB.font = [UIFont boldSystemFontOfSize:14];
    [backView addSubview:self.tipLB];
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, self.contentView.hd_height - 1, backView.hd_width - 30, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    [self.contentView addSubview:seperateView];
}


- (void)refreshOrderCellWith:(NSDictionary *)info
{
    [self.contentView removeAllSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.info = info;
   
    UIView * whriteView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, self.hd_height)];
    whriteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whriteView];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:backView];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"courseDefaultImage"]];
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.masksToBounds = YES;
    [backView addSubview:self.iconImageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y, backView.hd_width - 120, 20)];
    self.titleLB.text = [info objectForKey:@"title"];
    self.titleLB.font = [UIFont systemFontOfSize:12];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    [backView addSubview:self.titleLB];
    
    self.priceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.hd_y + 40, backView.hd_width - 200, 20)];
    self.priceLB.font = [UIFont systemFontOfSize:12];
    self.priceLB.textColor = UIColorFromRGB(0x666666);
    [backView addSubview:self.priceLB];
    NSString * priceLB = [NSString stringWithFormat:@"x%@", [UIUtility judgeStr:[info objectForKey:@"number"]]];
    self.priceLB.text = priceLB;
    
    self.tipLB = [[UILabel alloc]initWithFrame:CGRectMake(backView.hd_width - 200, self.iconImageView.hd_y + 40, 180, 20)];
    self.tipLB.textColor = UIColorFromRGB(0x111111);
    self.tipLB.textAlignment = NSTextAlignmentRight;
    NSString * price = [NSString stringWithFormat:@"%.2f", [[info objectForKey:@"pay_money"] floatValue] * [[info objectForKey:@"number"] intValue]];
    self.tipLB.text = [NSString stringWithFormat:@"￥%@", price];
    self.tipLB.font = [UIFont boldSystemFontOfSize:14];
    [backView addSubview:self.tipLB];
    
    UIView * seperateView = [[UIView alloc]initWithFrame:CGRectMake(15, self.contentView.hd_height - 1, backView.hd_width - 30, 1)];
    seperateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    [self.contentView addSubview:seperateView];
}


- (void)selectAction
{
    if (self.selectBtnClickBlock) {
        self.selectBtnClickBlock(self.info,self.selectBtn.selected);
    }
}

- (void)deleteAction
{
    if (self.deleteBlock) {
        self.deleteBlock(self.info);
    }
}

- (void)resetSelectState:(BOOL)select
{
    self.selectBtn.selected = select;
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
