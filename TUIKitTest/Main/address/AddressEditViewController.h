//
//  AddressEditViewController.h
//  lanhailieren
//
//  Created by aaa on 2020/3/6.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddressEditViewController : ViewController


@property(nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy)void(^editAddressSuccessBlock)(NSDictionary * info);
@property (nonatomic, copy)void(^deleteAddressSuccessBlock)(NSDictionary * info);

@end

