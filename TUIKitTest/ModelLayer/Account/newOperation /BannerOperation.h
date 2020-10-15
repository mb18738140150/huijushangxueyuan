//
//  BannerOperation.h
//  zhongxin
//
//  Created by aaa on 2019/9/23.
//  Copyright © 2019 mcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerOperation : NSObject

@property (nonatomic, strong)NSMutableArray * bannerList;

@property (nonatomic, strong)NSMutableArray * answerList;
@property (nonatomic, strong)NSMutableArray * freeList;
@property (nonatomic, strong)NSMutableArray * RecommendList;
@property (nonatomic, strong)NSDictionary * TKdata;



- (void)didRequestBannerListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_BannerList>)object;

@end

NS_ASSUME_NONNULL_END
