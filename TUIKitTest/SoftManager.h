//
//  SoftManager.h
//  qianshutang
//
//  Created by aaa on 2018/8/4.
//  Copyright © 2018年 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoftManager : NSObject


@property (nonatomic, assign)CGFloat length;
@property (nonatomic, assign)BOOL isCamera;

@property (nonatomic, assign)BOOL isPhontoLibrary;// iPad 调用系统相册

@property (nonatomic, strong)NSString * coinName;

@property (nonatomic, strong)NSIndexPath * currentIndexPath;

+ (instancetype)shareSoftManager;

- (float)getAllPrice:(NSArray *)selectArray;
- (int)getAllPoint:(NSArray *)selectArray;

@end
