//
//  HttpConfigModel.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpConfigModel : NSObject

@property (nonatomic,strong) NSString           *urlString;
@property (nonatomic,strong) NSMutableDictionary       *parameters;
@property (nonatomic,strong) NSNumber           *command;
@property (nonatomic, strong)NSString * token;

@property (nonatomic, strong)NSString *propertyStr;

@property (nonatomic, strong)NSString * requestType;

@end
