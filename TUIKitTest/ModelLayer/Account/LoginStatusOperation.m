//
//  LoginStatusOperation.m
//  Accountant
//
//  Created by aaa on 2017/2/28.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "LoginStatusOperation.h"
#import "HttpRequestManager.h"
#import "PathUtility.h"

@interface LoginStatusOperation ()

@property (nonatomic,weak) id<UserModule_LoginProtocol>          loginNotifiedObject;

@property (nonatomic,weak) UserModel1                            *userModel;

@end

@implementation LoginStatusOperation

- (void)clearLoginUserInfo
{
    self.userModel.userID = 0;
    self.userModel.userName = @"";
    self.userModel.isLogin = NO;
    self.userModel.userNickName = @"";
    self.userModel.headImageUrl = @"";
    self.userModel.telephone = @"";
    self.userModel.sex = @"";
    self.userModel.goldCoins = 0;
    self.userModel.codeview = 1;
    [self encodeUserInfo];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
}

- (void)setCurrentUser:(UserModel1 *)user
{
    self.userModel = user;
}

- (void)didLoginWithUserName:(NSString *)userName andPassword:(NSString *)password withNotifiedObject:(id<UserModule_LoginProtocol>)object
{
//    self.userModel.userName = userName;
    self.loginNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestLoginWithUserName:userName andPassword:password andProcessDelegate:self];
}

- (void)didLoginWithUserCode:(NSDictionary *)code withNotifiedObject:(id<UserModule_LoginProtocol>)object
{
    self.loginNotifiedObject = object;
    [[HttpRequestManager sharedManager] requestLeadTypeWithInfo:code andDelegate:self];
}

- (void)encodeUserInfo
{
    NSString *dataPath = [[PathUtility getDocumentPath] stringByAppendingPathComponent:@"user.data"];
    [NSKeyedArchiver archiveRootObject:self.userModel toFile:dataPath];
}

#pragma mark - request delegate
- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
    NSLog(@"successInfo = %@", successInfo);
    
    [[NSUserDefaults standardUserDefaults] setObject:[[successInfo objectForKey:@"data"] objectForKey:@"session_id"] forKey:@"session_id"];
    
    successInfo = [successInfo objectForKey:@"data"];
    
    if ([[successInfo objectForKey:@"nickname"] class] == [NSNull class] || [successInfo objectForKey:@"nickname"] == nil || [[successInfo objectForKey:@"nickname"] isEqualToString:@""]) {
        self.userModel.userNickName = @"用户";
        self.userModel.userName = @"用户";
    }else{
        
        NSData * data = [[NSData alloc]initWithBase64EncodedData:[successInfo objectForKey:@"nickname"] options:0];
        NSString * text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        self.userModel.userName = text;
        self.userModel.userNickName = text;
    }
    
    if ([[successInfo objectForKey:@"headimgurl"] class] == [NSNull class] || [successInfo objectForKey:@"headimgurl"] == nil || [[successInfo objectForKey:@"headimgurl"] isEqualToString:@""]) {
        self.userModel.headImageUrl = @"";
    }else{
        self.userModel.headImageUrl = [successInfo objectForKey:@"headimgurl"];
    }
    
    
    if ([[successInfo objectForKey:@"phone"] class] == [NSNull class] || [successInfo objectForKey:@"phone"] == nil || [[successInfo objectForKey:@"phone"] isEqualToString:@""]) {
        self.userModel.telephone = @"";
    }else{
        self.userModel.telephone = [successInfo objectForKey:@"phone"];
    }

    if([[UIUtility judgeStr:[successInfo objectForKey:@"sex"]] intValue] == 1)
    {
        self.userModel.sex = @"男";
    }else
    {
        self.userModel.sex = @"女";
    }
    
    self.userModel.userID = [[successInfo objectForKey:@"uid"] intValue];
    if ([[successInfo objectForKey:@"openid"] class] == [NSNull class] || [successInfo objectForKey:@"openid"] == nil || [[successInfo objectForKey:@"openid"] isEqualToString:@""]) {
        self.userModel.openId = @"";
    }else{
        self.userModel.openId = [NSString stringWithFormat:@"%@", [successInfo objectForKey:@"openid"]];
    }
    self.userModel.isLogin = YES;
    
    if (self.loginNotifiedObject != nil) {
        [self.loginNotifiedObject didUserLoginSuccessed];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginSuccess object:nil];
    [self encodeUserInfo];
}

- (void)didRequestFailed:(NSString *)failInfo
{
    if (self.loginNotifiedObject != nil) {
        [self.loginNotifiedObject didUserLoginFailed:failInfo];
    }
}

@end
