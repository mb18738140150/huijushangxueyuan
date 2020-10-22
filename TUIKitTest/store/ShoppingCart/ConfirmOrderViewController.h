//
//  ConfirmOrderViewController.h
//  lanhailieren
//
//  Created by aaa on 2020/3/11.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ViewController.h"

@interface ConfirmOrderViewController : ViewController

@property (nonatomic, strong)NSMutableArray * selectArray;

@property (nonatomic, copy)void (^popFoodIntroVCBlock)();

@end

