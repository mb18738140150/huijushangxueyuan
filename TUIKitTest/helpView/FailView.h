//
//  FailView.h
//  tiku
//
//  Created by aaa on 2017/6/1.
//  Copyright © 2017年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FailType_NoData,
    FailType_NoNetWork,
    FailType_NoLogin,
    FailType_NoCourse,
    FailType_NoOrder,
    FailType_NoNote,
    FailType_NoDownload,
    FailType_Noquestion,
    FailType_NoLiving,
    FailType_NoTiku,
    FailType_NoStudyRecord,
    FailType_NoCollection,
}FailType;

@interface FailView : UIView

@property (nonatomic, assign)FailType failType;
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * titleLB;
@property (nonatomic, strong)UIButton *refreshBT;
@property (nonatomic, copy)void(^refreshBlock)();
@property (nonatomic, copy)void(^LoginBlock)();
@property (nonatomic, copy)void(^OperationBlock)(FailType faileType);
- (void)refreshNoCourseData;

@end
