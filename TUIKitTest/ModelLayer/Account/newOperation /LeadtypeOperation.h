//
//  LeadtypeOperation.h
//  zhongxin
//
//  Created by aaa on 2019/9/26.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeadtypeOperation : NSObject

- (void)didRequestLeadtypeWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LeadtypeProtocol>)object;
@property (nonatomic, strong)NSMutableArray * LeadtypeList;


@end

NS_ASSUME_NONNULL_END
