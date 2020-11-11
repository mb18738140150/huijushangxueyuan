//
//  UserCenterViewController.m
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UserCenterViewController.h"

#define headerImageName @"stuhead"

@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UserModule_CompleteUserInfoProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HttpUploadProtocol,UserModule_GetUserInfo,UserModule_LoginProtocol,UITextFieldDelegate>

@property (nonatomic,strong) UIImageView            *bgImageView;
@property (nonatomic,strong) UIImageView            *headerImageView;

@property (nonatomic,strong) UIButton               *backButton;

@property (nonatomic,strong) UITableView            *infoTableView;

@property (nonatomic,strong) NSDictionary           *userInfos;
@property (nonatomic,strong) NSMutableArray                *userDisplayKeyArray;
@property (nonatomic,strong) NSMutableArray                *userDisplayNameArray;
// 修改昵称
@property (nonatomic, strong)NSMutableDictionary      * nickNameDic;

@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (nonatomic, strong)UIImage                 * nImage;
@property (nonatomic, strong)NSString                * iconMsg;

@property (nonatomic, strong)NSString * sendImageUrl;

@property (nonatomic, strong)UITextField * nameTf;
@property (nonatomic, strong)UITextField * phoneTf;

@property (nonatomic, strong)NSMutableArray * list;

@end

@implementation UserCenterViewController

- (NSMutableArray *)userDisplayKeyArray
{
    if (!_userDisplayKeyArray) {
        _userDisplayKeyArray = [NSMutableArray array];
    }
    return _userDisplayKeyArray;
}

- (NSMutableArray *)userDisplayNameArray
{
    if (!_userDisplayNameArray) {
        _userDisplayNameArray = [NSMutableArray array];
    }
    return _userDisplayNameArray;
}

- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userInfos = [[UserManager sharedManager] getUserInfos];
    
    self.sendImageUrl = [[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl];
    
    for (NSDictionary * info in [[[UserManager sharedManager] getUserInfo] objectForKey:@"user_info"]) {
        NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
        [self.list addObject:mInfo];
    }
    
    
    self.userDisplayNameArray = [[NSMutableArray alloc]initWithArray:@[@"编号",@"头像",@"姓名",@"手机号"]];
    for (NSDictionary * info in self.list) {
        [self.userDisplayNameArray addObject:[info objectForKey:@"name"]];
    }
    [self.userDisplayNameArray addObject:@""];
    
    self.userDisplayKeyArray = [[NSMutableArray alloc]initWithArray:@[kUserId,kUserHeaderImageUrl,kUserNickName,kUserTelephone]];
    
    self.iconMsg = @"";
    self.sendImageUrl = [[[UserManager sharedManager] getUserInfos] objectForKey:kUserHeaderImageUrl];
    [self navigationViewSetup];
    [self contentSetup];
    
}
#pragma mark - ui setup
- (void)navigationViewSetup
{
    self.navigationItem.title = @"个人资料";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.navigationController.navigationBar.barTintColor = kCommonNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kCommonMainTextColor_50};
    
    TeamHitBarButtonItem * leftBarItem = [TeamHitBarButtonItem leftButtonWithImage:[UIImage imageNamed:@"public-返回"] title:@""];
    [leftBarItem addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarItem];
}
- (void)backAction:(UIButton *)button
{
    if (self.updateBaseInfoBlock) {
        self.updateBaseInfoBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - response func
- (void)navigationBack11
{
    if (self.updateBaseInfoBlock) {
        self.updateBaseInfoBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return NO; //YES：允许右滑返回  NO：禁止右滑返回
}
#pragma mark - table delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userDisplayNameArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userInfoCellName = @"userInfoNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userInfoCellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = kMainFont;
    cell.detailTextLabel.font = kMainFont;
    
    cell.textLabel.text = [self.userDisplayNameArray objectAtIndex:indexPath.row];
    if(indexPath.row == 3){
        self.phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth - 200, 10, 185, 30)];
        [cell addSubview:self.phoneTf];
        self.phoneTf.delegate = self;
        self.phoneTf.returnKeyType = UIReturnKeyDone;
        self.phoneTf.backgroundColor = [UIColor whiteColor];
        self.phoneTf.placeholder = @"请填写手机号-";
        self.phoneTf.textColor = UIColorFromRGB(0x333333);
        self.phoneTf.font = cell.detailTextLabel.font;
        self.phoneTf.textAlignment = NSTextAlignmentRight;
        NSString *tele = [self.userInfos objectForKey:@"userTelephone"];
        if (tele == nil) {
            if ([tele isEqualToString:@""]) {
                cell.detailTextLabel.text = @"";
                self.phoneTf.text = @"";
            }
        }else{
            cell.detailTextLabel.text = [self.userInfos objectForKey:@"userTelephone"];
            self.phoneTf.text = [self.userInfos objectForKey:@"userTelephone"];
        }
        
    }else if (indexPath.row == 2){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]];
        cell.detailTextLabel.userInteractionEnabled = YES;
        [self.nickNameDic setObject:cell.detailTextLabel.text forKey:@"old"];
        [self.nickNameDic setObject:cell.detailTextLabel.text forKey:@"new"];
        
        self.nameTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth - 200, 10, 185, 30)];
        [cell addSubview:self.nameTf];
        self.nameTf.delegate = self;
        self.nameTf.returnKeyType = UIReturnKeyDone;
        self.nameTf.backgroundColor = [UIColor whiteColor];
        self.nameTf.placeholder = @"请填写姓名-";
        self.nameTf.textColor = UIColorFromRGB(0x333333);
        self.nameTf.font = cell.detailTextLabel.font;
        self.nameTf.textAlignment = NSTextAlignmentRight;
        self.nameTf.text = [NSString stringWithFormat:@"%@",[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]];
        
    }else if (indexPath.row == 1)
    {
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 50, 7, 35, 35)];
        self.headerImageView.layer.cornerRadius = self.headerImageView.hd_height / 2;
        self.headerImageView.layer.masksToBounds = YES;
        [cell addSubview:self.headerImageView];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"head_img"]];
        self.headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * changeIconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIcon)];
        [self.headerImageView addGestureRecognizer:changeIconTap];
    }else if (indexPath.row == self.userDisplayNameArray.count - 1)
    {
        UIButton * complateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        complateBtn.frame = CGRectMake(50, 30, kScreenWidth - 100, 40);
        complateBtn.backgroundColor = UIColorFromRGB(0x2A75ED);
        complateBtn.layer.cornerRadius = 5;
        complateBtn.layer.masksToBounds = YES;
        [complateBtn setTitle:@"提交保存" forState:UIControlStateNormal];
        [complateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [complateBtn addTarget:self action:@selector(complateAction) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:complateBtn];
        cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    else{
        if (indexPath.row <= 3) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.userInfos objectForKey:[self.userDisplayKeyArray objectAtIndex:indexPath.row]]];
        }else
        {
            NSDictionary * info = [self.list objectAtIndex:indexPath.row - 4];
            
            UITextField * Tf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth - 200, 10, 185, 30)];
            [cell addSubview:Tf];
            Tf.delegate = self;
            Tf.returnKeyType = UIReturnKeyDone;
            Tf.backgroundColor = [UIColor whiteColor];
            Tf.placeholder = [NSString stringWithFormat:@"%@",[info objectForKey:@"placeholder"]];
            Tf.textColor = UIColorFromRGB(0x333333);
            Tf.font = cell.detailTextLabel.font;
            Tf.textAlignment = NSTextAlignmentRight;
            Tf.tag = 2000 + indexPath.row - 4;
            Tf.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[info objectForKey:@"value"]]];
            
        }
        cell.detailTextLabel.textColor = UIColorFromRGB(0x666666);
    }
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    bottomView.backgroundColor = UIColorFromRGBValue(0xedf0f0);
    if (indexPath.row < self.userDisplayNameArray.count - 1) {
        [cell addSubview:bottomView];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.userDisplayNameArray.count - 1)
    {
        return 100;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.phoneTf resignFirstResponder];
    [self.nameTf resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [self.nameTf resignFirstResponder];
    [self.phoneTf resignFirstResponder];
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (![textField isEqual:self.nameTf] && ![textField isEqual:self.phoneTf]) {
        NSMutableDictionary * mInfo = [self.list objectAtIndex:textField.tag - 2000];
        [mInfo setValue:textField.text forKey:@"value"];
    }
    return YES;
}


- (void)complateAction
{
    NSLog(@"保存");
    NSDictionary * userInfo = [[UserManager sharedManager] getUserInfos];
    
    NSMutableDictionary * mInfo = [NSMutableDictionary dictionary];
    [mInfo setValue:@"api/user/update" forKey:kUrlName];
    
    [mInfo setValue:self.sendImageUrl forKey:@"avatar"];
    
    [mInfo setValue:self.nameTf.text forKey:@"nickname"];
    
    [mInfo setValue:self.phoneTf.text forKey:@"mobile"];
    
    for (int i = 0; i < self.list.count; i++) {
        NSDictionary * info = [[[[UserManager sharedManager] getUserInfo] objectForKey:@"user_info"] objectAtIndex:i];
        NSMutableDictionary * listImfo = [self.list objectAtIndex:i];
        
        if (![[info objectForKey:@"value"] isEqual:[listImfo objectForKey:@"value"]]) {
            [mInfo setValue:[listImfo objectForKey:@"value"] forKey:[listImfo objectForKey:@"name"]];
        }
    }
    
    
    [SVProgressHUD show];
    [[UserManager sharedManager] completeUserInfoWithDic:mInfo withNotifiedObject:self];
}

#pragma mark - completeuserInfo
- (void)didCompleteUserSuccessed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"更新成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    NSDictionary * userInfo = [[UserManager sharedManager] getUserInfos];
    NSMutableDictionary * mInfo = [NSMutableDictionary dictionary];
    if (![self.sendImageUrl isEqualToString:[userInfo objectForKey:kUserHeaderImageUrl]]) {
        [mInfo setValue:self.sendImageUrl forKey:@"icon"];
    }
    if (![self.nameTf.text isEqualToString:[userInfo objectForKey:kUserNickName]]) {
        [mInfo setValue:self.nameTf.text forKey:@"nickName"];
    }
    if (![self.phoneTf.text isEqualToString:[userInfo objectForKey:kUserTelephone]]) {
        [mInfo setValue:self.phoneTf.text forKey:@"phoneNumber"];
    }
    
    [[UserManager sharedManager] refreshUserInfoWith:mInfo];
}

- (void)didCompleteUserFailed:(NSString *)failInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)refreshHeadImage
{
    self.headerImageView.image = self.nImage;
    self.bgImageView.image = self.headerImageView.image;
}


- (void)contentSetup
{
    self.imagePic = [[UIImagePickerController alloc] init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;
    
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.view addSubview:self.infoTableView];
    self.infoTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nickNameDic = [NSMutableDictionary dictionary];
}

- (void)changeIcon
{
    
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePic animated:YES completion:nil];
        }else
        {
            UIAlertController * tipControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相机,请选择图库" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [tipControl addAction:sureAction];
            [self presentViewController:tipControl animated:YES completion:nil];
            
        }
    }];
    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }];
    
    [alertcontroller addAction:cancleAction];
    [alertcontroller addAction:cameraAction];
    [alertcontroller addAction:libraryAction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.nImage = image;
    [SVProgressHUD show];
    
    NSString * imageFileName = @"1.png";
    NSString * imageUrl = [[info objectForKey:@"UIImagePickerControllerImageURL"] absoluteString];
    if (imageUrl) {
        if ([imageUrl containsString:@"."]) {
            imageFileName = [NSString stringWithFormat:@"1.%@", [[imageUrl componentsSeparatedByString:@"."] lastObject]];
        }
    }
    [self upLoadImage:@{@"data":UIImagePNGRepresentation(image),@"fileName":imageFileName}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)upLoadImage:(NSDictionary *)imageInfo
{
    [[HttpUploaderManager sharedManager] uploadImage:[imageInfo objectForKey:@"data"] withProcessDelegate:self];
}

- (BOOL)isHaveMemberLevel
{
    return YES;
}

#pragma mark - uploadImageProtocol
- (void)didUploadSuccess:(NSDictionary *)successInfo
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", successInfo);
    [self refreshHeadImage];
    self.sendImageUrl = [successInfo objectForKey:@"url"];
}

- (void)didUploadFailed:(NSString *)uploadFailed
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:uploadFailed];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)didGetUserInfoSuccessed
{
    NSDictionary * info = [[UserManager sharedManager] getUserInfo];
    NSLog(@"%@", info);
}

- (void)didGetUserInfolFailed:(NSString *)failedInfo
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });

}


@end
