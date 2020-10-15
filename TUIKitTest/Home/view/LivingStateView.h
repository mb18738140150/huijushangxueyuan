//
//  LivingStateView.h
//  huijushangxueyuan
//
//  Created by aaa on 2020/9/22.
//  Copyright © 2020 mcb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HomeLivingStateType_noStart,
    HomeLivingStateType_living,
    HomeLivingStateType_end,
    HomeLivingStateType_video,
    HomeLivingStateType_audio,
    HomeLivingStateType_LivingList,
    HomeLivingStateType_image,
    HomeLivingStateType_imageAndText,
    HomeLivingStateType_video_right,
    HomeLivingStateType_audio_right,
    HomeLivingStateType_LivingList_right,
    HomeLivingStateType_image_right,
    HomeLivingStateType_imageAndText_right,
} HomeLivingStateType;


NS_ASSUME_NONNULL_BEGIN

@interface LivingStateView : UIView

@property (nonatomic, assign)HomeLivingStateType livingState;


@end

NS_ASSUME_NONNULL_END
