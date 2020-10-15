//
//  LeadtypeOperation.m
//  zhongxin
//
//  Created by aaa on 2019/9/26.
//  Copyright © 2019 mcb. All rights reserved.
//

#import "LeadtypeOperation.h"

#define kDeep 2

@interface LeadtypeOperation ()<HttpRequestProtocol>
@property (nonatomic,weak) id<UserModule_LeadtypeProtocol> notifiedObject;
@end

@implementation LeadtypeOperation

- (NSMutableArray *)LeadtypeList
{
    if (!_LeadtypeList) {
        _LeadtypeList = [NSMutableArray array];
    }
    return _LeadtypeList;
}

- (void)didRequestLeadtypeWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LeadtypeProtocol>)object
{
    self.notifiedObject = object;
    [[HttpRequestManager sharedManager] requestLeadTypeWithInfo:infoDic andDelegate:self];
}

- (void)didRequestSuccessed:(NSDictionary *)successInfo
{
//    NSLog(@"yearList = %@", successInfo);
    
    
    self.LeadtypeList = [successInfo objectForKey:@"data"];
    
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didLeadtypeSuccessed];
    }
}


- (void)didRequestFailed:(NSString *)failInfo
{
    if (isObjectNotNil(self.notifiedObject)) {
        [self.notifiedObject didLeadtypeFailed:failInfo];
    }
}


@end
