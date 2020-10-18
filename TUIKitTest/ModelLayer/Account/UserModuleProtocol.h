//
//  UserModuleProtocol.h
//  Accountant
//
//  Created by aaa on 2017/3/2.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol UserModule_TabbarList <NSObject>

- (void)didTabbarListSuccessed;

- (void)didTabbarListFailed:(NSString *)failedInfo;

@end

@protocol UserModule_LiveChatRecord <NSObject>

- (void)didLiveChatRecordSuccessed;

- (void)didLiveChatRecordFailed:(NSString *)failedInfo;

@end

@protocol UserModule_SendMessage <NSObject>

- (void)didSendMessageSuccessed;

- (void)didSendMessageFailed:(NSString *)failedInfo;

@end


@protocol UserModule_BannerList <NSObject>
- (void)didBannerListSuccessed;

- (void)didBannerListFailed:(NSString *)failedInfo;

@end

@protocol UserModule_GiftList <NSObject>

- (void)didRequestGiftListSuccessed;
- (void)didRequestGiftListFailed:(NSString *)failedInfo;

@end

@protocol UserModule_ShareList <NSObject>

- (void)didRequestShareListSuccessed;
- (void)didRequestShareListFailed:(NSString *)failedInfo;

@end

@protocol UserModule_MyVIPCardInfo <NSObject>

- (void)didRequestMyVIPCardInfoSuccessed;
- (void)didRequestMyVIPCardInfoFailed:(NSString *)failedInfo;

@end

@protocol UserModule_MyVIPCardDetailInfo <NSObject>

- (void)didRequestMyVIPCardDetailInfoSuccessed;
- (void)didRequestMyVIPCardDetailInfoFailed:(NSString *)failedInfo;

@end

@protocol UserModule_Shutup <NSObject>

- (void)didRequestShutupSuccessed;
- (void)didRequestShutupFailed:(NSString *)failedInfo;

@end

@protocol UserModule_MockVIPBuy <NSObject>

- (void)didRequestMockVIPBuySuccessed;
- (void)didRequestMockVIPBuyFailed:(NSString *)failedInfo;

@end

@protocol UserModule_MockPartnerBuy <NSObject>

- (void)didRequestMockPartnerBuySuccessed;
- (void)didRequestMockPartnerBuyFailed:(NSString *)failedInfo;

@end

@protocol UserModule_NotificationList <NSObject>

- (void)didRequestNotificationListSuccessed;
- (void)didRequestNotificationListFailed:(NSString *)failedInfo;

@end












@protocol UserModule_LeadtypeProtocol <NSObject>

- (void)didLeadtypeSuccessed;

- (void)didLeadtypeFailed:(NSString *)failedInfo;

@end

@protocol UserModule_CategoryTeacherListProtocol <NSObject>

- (void)didCategoryTeacherListSuccessed;
- (void)didCategoryTeacherListFailed:(NSString *)failedInfo;

@end

@protocol UserModule_SecondCategoryProtocol <NSObject>

- (void)didSecondCategorySuccessed;
- (void)didSecondCategoryFailed:(NSString *)failedInfo;

@end

@protocol UserModule_CategoryCourseProtocol <NSObject>

- (void)didCategoryCourseSuccessed;
- (void)didCategoryCourseFailed:(NSString *)failedInfo;

@end

@protocol UserModule_LivingCourseProtocol <NSObject>

- (void)didLivingCourseSuccessed;
- (void)didLivingCourseFailed:(NSString *)failedInfo;

@end

@protocol UserModule_CourseNoteProtocol <NSObject>

- (void)didCourseNoteSuccessed;
- (void)didCourseNoteFailed:(NSString *)failedInfo;

@end

@protocol UserModule_CourseTeacherProtocol <NSObject>

- (void)didCourseTeacherSuccessed;
- (void)didCourseTeacherFailed:(NSString *)failedInfo;

@end

@protocol UserModule_CourseDetailProtocol <NSObject>

- (void)didCourseDetailSuccessed;
- (void)didCourseDetailFailed:(NSString *)failedInfo;

@end

@protocol UserModule_GetUserInfo <NSObject>

- (void)didGetUserInfoSuccessed;
- (void)didGetUserInfolFailed:(NSString *)failedInfo;

@end

@protocol UserModule_MyCourse <NSObject>

- (void)didGetMyCourseSuccessed;
- (void)didGetMyCourseFailed:(NSString *)failedInfo;

@end



@protocol UserModule_LoginProtocol <NSObject>

- (void)didUserLoginSuccessed;

- (void)didUserLoginFailed:(NSString *)failedInfo;

@end

@protocol UserModule_VerifyAccountProtocol <NSObject>

- (void)didVerifyAccountSuccessed;
- (void)didVerifyAccountFailed:(NSString *)failInfo;

@end

@protocol UserModule_RegistProtocol <NSObject>

- (void)didRegistSuccessed;
- (void)didRegistFailed:(NSString *)failInfo;

@end

@protocol UserModule_CompleteUserInfoProtocol <NSObject>

- (void)didCompleteUserSuccessed;
- (void)didCompleteUserFailed:(NSString *)failInfo;

@end

@protocol UserModule_ForgetPasswordProtocol <NSObject>

- (void)didForgetPasswordSuccessed;
- (void)didForgetPasswordFailed:(NSString *)failInfo;

@end

@protocol UserModule_VerifyCodeProtocol <NSObject>

- (void)didVerifyCodeSuccessed;
- (void)didVerifyCodeFailed:(NSString *)failInfo;

@end

@protocol UserModule_ResetPwdProtocol <NSObject>

- (void)didResetPwdSuccessed;
- (void)didResetPwdFailed:(NSString *)failInfo;

@end

@protocol UserModule_AppInfoProtocol <NSObject>

- (void)didRequestAppInfoSuccessed;
- (void)didRequestAppInfoFailed:(NSString *)failedInfo;

@end
@protocol UserModule_BindJPushProtocol <NSObject>

- (void)didRequestBindJPushSuccessed;
- (void)didRequestBindJPushFailed:(NSString *)failedInfo;

@end
@protocol UserModule_OrderLivingCourseProtocol <NSObject>

- (void)didRequestOrderLivingSuccessed;
- (void)didRequestOrderLivingFailed:(NSString *)failedInfo;

@end
@protocol UserModule_CancelOrderLivingCourseProtocol <NSObject>

- (void)didRequestCancelOrderLivingSuccessed;
- (void)didRequestCancelOrderLivingFailed:(NSString *)failedInfo;

@end
@protocol UserModule_bindRegCodeProtocol <NSObject>

- (void)didRequestbindRegCodeSuccessed;
- (void)didRequestbindRegCodeFailed:(NSString *)failedInfo;

@end

@protocol UserModule_PayOrderProtocol <NSObject>

- (void)didRequestPayOrderSuccessed;
- (void)didRequestPayOrderFailed:(NSString *)failedInfo;

@end

@protocol UserModule_PayOrderByCoinProtocol <NSObject>

- (void)didRequestPayOrderByCoinSuccessed;
- (void)didRequestPayOrderByCoinFailed:(NSString *)failedInfo;

@end

@protocol UserModule_discountCouponProtocol <NSObject>

- (void)didRequestDiscountCouponSuccessed;
- (void)didRequestDiscountCouponFailed:(NSString *)failedInfo;

@end

@protocol UserModule_AcquireDiscountCouponProtocol <NSObject>

- (void)didRequestAcquireDiscountCouponSuccessed;
- (void)didRequestAcquireDiscountCouponFailed:(NSString *)failedInfo;

@end

@protocol UserModule_OrderListProtocol <NSObject>

- (void)didRequestOrderListSuccessed;
- (void)didRequestOrderListFailed:(NSString *)failedInfo;

@end

@protocol UserModule_OrderList_NoPayProtocol <NSObject>

- (void)didRequestOrderList_NoPaySuccessed;
- (void)didRequestOrderList_NoPayFailed:(NSString *)failedInfo;

@end


@protocol UserModule_RecommendProtocol <NSObject>

- (void)didRequestRecommendSuccessed;
- (void)didRequestRecommendFailed:(NSString *)failedInfo;

@end

@protocol UserModule_AssistantCenterProtocol <NSObject>

- (void)didRequestAssistantCenterSuccessed;
- (void)didRequestAssistantCenterFailed:(NSString *)failedInfo;

@end

@protocol UserModule_LevelDetailProtocol <NSObject>

- (void)didRequestLevelDetailSuccessed;
- (void)didRequestLevelDetailFailed:(NSString *)failedInfo;

@end

@protocol UserModule_SubmitOperationProtocol <NSObject>

- (void)didRequestSubmitOperationSuccessed;
- (void)didRequestSubmitOperationFailed:(NSString *)failedInfo;

@end

@protocol UserModule_CommonProblem <NSObject>

- (void)didRequestCommonProblemSuccessed;
- (void)didRequestCommonProblemFailed:(NSString *)failedInfo;

@end

@protocol UserModule_LivingBackYearList <NSObject>

- (void)didRequestLivingBackYearListSuccessed;
- (void)didRequestLivingBackYearListFailed:(NSString *)failedInfo;

@end



@protocol UserModule_SubmitGiftCode <NSObject>

- (void)didRequestSubmitGiftCodeSuccessed;
- (void)didRequestSubmitGiftCodeFailed:(NSString *)failedInfo;

@end

@protocol UserModule_VerifyInAppPurchase <NSObject>

- (void)didRequestInAppPurchaseSuccessed;
- (void)didRequestInAppPurchaseFailed:(NSString *)failedInfo;

@end

@protocol UserModule_MyCoin <NSObject>

- (void)didRequestMyCoinSuccessed;
- (void)didRequestMyCoinFailed:(NSString *)failedInfo;

@end

@protocol UserModule_NearlyStudy <NSObject>

- (void)didRequestNearlyStudySuccessed;
- (void)didRequestNearlyStudyFailed:(NSString *)failedInfo;

@end

@protocol UserModule_MyOrderLivingCourse <NSObject>

- (void)didRequestMyOrderLivingCourseSuccessed;
- (void)didRequestMyOrderLivingCourseFailed:(NSString *)failedInfo;

@end

@protocol UserModule_MyCollectionCourse <NSObject>

- (void)didRequestMyCollectionCourseSuccessed;
- (void)didRequestMyCollectionCourseFailed:(NSString *)failedInfo;

@end


@protocol UserModule_NewsCategory <NSObject>

- (void)didRequestNewsCategorySuccessed;
- (void)didRequestNewsCategoryFailed:(NSString *)failedInfo;

@end

@protocol UserModule_NewsList <NSObject>

- (void)didRequestNewsListSuccessed;
- (void)didRequestNewsListFailed:(NSString *)failedInfo;

@end

@protocol UserModule_NewsDetail <NSObject>

- (void)didRequestNewsDetailSuccessed;
- (void)didRequestNewsDetailFailed:(NSString *)failedInfo;

@end


@protocol UserModule_CourseStudyRecord <NSObject>

- (void)didRequestCourseStudyRecordSuccessed;
- (void)didRequestCourseStudyRecordFailed:(NSString *)failedInfo;

@end


@protocol UserModule_AddCourseStudyRecord <NSObject>

- (void)didRequestAddCourseStudyRecordSuccessed;
- (void)didRequestAddCourseStudyRecordFailed:(NSString *)failedInfo;

@end


@protocol UserModule_GetExamCountDown <NSObject>

- (void)didRequestGetExamCountDownSuccessed;
- (void)didRequestGetExamCountDownFailed:(NSString *)failedInfo;

@end
