//
//  VIPCardDetailViewController.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/10.
//

#import "ViewController.h"

typedef enum : NSUInteger {
    VIPCardType_VIP,
    VIPCardType_HeHuoRen,
} VIPCardType;

NS_ASSUME_NONNULL_BEGIN

@interface VIPCardDetailViewController : ViewController

@property (nonatomic, strong)NSDictionary * myInfo;
@property (nonatomic, strong)NSDictionary * info;
@property (nonatomic, assign)VIPCardType vipCardType;

@end

NS_ASSUME_NONNULL_END
