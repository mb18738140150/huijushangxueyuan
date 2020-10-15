//
//  UserModel.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel1 : NSObject<NSCoding>

@property (nonatomic,assign) int                 userID;

@property (nonatomic,assign) BOOL                isLogin;

@property (nonatomic,strong) NSString           *userName;

@property (nonatomic,strong) NSString           *userNickName;

@property (nonatomic,strong) NSString           *headImageUrl;

@property (nonatomic,strong) NSString           *telephone;

@property (nonatomic, assign) int               codeview;

@property (nonatomic, strong)NSString * sex;

@property (nonatomic, strong)NSString * uid;

@property (nonatomic, strong)NSString *openId;

@property (nonatomic, assign)int goldCoins;

@end
