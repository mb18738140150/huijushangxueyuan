//
//  SecongListViewController.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/24.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ViewController.h"

typedef enum : NSUInteger {
    SecondListType_artical,
    SecondListType_living,
} SecondListType;

NS_ASSUME_NONNULL_BEGIN

@interface SecongListViewController : ViewController

@property (nonatomic, assign)int pid;
@property (nonatomic, assign)SecondListType secondType;

@end

NS_ASSUME_NONNULL_END
