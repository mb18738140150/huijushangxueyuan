//
//  AssociationPublishCommentViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "AssociationPublishCommentViewController.h"
#import "TZImagePickerController.h"
#import "MKPPlaceholderTextView.h"
#import "DynamicChangeImageCollectionViewCell.h"
#define kDynamicChangeImageCollectionViewCell @"DynamicChangeImageCollectionViewCell"
#import "QuestionManager.h"

@interface AssociationPublishCommentViewController ()<TZImagePickerControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UITextViewDelegate,QuestionModule_QuestionPublishProtocol>
@property (nonatomic, strong)MKPPlaceholderTextView * textView;

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray * imageArray;
@property (nonatomic, strong)NSMutableArray * imageUrlArray;

@property (nonatomic, strong)NSMutableArray * cacheImageArray;

@property (nonatomic, strong)UIButton * submitBtn;

@end

@implementation AssociationPublishCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationViewSetup];
    self.imageArray = [NSMutableArray array];
    self.imageUrlArray = [NSMutableArray array];
    self.cacheImageArray = [NSMutableArray array];
    [self.imageArray addObject:[UIImage imageNamed:@"加"]];
    [self.imageUrlArray addObject:[NSNull null]];
    
    [self prepareUI];
}

#pragma mark - ui
- (void)navigationViewSetup
{
    self.navigationItem.title = @"发表动态";
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareUI
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = UIColorFromRGB( 0xf2f2f2);
    [self.view addSubview:backView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textaction)];
    [backView addGestureRecognizer:tap];
    
    UIView * bsckView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 235)];
    bsckView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:bsckView];
    
    MKPPlaceholderTextView *textView = [[MKPPlaceholderTextView alloc]init];
    textView.placeholder = @"说说你的想法...";
    textView.frame = CGRectMake(15, 15, kScreenWidth - 30, 200);
    textView.delegate = self;
    textView.font = kMainFont_12;
    textView.placeholderColor = UIColorFromRGB(0x666666);
    [textView resetPlaceholderLabel];
    [textView setPlaceholderTextAlignment:NSTextAlignmentCenter];
    textView.returnKeyType = UIReturnKeySend;
    [self.view addSubview:textView];
    self.textView = textView;
    
    UICollectionViewFlowLayout * layouit = [[UICollectionViewFlowLayout alloc]init];
    layouit.itemSize = CGSizeMake(kScreenWidth / 5 - 1, kScreenWidth / 5 - 1);
    layouit.minimumInteritemSpacing = 0;
    layouit.minimumLineSpacing = 0;
    layouit.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame) + 20, kScreenWidth, kScreenWidth / 5 + 20) collectionViewLayout:layouit];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[DynamicChangeImageCollectionViewCell class] forCellWithReuseIdentifier:kDynamicChangeImageCollectionViewCell];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(40, CGRectGetMaxY(self.collectionView.frame) + 20, kScreenWidth - 80, 40);
    _submitBtn.backgroundColor = kCommonMainBlueColor;
    _submitBtn.layer.cornerRadius = 5;
    _submitBtn.layer.masksToBounds = YES;
    [_submitBtn setTitle:@"发布动态" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = kMainFont;
    [self.view addSubview:_submitBtn];
    
    [self.submitBtn addTarget:self action:@selector(publishDynamic) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    DynamicChangeImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDynamicChangeImageCollectionViewCell forIndexPath:indexPath];
    UIImage * image = [self.imageArray objectAtIndex:indexPath.row];
    if (indexPath.item == 0) {
        [cell refreshUIWith:self.imageArray[indexPath.item] andCanClose:NO];
    }else
    {
        [cell refreshUIWith:self.imageArray[indexPath.item] andCanClose:YES];
    }
    cell.closeImageBlock = ^(UIImage * _Nonnull info) {
        NSInteger index = [weakSelf.imageArray indexOfObject:image];
        [weakSelf.imageArray removeObjectAtIndex:index];
        [weakSelf.imageUrlArray removeObjectAtIndex:index];
        [weakSelf.collectionView reloadData];
        [weakSelf resetUI];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textView resignFirstResponder];
    if (indexPath.item == 0) {
        [self hhh];
    }
}

- (void)hhh
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(10 - self.imageArray.count) columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)textaction
{
    [self.textView resignFirstResponder];
}


#pragma mark - pick image func
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.cacheImageArray removeAllObjects];
    for (UIImage * image in photos) {
        [self.cacheImageArray addObject:image];
    }
    [self runDispatchTest];
}


#pragma mark - punlishDynamic
- (void)publishDynamic
{
    NSString * content = @"";
    if (self.textView.text.length > 0) {
        content = self.textView.text;
    }
    [self.imageUrlArray removeObjectAtIndex:0];
    NSString * imageUrl = [self.imageUrlArray componentsJoinedByString:@","];
    if (imageUrl == nil) {
        imageUrl = @"";
    }
    
    [SVProgressHUD show];
    [[QuestionManager sharedManager] didRequestPublishQuestionWithQuestionInfos:@{kUrlName:@"api/community/dynamicadd",@"c_id":[self.info objectForKey:@"id"],@"c_imgs":imageUrl,@"content":content,kRequestType:@"get"} withNotifiedObject:self];
}

- (void)didQuestionPublishSuccessed
{
    [SVProgressHUD show];
    if (self.publishBlock) {
        self.publishBlock(@{});
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didQuestionPublishFailed:(NSString *)failedInfo
{
    [self.imageUrlArray insertObject:[NSNull null] atIndex:0];
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:failedInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - uploadImage
- (void)resetUI
{
    if (self.imageArray.count > 5) {
        self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + 20, kScreenWidth, kScreenWidth / 5 * 2 + 20);
    }else
    {
        self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + 20, kScreenWidth, kScreenWidth / 5  + 20);
    }
    self.submitBtn.frame = CGRectMake(40, CGRectGetMaxY(self.collectionView.frame) + 20, kScreenWidth - 80, 40);
}


- (void)runDispatchTest {
    
    [SVProgressHUD show];
    // 需要上传的数据
    NSArray* images = self.cacheImageArray;
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (UIImage* image in images) {
        [result addObject:[NSNull null]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    NSMutableArray * errorArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        dispatch_group_enter(group);

        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:images[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    [errorArray addObject:@(i)];
                }
                dispatch_group_leave(group);
            } else {
                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = [[responseObject objectForKey:@"data"] objectForKey:@"url"];
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        // 清除上传失败的图片
        for (int i = 0; i < errorArray.count; i++) {
            int index = [[errorArray objectAtIndex:i] intValue];
            [self.cacheImageArray replaceObjectAtIndex:index withObject:[NSNull null]];
        }
        
        for (int i = self.cacheImageArray.count - 1; i >= 0; i--) {
            UIImage * image = [self.cacheImageArray objectAtIndex:i];
            if ([image isKindOfClass:[NSNull class]]) {
                [self.cacheImageArray removeObject:image];
            }
        }
        
        // 上传成功，添加到数据源
        for (int i = 0; i < result.count; i++) {
            if (i < self.cacheImageArray.count) {
                UIImage * image = self.cacheImageArray[i];
                NSString * url = result[i];
                
                [self.imageArray addObject:image];
                [self.imageUrlArray addObject:url];
                
            }
        }
        [SVProgressHUD dismiss];
        [self.collectionView reloadData];
        [self resetUI];
    });
}

- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSError* error = NULL;
    
    NSDictionary * paramete = @{};
    NSString * aesStr = [UIUtility getAES_Str:paramete];
    
    NSString * sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
    NSMutableDictionary * headDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"token":[NSString stringWithFormat:@"%@", aesStr]}];
    if (sessionId) {
        if (sessionId.length > 0) {
            sessionId = [NSString stringWithFormat:@"PHPSESSID=%@", sessionId];
            
            [headDic setValue:sessionId forKey:@"Cookie"];
        }
    }
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:kUploadRootUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"iii" mimeType:@"image/jpeg"];
    } error:&error];
    
    for (NSString *headerField in headDic.keyEnumerator) {
        [request setValue:headDic[headerField] forHTTPHeaderField:headerField];
    }
    
    // 可在此处配置验证信息
    
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
