//
//  UserModel.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UserModel1.h"

@implementation UserModel1

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:@(self.userID) forKey:@"userId"];
    [coder encodeObject:@(self.isLogin) forKey:@"isLogin"];
    [coder encodeObject:self.userNickName forKey:@"userNickName"];
    [coder encodeObject:self.headImageUrl forKey:@"headImageUrl"];
    [coder encodeObject:self.telephone forKey:@"telephone"];
    [coder encodeObject:self.sex forKey:@"sex"];
    [coder encodeObject:self.sex forKey:@"uid"];
    [coder encodeObject:@(self.goldCoins) forKey:@"goldCoins"];
    [coder encodeObject:self.openId forKey:@"openId"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init] ) {
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.userID = [[coder decodeObjectForKey:@"userId"] intValue];
        self.isLogin = [[coder decodeObjectForKey:@"isLogin"] boolValue];
        self.userNickName = [coder decodeObjectForKey:@"userNickName"];
        self.headImageUrl = [coder decodeObjectForKey:@"headImageUrl"];
        self.telephone = [coder decodeObjectForKey:@"telephone"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.uid = [coder decodeObjectForKey:@"uid"];
        self.openId = [coder decodeObjectForKey:@"openId"];
        self.goldCoins = [[coder decodeObjectForKey:@"goldCoins"] intValue];
    }
    return self;
}

@end
