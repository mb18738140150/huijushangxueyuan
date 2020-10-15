//
//  ShareListOperation.h
//  TUIKitTest
//
//  Created by aaa on 2020/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareListOperation : NSObject
@property (nonatomic, strong)NSArray * shareList;

- (void)didRequestShareListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ShareList>)object;

@end

NS_ASSUME_NONNULL_END
