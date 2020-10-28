//
//  WFMessageBody.m
//  WFCoretext
//
//  Created by 阿虎 on 15/4/29.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "WFMessageBody.h"

@implementation WFMessageBody

- (NSMutableArray *)posterReplies
{
    if (!_posterReplies) {
        _posterReplies = [NSMutableArray array];
    }
    return _posterReplies;
}

@end
