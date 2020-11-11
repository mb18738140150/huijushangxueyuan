//
//  StoreViewController.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/19.
//

#import "ViewController.h"
typedef enum : NSUInteger {
    FromType_nomal,
    FromType_push,
    FromType_present,
} FromType;


NS_ASSUME_NONNULL_BEGIN

@interface StoreViewController : ViewController
@property (nonatomic, assign)FromType fromType;
@end

NS_ASSUME_NONNULL_END
