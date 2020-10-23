//
//  UserManager.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModuleProtocol.h"

@interface UserManager : NSObject

@property (nonatomic, strong)NSDictionary * currentSelectAddressInfo;// 当前选中门店


+ (instancetype)sharedManager;

/**
 获取用户信息

 @return 用户信息
 */
- (NSDictionary *)getUserInfos;

- (void)refreshUserInfoWith:(NSDictionary *)infoDic;

- (int)getUserLevel;

- (NSString *)getLevelStr;

- (NSDictionary *)getUpdateInfo;

- (void)didLoginWithUserCode:(NSDictionary *)code withNotifiedObject:(id<UserModule_LoginProtocol>)object;

- (void)didRequestTabbarWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_TabbarList>)object;
- (NSArray *)getTabarList;

- (void)getLeadTypeWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_LeadtypeProtocol>)object;
- (NSArray *)getLeadTypeArray;


- (void)getSecondCategoryeWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_SecondCategoryProtocol>)object;
- (NSArray *)getSecondCategoryeArray;

- (void)getBannerWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_BannerList>)object;

- (void)getCategoryCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CategoryCourseProtocol>)object;
- (NSArray *)getCategoryCourseArray;
- (NSDictionary *)getCategoryCourseInfo;

- (void)getCourseDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseDetailProtocol>)object;
- (NSDictionary *)getCourseDetailInfo;

// 获取历史聊天记录
- (void)didRequestLiveChatRecordWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_LiveChatRecord>)object;
- (NSArray *)getLiveChatRecordList;

// 发送聊天消息
- (void)didRequestSendMessageWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_SendMessage>)object;
- (NSDictionary *)getMessageId;

// 获取聊天室礼物列表
- (void)didRequestGiftListWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_GiftList>)object;
- (NSArray *)getGiftList;

// 获取邀请列表
- (void)didRequestShareListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ShareList>)object;
- (NSArray *)getShareList;

// 获取会员卡信息
- (void)didRequestMyVIPCardWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyVIPCardInfo>)object;
- (NSDictionary *)getVIPCardInfo;

// 会员卡详情
- (void)didRequestMyVIPCardDetailWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyVIPCardDetailInfo>)object;
- (NSDictionary *)getVIPCardDetailInfo;

// 禁言
- (void)didRequestShutupWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_Shutup>)object;

// 模拟vip购买
- (void)didRequestMockVIPBuyWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MockVIPBuy>)object;
- (NSDictionary *)getVIPBuyInfo;

// 模拟合伙人购买
- (void)didRequestMockPartnerBuyWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MockPartnerBuy>)object;
- (NSDictionary *)getPartnerBuyInfo;

// 完善个人信息
- (void)completeUserInfoWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CompleteUserInfoProtocol>)object;

// 我的消息
- (void)didRequestNotificationListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_NotificationList>)object;
- (NSArray *)getNotificationArray;

// 获取收货地址
- (void)getAddressListWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AddressListProtocol>)object;
// 编辑收货地址
- (void)editAddressWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_EditAddressProtocol>)object;
- (NSArray *)getAddressList;
// 删除地址
- (void)didRequestDeleteAddressWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_DeleteAddressProtocol>)object;

// 添加购物车
- (void)didRequestAddShoppingCarWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AddShoppingCarProtocol>)object;
// 删除购物车
- (void)didRequestDeleteShoppingCarWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_DeleteShoppingCarProtocol>)object;
// 清空购物车
- (void)didRequestCleanShoppingCarWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CleanShoppingCarProtocol>)object;
// 我的购物车
- (void)didRequestShoppingCarListWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ShoppingCarListProtocol>)object;
// 获取购物车列表
- (NSArray *)getShoppingCarList;

// 获取我的订单列表
- (void)didRequestOrderListWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderListProtocol>)object;
- (NSArray *)getMyOrderList;
- (int )getMyOrderListTotalCount;
- (void)didRequestCreateOrderWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CreateOrderProtocol>)object;

// 评论
- (void)didRequestCommentZantWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CommentZanProtocol>)object;
- (void)didRequestAddCommentWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_AddCommentProtocol>)object;

// 老师
- (void)getCourseTeacherWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseTeacherProtocol>)object;
- (NSArray *)getCourseTeaccherArray;

- (void)getTeacherDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_TeacherDetailProtocol>)object;
- (NSDictionary *)getTeacherDetailInfo;





- (NSArray *)getHomeAnswerArray;
- (NSArray *)getHomeFreeArray;
- (NSArray *)getHomeRecommendArray;
- (NSDictionary *)getHomeTKdata;
- (NSArray *)getHomeBannerArray;
- (void)getComboCourseBannerWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_BannerList>)object;
- (NSArray *)getComboCourseBannerArray;

- (void)getXitongbanListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_GiftList>)object;
- (NSArray *)getXitongbanArray;

- (void)getCategoryTeacherListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CategoryTeacherListProtocol>)object;
- (NSArray *)getCategoryTeacherLis;


- (void)getLivingCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_LivingCourseProtocol>)object;
- (NSArray *)getLivingCourseArray;
- (NSDictionary *)getLivingCourseInfo;





- (void)getUserInfoWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_GetUserInfo>)object;
- (NSDictionary *)getUserInfo;

- (NSDictionary *)getMyOrderListInfo;

- (void)getMyCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyCourse>)object;
- (NSDictionary *)getMyCourse;
- (NSArray *)getMyCourseList;

- (void)getCourseNoteWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseNoteProtocol>)object;
- (NSArray *)getCourseNoteArray;






- (void)getMyNearlyStudyCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NearlyStudy>)object;
- (NSArray *)getMyNearlyStudyCourseList;
- (NSDictionary *)getMyNearlyStudyCourseInfo;
- (NSDictionary *)getMyOrderLivingCourseInfo;
- (NSDictionary *)getMyCollectionCourseInfo;

- (void)getMyOrderLivingCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyOrderLivingCourse>)object;
- (NSArray *)getMyOrderLivingCourseList;

- (void)getMyCollectionCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyCollectionCourse>)object;
- (NSArray *)getMyCollectionCourseList;

- (void)getNewsCategoryWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsCategory>)object;
- (NSArray *)getNewsCategoryList;

- (void)getNewsListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsList>)object;
- (NSArray *)getNewsListList;
- (NSDictionary * )getNewsListInfo;

- (void)getNewsDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsDetail>)object;
- (NSDictionary *)getNewsDetailList;

// 获取课程学习记录
- (void)getCourseStudyRecordWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseStudyRecord>)object;
- (NSArray *)getCourseStudyRecordList;

// 添加学习记录
- (void)getAddCourseStudyRecordListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AddCourseStudyRecord>)object;
- (NSDictionary *)getAddCourseStudyRecordInfo;

/**
 请求登陆接口

 @param userName 用户名
 @param pwd 密码
 @param object 请求成功后通知的对象
 */
- (void)loginWithUserName:(NSString *)userName
              andPassword:(NSString *)pwd
       withNotifiedObject:(id<UserModule_LoginProtocol>)object;



/**
 请求重置密码接口

 @param oldPwd 旧密码
 @param newPwd 新密码
 @param object 请求成功后通知的对象
 */
- (void)resetPasswordWithOldPassword:(NSString *)oldPwd andNewPwd:(NSString *)newPwd withNotifiedObject:(id<UserModule_ResetPwdProtocol>)object;


// 注册
- (void)registWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RegistProtocol>)object;


// 忘记密码
- (void)forgetPsdWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ForgetPasswordProtocol>)object;

// 获取验证码
- (void)getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber withNotifiedObject:(id<UserModule_VerifyCodeProtocol>)object;

- (void)getVerifyAccountWithAccountNumber:(NSString *)accountNumber withNotifiedObject:(id<UserModule_VerifyAccountProtocol>)object;


- (void)bindRegCodeWithRegCode:(NSString *)regCode withNotifiedObject:(id<UserModule_bindRegCodeProtocol>)object;



/**
 请求app版本信息

 @param object 请求成功后通知的对象
 */
- (void)didRequestAppVersionInfoWithNotifiedObject:(id<UserModule_AppInfoProtocol>)object;

/**
 退出登录
 */
- (void)logout;

/**
 判断是否已经登陆

 @return 是否登陆
 */
- (BOOL)isUserLogin;

/**
 绑定极光账号
 
 */
- (void)didRequestBindJPushWithCID:(NSString *)cid withNotifiedObject:(id<UserModule_BindJPushProtocol>)object;

/**
 预约直播课
 
 */
- (void)didRequestOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object;

/**
 取消预约直播课
 
 */
- (void)didRequestCancelOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CancelOrderLivingCourseProtocol>)object;

//- (void)refreshRCDUserInfoWithNickName:(NSString *)nickName andWithPortraitUrl:(NSString *)portraitUrl;

/**
 获取用户id

 @return 用户id
 */
- (int)getUserId;

/**
 获取是否显示邀请码
 
 @return 邀请码是否显示
 */
- (int)getCodeview;

- (void)changeCodeViewWith:(int)codeView;

/**
 获取用户名

 @return 用户名
 */
- (NSString *)getUserName;

/**
 获取昵称
 
 @return 昵称
 */
- (NSString *)getUserNickName;

/**
 获取验证码
 
 @return 验证码
 */
- (NSString *)getVerifyCode;

/**
 获取绑定手机号
 
 @return 已绑定手机号
 */
- (NSString *)getVerifyPhoneNumber;

/**
 获取融云token
 
 @return 融云tokrn
 */
- (NSString *)getRongToken;

- (NSString *)getIconUrl;



// 支付订单
- (void)payOrderWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_PayOrderProtocol>)object;
// 获取订单支付详情
- (NSDictionary *)getPayOrderDetailInfo;

- (void)payOrderByCoinWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_PayOrderByCoinProtocol>)object;

// 获取我的订单_未支付列表
- (void)didRequestOrderList_NoPayWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderList_NoPayProtocol>)object;
- (NSArray *)getMyOrder_NoPayList;

/**
 获取优惠券
 
 */
- (void)didRequestMyDiscountCouponWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_discountCouponProtocol>)object;
- (NSArray *)getAllDiscountCoupon;
- (NSArray *)getNormalDiscountCoupon;
- (NSArray *)getexpireDiscountCoupon;
- (NSArray *)getCannotUseDiscountCoupon:(double)price;
- (NSArray *)getHaveUsedDiscountCoupon;

- (void)didRequestAcquireDiscountCouponWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AcquireDiscountCouponProtocol>)object;
- (NSArray *)getAcquireDiscountCoupon;
- (void)didRequestAcquireDiscountCouponSuccessWithCourseInfo:(NSDictionary *)infoDic;

// 获取我的积分
- (void)didRequestIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;
- (void)didRequestGetIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;
- (void)didRequestGetRecommendIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object;
- (int)getIntegral;
- (NSDictionary *)getRecommendIntegral;

// 客服信息
- (void)didRequestAssistantWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AssistantCenterProtocol>)object;
- (NSArray *)getAssistantList;
- (NSArray *)getTelephoneList;

// 会员详情信息
- (void)didRequestLevelDetailWithNotifiedObject:(id<UserModule_LevelDetailProtocol>)object;
- (NSArray *)getLevelDetailList;

// 意见反馈
- (void)didRequestSubmitOpinionWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitOperationProtocol>)object;


// 常见问题
- (void)didRequestCommonProblemWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CommonProblem>)object;
- (NSArray *)getCommonProblemList;

// 获取往期回放年份列表
- (void)didRequestLivingBackYearListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LivingBackYearList>)object;
- (NSArray *)getLivingBackYearList;

// 福利
- (void)didRequestGiftListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_GiftList>)object;
- (NSArray *)getGiftList;

- (void)didRequestSubmitGiftCodeWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitGiftCode>)object;

// 验证苹果支付结果
- (void)didRequestVerifyInAppPurchaseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_VerifyInAppPurchase>)object;
- (void)resetGoldCoinCount:(int )count;

// 获取我的金币
- (int)getMyGoldCoins;
- (void)didRequestMyCoinsWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyCoin>)object;
// 获取金币变更列表
- (NSArray *)getBills;

// 获取考试倒计时
- (void)getExamCountDownWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_GetExamCountDown>)object;
- (NSDictionary *)getExamCountDownInfo;



@end
