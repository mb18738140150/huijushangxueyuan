//
//  UserCenterViewController.h
//  Accountant
//
//  Created by aaa on 2017/3/4.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterViewController : ViewController

@property (nonatomic, copy)void (^updateBaseInfoBlock)(BOOL update);

@end
