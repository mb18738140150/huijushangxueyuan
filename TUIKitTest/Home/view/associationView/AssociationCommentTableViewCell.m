//
//  AssociationCommentTableViewCell.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "AssociationCommentTableViewCell.h"

@interface AssociationCommentTableViewCell()

@property (nonatomic, strong)UIImageView * courseCover;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UILabel * qunzhuLB;
@property (nonatomic, strong)UILabel * jingpinLB;
@property (nonatomic, strong)UIButton *deleteBtn;
@property (nonatomic, strong)UIImageView * deleteImageView;

@property (nonatomic, strong)UILabel * timeLB;

@property (nonatomic, strong)UILabel * contentLB;

@property (nonatomic, strong)UIButton * zanBtn;
@property (nonatomic, strong)UIButton * commentBtn;

@property (nonatomic, strong)NSArray * imageUrlArray;


@end

@implementation AssociationCommentTableViewCell

- (void)refreshUIWith:(NSDictionary *)info andIsCanOperation:(BOOL)canOperation
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.infoDic = info;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 0, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    
    self.courseCover = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30,  30)];
    [self.courseCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseCover.layer.cornerRadius = self.courseCover.hd_height / 2;
    self.courseCover.layer.masksToBounds = YES;
    [backView addSubview:self.courseCover];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCover.frame) + 10, self.courseCover.hd_y, self.hd_width - 30, 15)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.numberOfLines = 0;
    self.titleLB.text = [NSString stringWithFormat:@"c_name"];
    [backView addSubview:self.titleLB];
    [self.titleLB sizeToFit];
    
    self.qunzhuLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLB.frame) + 5, 15, 30, 15)];
    self.qunzhuLB.text = @"群主";
    _qunzhuLB.textColor = UIColorFromRGB(0xffffff);
    _qunzhuLB.textAlignment = NSTextAlignmentCenter;
    _qunzhuLB.font = kMainFont_12;
    _qunzhuLB.backgroundColor = kCommonMainOringeColor;
    [backView addSubview:_qunzhuLB];
    if([[info objectForKey:@"is_status"] intValue] == 1)
    {
        _qunzhuLB.hd_width = 0;
    }
    
    self.jingpinLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_qunzhuLB.frame) + 5, 15, 30, 15)];
    self.jingpinLB.text = @"精品";
    _jingpinLB.textColor = UIColorFromRGB(0xffffff);
    _jingpinLB.textAlignment = NSTextAlignmentCenter;
    _jingpinLB.font = kMainFont_12;
    _jingpinLB.backgroundColor = kCommonMainBlueColor;
    [backView addSubview:_jingpinLB];
    if([[info objectForKey:@"is_show"] intValue] == 1)
    {
        _jingpinLB.hd_width = 0;
    }
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_courseCover.frame) + 10, CGRectGetMaxY(_titleLB.frame), 200, 15)];
    _timeLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"create_time"]];
    _timeLB.textColor = UIColorFromRGB(0x999999);
    _timeLB.font = kMainFont_12;
    [backView addSubview:_timeLB];
    
    UIImageView * deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backView.hd_width - 38, self.courseCover.hd_centerY - 6, 18, 9)];
    deleteImageView.image = [UIImage imageNamed:@"down箭头"];
    self.deleteImageView = deleteImageView;
    [backView addSubview:deleteImageView];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(deleteImageView.hd_x - 10, deleteImageView.hd_y - 10, deleteImageView.hd_width + 20, deleteImageView.hd_width + 20);
    [backView addSubview:_deleteBtn];
    [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    deleteImageView.hidden = YES;
    _deleteBtn.hidden = YES;
    
    
    NSString * contentStr = [info objectForKey:@"content"];
    CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(self.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x , CGRectGetMaxY(_courseCover.frame) + 10, self.hd_width - 70, height)];
    _contentLB.textColor = UIColorFromRGB(0x666666);
    _contentLB.text = [info objectForKey:@"content"];
    _contentLB.numberOfLines = 0;
    _contentLB.font = kMainFont;
    [backView addSubview:_contentLB];
    
    CGFloat spase = 5;
    self.imageUrlArray = [info objectForKey:@"c_imgs"];
    for (int i = 0; i < [[info objectForKey:@"c_imgs"] count]; i++) {
        NSString * imageUrl = [[info objectForKey:@"c_imgs"] objectAtIndex:i];
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kCellHeightOfCategoryView + spase) * (i % 3) + 55, CGRectGetMaxY(_contentLB.frame) + 5 + (kCellHeightOfCategoryView + spase) * (i / 3), kCellHeightOfCategoryView, kCellHeightOfCategoryView)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
        imageView.tag = 1000 + i;
        imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
    }
    
    
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(_contentLB.hd_x, 0, 130, backView.hd_height);
//    [btn addTarget:self action:@selector(checkDetail) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:btn];
    
    
    if (canOperation) {
        [self addOperationBtn:info];
    }
    
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 1, backView.hd_width, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UIView * topView = tap.view;
    if (self.imageClickBlock) {
        self.imageClickBlock(self.imageUrlArray, topView.tag - 1000);
    }
}

- (void)addOperationBtn:(NSDictionary *)info
{
    NSString * zanStr = [NSString stringWithFormat:@"%@", [info objectForKey:@"zan"]];
    NSString * commentStr = [NSString stringWithFormat:@"%@", [info objectForKey:@"commentCount"]];

    int imageCount = [[info objectForKey:@"c_imgs"] count] % 3 == 0 ? [[info objectForKey:@"c_imgs"] count] / 3 : [[info objectForKey:@"c_imgs"] count] / 3 + 1;
    CGFloat imageHeight = (kCellHeightOfCategoryView + 5) * imageCount;
//    CGFloat zanWidth = [zanStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.width;
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zanBtn.frame = CGRectMake(_titleLB.hd_x, CGRectGetMaxY(_contentLB.frame) + imageHeight + 15, 100, 20);
    [_zanBtn setImage:[UIImage imageNamed:@"dynamic_点赞1"] forState:UIControlStateNormal];
    [_zanBtn setTitle:[NSString stringWithFormat:@"%@", [info objectForKey:@"zan_num"]] forState:UIControlStateNormal];
    _zanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [_zanBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _zanBtn.titleLabel.font = kMainFont;
    [_zanBtn sizeToFit];
    [_zanBtn addTarget:self action:@selector(zanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_zanBtn];
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(CGRectGetMaxX(_zanBtn.frame) + 10, CGRectGetMaxY(_contentLB.frame) + imageHeight + 15, 100, 20);
    [_commentBtn setImage:[UIImage imageNamed:@"dynamic_评论"] forState:UIControlStateNormal];
    [_commentBtn setTitle:[NSString stringWithFormat:@"%@", [info objectForKey:@"dis_num"]] forState:UIControlStateNormal];
    _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [_commentBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = kMainFont;
    [_commentBtn sizeToFit];
    [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentBtn];
    
    
    
    if ([[info objectForKey:@"is_zan"] boolValue]) {
        [_zanBtn setTitleColor:kCommonMainBlueColor forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"dynamic_点赞2"] forState:UIControlStateNormal];
    }
    
    // 身份为群主 或者自己的动态可以进行删除操作
    if ([UserManager sharedManager].is_admin) {
        self.deleteImageView.hidden = NO;
        self.deleteBtn.hidden = NO;
    }else
    {
        if ([[info objectForKey:@"is_my"] boolValue]) {
            self.deleteImageView.hidden = NO;
            self.deleteBtn.hidden = NO;
        }
    }
    
}

- (void)refresCommentDetailhUIWith:(NSDictionary *)info
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView removeAllSubviews];
    self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.infoDic = info;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.hd_width - 0, self.hd_height)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:backView];
    
    
    self.courseCover = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30,  30)];
    [self.courseCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [info objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
    self.courseCover.layer.cornerRadius = self.courseCover.hd_height / 2;
    self.courseCover.layer.masksToBounds = YES;
    [backView addSubview:self.courseCover];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.courseCover.frame) + 10, self.courseCover.hd_y, self.hd_width - 30, 15)];
    self.titleLB.textColor = UIColorFromRGB(0x333333);
    self.titleLB.font = kMainFont;
    self.titleLB.numberOfLines = 0;
    self.titleLB.text = [NSString stringWithFormat:@"c_name"];
    [backView addSubview:self.titleLB];
    [self.titleLB sizeToFit];
    
    self.qunzhuLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLB.frame) + 5, 15, 30, 15)];
    self.qunzhuLB.text = @"群主";
    _qunzhuLB.textColor = UIColorFromRGB(0xffffff);
    _qunzhuLB.textAlignment = NSTextAlignmentCenter;
    _qunzhuLB.font = kMainFont_12;
    _qunzhuLB.backgroundColor = kCommonMainOringeColor;
    [backView addSubview:_qunzhuLB];
    if([[info objectForKey:@"is_status"] intValue] == 1)
    {
        _qunzhuLB.hd_width = 0;
    }
    
    self.jingpinLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_qunzhuLB.frame) + 5, 15, 30, 15)];
    self.jingpinLB.text = @"精品";
    _jingpinLB.textColor = UIColorFromRGB(0xffffff);
    _jingpinLB.textAlignment = NSTextAlignmentCenter;
    _jingpinLB.font = kMainFont_12;
    _jingpinLB.backgroundColor = kCommonMainBlueColor;
    [backView addSubview:_jingpinLB];
    if([[info objectForKey:@"is_show"] intValue] == 1)
    {
        _jingpinLB.hd_width = 0;
    }
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_courseCover.frame) + 10, CGRectGetMaxY(_titleLB.frame), 200, 15)];
    _timeLB.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"create_time"]];
    _timeLB.textColor = UIColorFromRGB(0x999999);
    _timeLB.font = kMainFont_12;
    [backView addSubview:_timeLB];
    
    UIImageView * deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backView.hd_width - 38, self.courseCover.hd_centerY - 6, 18, 9)];
    deleteImageView.image = [UIImage imageNamed:@"down箭头"];
    self.deleteImageView = deleteImageView;
    [backView addSubview:deleteImageView];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(deleteImageView.hd_x - 10, deleteImageView.hd_y - 10, deleteImageView.hd_width + 20, deleteImageView.hd_width + 20);
    [backView addSubview:_deleteBtn];
    [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    deleteImageView.hidden = YES;
    _deleteBtn.hidden = YES;
    
    
    NSString * contentStr = [info objectForKey:@"content"];
    CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(self.hd_width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont} context:nil].size.height;
    self.contentLB = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLB.hd_x , CGRectGetMaxY(_courseCover.frame) + 10, self.hd_width - 70, height)];
    _contentLB.textColor = UIColorFromRGB(0x666666);
    _contentLB.text = [info objectForKey:@"content"];
    _contentLB.numberOfLines = 0;
    _contentLB.font = kMainFont;
    [backView addSubview:_contentLB];
    
    CGFloat spase = 5;
    self.imageUrlArray = [info objectForKey:@"c_imgs"];
    for (int i = 0; i < [[info objectForKey:@"c_imgs"] count]; i++) {
        NSString * imageUrl = [[info objectForKey:@"c_imgs"] objectAtIndex:i];
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kCellHeightOfCategoryView + spase) * (i % 3) + 55, CGRectGetMaxY(_contentLB.frame) + 5 + (kCellHeightOfCategoryView + spase) * (i / 3), kCellHeightOfCategoryView, kCellHeightOfCategoryView)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]] placeholderImage:[UIImage imageNamed:@"头像加载失败"] options:SDWebImageAllowInvalidSSLCertificates];
        
        imageView.tag = 1000 + i;
        imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
    }
    
    
    int imageCount = [[info objectForKey:@"c_imgs"] count] % 3 == 0 ? [[info objectForKey:@"c_imgs"] count] / 3 : [[info objectForKey:@"c_imgs"] count] / 3 + 1;
    CGFloat imageHeight = (kCellHeightOfCategoryView + 5) * imageCount;
    NSString * zanStr = [NSString stringWithFormat:@"、%@ 等人觉得很赞", [[info objectForKey:@"zan_info"] objectForKey:@"c_name"]];
    
    CGFloat zanHeight = [zanStr boundingRectWithSize:CGSizeMake(kScreenWidth - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kMainFont_12} context:nil].size.height;
    
    UILabel * zanLB = [[UILabel alloc]initWithFrame:CGRectMake(_titleLB.hd_x, CGRectGetMaxY(_contentLB.frame) + imageHeight + 15, kScreenWidth - 70, zanHeight + 15)];
    zanLB.textColor = kCommonMainBlueColor;
    zanLB.font = kMainFont_12;
    zanLB.numberOfLines = 0;
    [self.contentView addSubview:zanLB];
    
    NSDictionary * zanAttribute = @{NSFontAttributeName:kMainFont_12,NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
    NSMutableAttributedString * mZanStr = [[NSMutableAttributedString alloc]initWithString:zanStr];
    if ([[info objectForKey:@"zan_info"] objectForKey:@"c_name"]) {
        if ([[[info objectForKey:@"zan_info"] objectForKey:@"c_name"] length] > 0) {
            mZanStr = [[NSMutableAttributedString alloc]initWithString:zanStr];
            [mZanStr addAttributes:zanAttribute range:NSMakeRange(zanStr.length - 6, 6)];
        }else
        {
            mZanStr = [[NSMutableAttributedString alloc]initWithString:@""];
        }
    }else
    {
        mZanStr = [[NSMutableAttributedString alloc]initWithString:@""];
    }
    
    NSTextAttachment * attach = [[NSTextAttachment alloc]init];
    attach.image = [UIImage imageNamed:@"dynamic_点赞2"];
    CGFloat attachHeight = [zanStr sizeWithAttributes:@{NSFontAttributeName:kMainFont_12}].height;
    attach.bounds = CGRectMake(0, 0, attachHeight, attachHeight);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    [mZanStr insertAttributedString:imageStr atIndex:0];
    zanLB.attributedText = mZanStr;
    
    
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.hd_height - 1, backView.hd_width, 1)];
    separateView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [backView addSubview:separateView];
    
    
    // 身份为群主 或者自己的动态可以进行删除操作
    if ([UserManager sharedManager].is_admin) {
        self.deleteImageView.hidden = NO;
        self.deleteBtn.hidden = NO;
    }else
    {
        if ([[info objectForKey:@"is_my"] boolValue]) {
            self.deleteImageView.hidden = NO;
            self.deleteBtn.hidden = NO;
        }
    }
    
}



- (void)zanAction
{
    if (self.zanBlock) {
        self.zanBlock(self.infoDic);
    }
}

- (void)commentAction{
    if (self.commentBlock) {
        self.commentBlock(self.infoDic);
    }
}

- (void)deleteAction
{
    if (self.deleteBlock) {
        self.deleteBlock(self.infoDic);
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
