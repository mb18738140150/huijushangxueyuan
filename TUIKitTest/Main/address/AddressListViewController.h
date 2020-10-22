//
//  AddressListViewController.h
//  lanhailieren
//
//  Created by aaa on 2020/3/6.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressListViewController : ViewController

@property (nonatomic, assign)BOOL isFromOrderVC;
@property (nonatomic, copy)void (^addressChooseBlock)(NSDictionary *info);

@end

NS_ASSUME_NONNULL_END
