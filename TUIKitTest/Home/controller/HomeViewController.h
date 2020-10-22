//
//  HomeViewController.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/23.
//  Copyright © 2020 mcb. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    HomeCellType_search,
    HomeCellType_banner,
    HomeCellType_category,
    HomeCellType_openVIP,
    HomeCellType_BigImageType,
    HomeCellType_BigImageNoTeacherType,
    HomeCellType_JustaposeType,
    HomeCellType_ListType,
    HomeCellType_TeacherList,
    HomeCellType_PublicNumber,
    HomeCellType_Community,
    HomeCellType_VipCard,
    HomeCellType_adver,
} HomeCellType;

@interface HomeViewController : ViewController

@end

NS_ASSUME_NONNULL_END
