//
//  AssociationPublishCommentViewController.m
//  TUIKitTest
//
//  Created by aaa on 2020/10/28.
//

#import "AssociationPublishCommentViewController.h"
#import "TZImagePickerController.h"

@interface AssociationPublishCommentViewController ()<TZImagePickerControllerDelegate>

@end

@implementation AssociationPublishCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)hhh
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - pick image func
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = [photos lastObject];
    
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
