//
//  LivingSecretViewController.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/24.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LivingSecretViewController : ViewController

@property (nonatomic, strong)NSDictionary * info;
@property (nonatomic, copy)void (^verifyPsdSuccessBlock)(NSDictionary *info);

@end

NS_ASSUME_NONNULL_END
