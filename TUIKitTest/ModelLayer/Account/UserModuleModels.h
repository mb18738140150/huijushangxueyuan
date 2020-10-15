//
//  UserModuleModels.h
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel1.h"
#import "AppInfoModel.h"

@interface UserModuleModels : NSObject

@property (nonatomic,strong) UserModel1          *currentUserModel;

@property (nonatomic,strong) AppInfoModel       *appInfoModel;

@end
