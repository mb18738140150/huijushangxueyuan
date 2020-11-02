//
//  AssociationRelevanceCourseView.h
//  TUIKitTest
//
//  Created by aaa on 2020/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociationRelevanceCourseView : UIView

@property (nonatomic, copy)void(^courseBlock)(NSDictionary * info);

- (instancetype)initWithFrame:(CGRect)frame andCourseArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
