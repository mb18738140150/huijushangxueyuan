//
//  UserManager.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "UserManager.h"
#import "LoginStatusOperation.h"
#import "UserModuleModels.h"
#import "CommonMacro.h"
#import "ResetPwdOperation.h"
#import "AppInfoOperation.h"
#import "BindJPushOperation.h"
#import "OrderLivingCourseOperation.h"
#import "CancelOrderLivingCourseOperation.h"
#import "BindRegCodeOperation.h"
#import "DiscountCouponOperation.h"
#import "VerifyCodeOperation.h"
#import "RegistOperation.h"
#import "ForgetPsdOperation.h"
#import "VerifyAccountOperation.h"
#import "CompleteUserInfoOperation.h"
#import "PayCourseOperation.h"
#import "PathUtility.h"
#import "RecommendOperation.h"
#import "AssistantCenterOperation.h"
#import "MemberLevelDetail.h"
#import "SubmitOpinionOperation.h"
#import "CommonProblemOperation.h"
#import "LivingBackYearListOperation.h"
#import "SubmitGiftCodeOperation.h"

#import "AcquireDiscountCouponOperation.h"
#import "AcquireDiscountCouponSuccess.h"
#import "VerifyInAppPuchaseOperation.h"
#import "MyCoinOperation.h"


#import "BannerOperation.h"
#import "LeadtypeOperation.h"
#import "CategoryTeacherListOperation.h"
#import "SecondCategoryOperation.h"
#import "CategoryCourseOperation.h"
#import "CourseDetailOperation.h"
#import "UserInfoOperation.h"
#import "MyCourseOperation.h"
#import "LivingCourseOperation.h"
#import "CourseNoteOperation.h"
#import "TeacherOperation.h"
#import "NearlyStudyOperation.h"
#import "MyOrderLivingCourseOperation.h"
#import "MyCollectionCourseOperation.h"
#import "NewsCategoryOperation.h"
#import "NewsListOperation.h"
#import "NewsDetailOperation.h"
#import "CourseStudyRecord.h"
#import "OrderList_NoPayOperation.h"
#import "AddCourseStudyRecordOperation.h"
#import "PayOrderByCoinOperation.h"
#import "GetExamCountDown.h"


#import "TabbarOperation.h"
#import "LiveChatRecordOpreation.h"
#import "SendMessageOperation.h"
#import "GiftListOperation.h"
#import "ShareListOperation.h"
#import "MyVIPCardOperation.h"
#import "ShutupOperation.h"
#import "MockVIPBuyOperation.h"
#import "MockPartnerBuyOperation.h"
#import "VIPCardDetailOperation.h"
#import "MyNotificationOperation.h"
#import "AddressListOperation.h"
#import "EditAddressInfoOperation.h"
#import "DeleteAddressOperation.h"

#import "AddShoppingCarOperation.h"
#import "DeleteShoppingCarOperation.h"
#import "CleanShoppingCarOperation.h"
#import "ShoppingCarListOperation.h"
#import "CreateOrderOperation.h"
#import "OrderListOperation.h"
#import "CommentZanOperation.h"
#import "AddCommentOperation.h"

@interface UserManager()
@property (nonatomic,strong) TabbarOperation       *tabbarOperation;
@property (nonatomic,strong) LiveChatRecordOpreation       *liveChatRecordOpreation;
@property (nonatomic,strong) SendMessageOperation       *sendMessageOperation;
@property (nonatomic, strong)GiftListOperation          *giftLIstOperation;
@property (nonatomic, strong)ShareListOperation          *shareListOperation;
@property (nonatomic, strong)MyVIPCardOperation *  myVIPCardOperation;
@property (nonatomic, strong)ShutupOperation * shutupOperation;
@property (nonatomic, strong)MockVIPBuyOperation * mockVIPBuyOperation;
@property (nonatomic, strong)MockPartnerBuyOperation * mockPartnerBuyOperation;
@property (nonatomic, strong)VIPCardDetailOperation * vipCardDetailOperation;
@property (nonatomic, strong)MyNotificationOperation * myNotificationOperation;
@property (nonatomic, strong)AddressListOperation            *addressListOperation;
@property (nonatomic, strong)EditAddressInfoOperation            *editAddressOperation;
@property (nonatomic, strong)DeleteAddressOperation         *deleteAddressOperation;
@property (nonatomic, strong)CommentZanOperation         *commentZanOperation;
@property (nonatomic, strong)AddCommentOperation         *addCommentOperation;



@property (nonatomic, strong)AddShoppingCarOperation         *addShoppingCarOperation;
@property (nonatomic, strong)DeleteShoppingCarOperation         *deleteShoppingCarOperation;
@property (nonatomic, strong)CleanShoppingCarOperation         *cleanShoppingCarOperation;
@property (nonatomic, strong)ShoppingCarListOperation         *shoppingCarListOperation;
@property (nonatomic, strong)CreateOrderOperation         *createOrderOperation;
@property (nonatomic, strong)OrderListOperation         *orderListOperation;


@property (nonatomic, strong)SecondCategoryOperation          *SecondCategoryOperation;
@property (nonatomic, strong)CategoryCourseOperation          *categoryCourseOperation;


@property (nonatomic,strong) LoginStatusOperation       *loginOperation;
@property (nonatomic,strong) UserModuleModels           *userModuleModels;

@property (nonatomic,strong) ResetPwdOperation          *resetOperation;

@property (nonatomic,strong) AppInfoOperation           *infoOperation;

@property (nonatomic, strong)BindJPushOperation         *bindJPushOperation;
@property (nonatomic, strong)OrderLivingCourseOperation *orderLivingCourseOperation;
@property (nonatomic, strong)CancelOrderLivingCourseOperation *cancelOrderLivingCOurseOperation;
@property (nonatomic, strong)VerifyCodeOperation         *verifyCodeOperation;
@property (nonatomic, strong)RegistOperation         *registOperation;
@property (nonatomic, strong)ForgetPsdOperation         *forgetPsdOperation;
@property (nonatomic, strong)VerifyAccountOperation     *verfyAccountOperation;
@property (nonatomic, strong)CompleteUserInfoOperation  *completeOperation;
@property (nonatomic, strong)BindRegCodeOperation       *bindRegCodeOperation;
@property (nonatomic, strong)PayCourseOperation         *payOrderOperation;
@property (nonatomic, strong)DiscountCouponOperation    *discountCouponOperation;
@property (nonatomic, strong)RecommendOperation         *recommendOperation;
@property (nonatomic, strong)AssistantCenterOperation   *assistantCenterOperation;
@property (nonatomic, strong)MemberLevelDetail          *memberLevelDetailOperation;
@property (nonatomic, strong)SubmitOpinionOperation     *submitOpinionOperation;
@property (nonatomic, strong)CommonProblemOperation     *commonProblemOperation;
@property (nonatomic, strong)LivingBackYearListOperation *livingBackYearLiatOperation;
@property (nonatomic, strong)SubmitGiftCodeOperation    *submitGiftCodeOperation;
@property (nonatomic, strong)AcquireDiscountCouponOperation *acquireDisCountOperation;
@property (nonatomic, strong)AcquireDiscountCouponSuccess   *acquireDisCountSuccessOperation;
@property (nonatomic, strong)VerifyInAppPuchaseOperation *verifyInAppPurchaseOperation;
@property (nonatomic, strong)MyCoinOperation            *myCoinOperation;
@property (nonatomic, strong)MyCourseOperation          *myCourseOperation;


@property (nonatomic, strong)BannerOperation            *bannerOperation;
@property (nonatomic, strong)BannerOperation            *comboCoursebannerOperation;

@property (nonatomic, strong)LeadtypeOperation          *leadTypeOperation;
@property (nonatomic, strong)GiftListOperation          *xitongbanOperation;
@property (nonatomic, strong)CategoryTeacherListOperation          *CategoryTeacherListOperation;

@property (nonatomic, strong)CourseDetailOperation            *courseDetailOperation;
@property (nonatomic, strong)UserInfoOperation            *userInfoOperation;
@property (nonatomic, strong)LivingCourseOperation *  livingCourseOperation;
@property (nonatomic, strong)CourseNoteOperation *  courseNoteOperation;
@property (nonatomic, strong)TeacherOperation *  teacherOperation;
@property (nonatomic, strong)NearlyStudyOperation *  nearlyStudyOperation;
@property (nonatomic, strong)MyOrderLivingCourseOperation *  myOrderLivingCourseOperation;
@property (nonatomic, strong)MyCollectionCourseOperation *  myCollectionCourseOperation;

@property (nonatomic, strong)NewsCategoryOperation *  newsCategoryOperation;
@property (nonatomic, strong)NewsListOperation *  newsListOperation;
@property (nonatomic, strong)NewsDetailOperation *  newsDetailOperation;
@property (nonatomic, strong)CourseStudyRecord * courseStudyRecord;
@property (nonatomic, strong)OrderList_NoPayOperation * orderList_NoPayOperation;
@property (nonatomic, strong)AddCourseStudyRecordOperation * addCourseStudyRecordOperation;
@property (nonatomic, strong)PayOrderByCoinOperation * payOrderByCoinOperation;
@property (nonatomic, strong)GetExamCountDown * getExamCountDown;

@end

@implementation UserManager

+ (instancetype)sharedManager
{
    static UserManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[UserManager alloc] init];
    });
    return __manager__;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.tabbarOperation = [[TabbarOperation alloc] init];
        self.liveChatRecordOpreation = [[LiveChatRecordOpreation alloc] init];
        self.sendMessageOperation = [[SendMessageOperation alloc] init];
        self.giftLIstOperation = [[GiftListOperation alloc]init];
        self.shareListOperation = [[ShareListOperation alloc]init];
        self.myVIPCardOperation = [[MyVIPCardOperation alloc]init];
        self.shutupOperation = [[ShutupOperation alloc]init];
        self.mockVIPBuyOperation = [[MockVIPBuyOperation alloc]init];
        self.mockPartnerBuyOperation = [[MockPartnerBuyOperation alloc]init];
        self.vipCardDetailOperation = [[VIPCardDetailOperation alloc]init];
        self.myNotificationOperation = [[MyNotificationOperation alloc]init];
        self.addressListOperation = [[AddressListOperation alloc]init];
        self.editAddressOperation = [[EditAddressInfoOperation alloc]init];
        self.deleteAddressOperation = [[DeleteAddressOperation alloc]init];
        self.addShoppingCarOperation = [[AddShoppingCarOperation alloc]init];
        self.deleteShoppingCarOperation = [[DeleteShoppingCarOperation alloc]init];
        self.cleanShoppingCarOperation = [[CleanShoppingCarOperation alloc]init];
        self.shoppingCarListOperation = [[ShoppingCarListOperation alloc]init];
        self.createOrderOperation = [[CreateOrderOperation alloc]init];
        self.orderListOperation = [[OrderListOperation alloc]init];
        self.commentZanOperation = [[CommentZanOperation alloc]init];
        self.addCommentOperation = [[AddCommentOperation alloc]init];

        
        self.SecondCategoryOperation = [[SecondCategoryOperation alloc]init];
        self.categoryCourseOperation = [[CategoryCourseOperation alloc]init];
        
        
        self.userModuleModels = [[UserModuleModels alloc] init];
        self.loginOperation = [[LoginStatusOperation alloc] init];
        [self.loginOperation setCurrentUser:self.userModuleModels.currentUserModel];
        self.resetOperation = [[ResetPwdOperation alloc] init];
        self.bindJPushOperation = [[BindJPushOperation alloc]init];
        self.orderLivingCourseOperation = [[OrderLivingCourseOperation alloc]init];
        self.cancelOrderLivingCOurseOperation = [[CancelOrderLivingCourseOperation alloc] init];
        self.infoOperation = [[AppInfoOperation alloc] init];
        self.infoOperation.appInfoModel = self.userModuleModels.appInfoModel;
        self.verifyCodeOperation = [[VerifyCodeOperation alloc]init];
        self.registOperation = [[RegistOperation alloc]init];
        self.forgetPsdOperation = [[ForgetPsdOperation alloc]init];
        self.verfyAccountOperation = [[VerifyAccountOperation alloc]init];
        self.completeOperation = [[CompleteUserInfoOperation alloc]init];
        self.bindRegCodeOperation = [[BindRegCodeOperation alloc]init];
        self.payOrderOperation = [[PayCourseOperation alloc]init];
        self.payOrderByCoinOperation = [[PayOrderByCoinOperation alloc]init];
        self.discountCouponOperation = [[DiscountCouponOperation alloc]init];
        self.acquireDisCountOperation = [[AcquireDiscountCouponOperation alloc]init];
        self.acquireDisCountSuccessOperation = [[AcquireDiscountCouponSuccess alloc]init];
        self.recommendOperation = [[RecommendOperation alloc]init];
        self.assistantCenterOperation = [[AssistantCenterOperation alloc]init];
        self.memberLevelDetailOperation = [[MemberLevelDetail alloc]init];
        self.submitOpinionOperation = [[SubmitOpinionOperation alloc]init];
        self.commonProblemOperation = [[CommonProblemOperation alloc]init];
        self.livingBackYearLiatOperation = [[LivingBackYearListOperation alloc]init];
        self.submitGiftCodeOperation = [[SubmitGiftCodeOperation alloc]init];
        self.verifyInAppPurchaseOperation = [[VerifyInAppPuchaseOperation alloc]init];
        self.myCoinOperation = [[MyCoinOperation alloc]init];
        
        self.bannerOperation = [[BannerOperation alloc]init];
        self.comboCoursebannerOperation = [[BannerOperation alloc]init];
        self.leadTypeOperation = [[LeadtypeOperation alloc]init];
        self.CategoryTeacherListOperation = [[CategoryTeacherListOperation alloc]init];
        self.xitongbanOperation = [[GiftListOperation alloc]init];
       
        self.courseDetailOperation = [[CourseDetailOperation alloc]init];
        self.userInfoOperation = [[UserInfoOperation alloc]init];
        self.myCourseOperation = [[MyCourseOperation alloc]init];
        self.livingCourseOperation = [[LivingCourseOperation alloc]init];
        self.courseNoteOperation = [[CourseNoteOperation alloc]init];
        self.teacherOperation = [[TeacherOperation alloc]init];
        
        self.nearlyStudyOperation = [[NearlyStudyOperation alloc]init];
        self.myOrderLivingCourseOperation = [[MyOrderLivingCourseOperation alloc]init];
        self.myCollectionCourseOperation = [[MyCollectionCourseOperation alloc]init];
        
        self.newsCategoryOperation = [[NewsCategoryOperation alloc]init];
        self.newsListOperation = [[NewsListOperation alloc]init];
        self.newsDetailOperation = [[NewsDetailOperation alloc]init];
        self.courseStudyRecord = [[CourseStudyRecord alloc]init];
        self.orderList_NoPayOperation = [[OrderList_NoPayOperation alloc]init];
        self.addCourseStudyRecordOperation = [[AddCourseStudyRecordOperation alloc]init];
        self.getExamCountDown = [[GetExamCountDown alloc]init];

    }
    return self;
}

- (void)didRequestTabbarWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_TabbarList>)object
{
    [self.tabbarOperation didRequestTabbarWithWithDic:infoDic WithNotifedObject:object];
}
- (NSArray *)getTabarList
{
    return self.tabbarOperation.list;
}

- (void)getSecondCategoryeWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_SecondCategoryProtocol>)object
{
    [self.SecondCategoryOperation didRequestSecondCategoryWithInfo:info withNotifiedObject:object];
}
- (NSArray *)getSecondCategoryeArray
{
    return self.SecondCategoryOperation.secondCategoryList;
}

- (void)getCategoryCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CategoryCourseProtocol>)object
{
    [self.categoryCourseOperation didRequestCategoryCourseWithInfo:info withNotifiedObject:object];
}
- (NSArray *)getCategoryCourseArray
{
    return self.categoryCourseOperation.categoryCourseList;
}

- (NSDictionary *)getCategoryCourseInfo
{
    return self.categoryCourseOperation.infoDic;
}

- (void)getCourseDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseDetailProtocol>)object
{
    [self.courseDetailOperation didRequestCourseDetailWithInfo:info withNotifiedObject:object];
}
- (NSDictionary *)getCourseDetailInfo
{
    return self.courseDetailOperation.infoDic;
}


- (void)didLoginWithUserCode:(NSDictionary *)code withNotifiedObject:(id<UserModule_LoginProtocol>)object
{
    [self.loginOperation didLoginWithUserCode:code withNotifiedObject:object];
}

- (void)getBannerWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_BannerList>)object
{
    [self.bannerOperation didRequestBannerListWithInfo:info withNotifiedObject:object];
}

- (NSArray *)getHomeBannerArray
{
    return self.bannerOperation.bannerList;
}
- (void)getComboCourseBannerWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_BannerList>)object
{
    [self.comboCoursebannerOperation didRequestBannerListWithInfo:info withNotifiedObject:object];
}
- (NSArray *)getComboCourseBannerArray
{
    return self.comboCoursebannerOperation.bannerList;
}


- (NSArray *)getHomeAnswerArray
{
    return self.bannerOperation.answerList;
}
- (NSArray *)getHomeFreeArray
{
    return self.bannerOperation.freeList;
}
- (NSArray *)getHomeRecommendArray
{
    return self.bannerOperation.RecommendList;
}
- (NSDictionary *)getHomeTKdata
{
    return self.bannerOperation.TKdata;
}

- (void)getXitongbanListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_GiftList>)object
{
    [self.xitongbanOperation didRequestGiftListWithInfo:info withNotifiedObject:object];
}
- (NSArray *)getXitongbanArray
{
    return self.xitongbanOperation.livingBackYearList;
}


- (void)getLeadTypeWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_LeadtypeProtocol>)object
{
    [self.leadTypeOperation didRequestLeadtypeWithInfo:info withNotifiedObject:object];
}

- (NSArray *)getLeadTypeArray
{
    return self.leadTypeOperation.LeadtypeList;
}

- (void)getCategoryTeacherListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CategoryTeacherListProtocol>)object
{
    [self.CategoryTeacherListOperation didRequestCategoryTeacherListWithInfo:info withNotifiedObject:object];
}
- (NSArray *)getCategoryTeacherLis
{
    return self.CategoryTeacherListOperation.categoryTeacherList;
}



- (void)getLivingCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_LivingCourseProtocol>)object
{
    [self.livingCourseOperation didRequestLivingCourseWithInfo:info withNotifiedObject:object];
}
- (NSArray *)getLivingCourseArray
{
    return self.livingCourseOperation.livingCourseList;
}

- (NSDictionary *)getLivingCourseInfo
{
    return self.livingCourseOperation.livinghCourseCountInfo;
}

// 获取历史聊天记录
- (void)didRequestLiveChatRecordWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_LiveChatRecord>)object
{
    [self.liveChatRecordOpreation didRequestLiveChatRecordWithWithDic:infoDic WithNotifedObject:object];
}
- (NSArray *)getLiveChatRecordList
{
    return self.liveChatRecordOpreation.list;
}

// 发送聊天消息
- (void)didRequestSendMessageWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_SendMessage>)object
{
    [self.sendMessageOperation didRequestSendMessageWithWithDic:infoDic WithNotifedObject:object];
}
- (NSDictionary *)getMessageId
{
    return self.sendMessageOperation.info;
}

// 获取聊天室礼物列表
- (void)didRequestGiftListWithWithDic:(NSDictionary *)infoDic WithNotifedObject:(id<UserModule_GiftList>)object
{
    [self.giftLIstOperation didRequestGiftListWithInfo:infoDic withNotifiedObject:object];
}
- (NSArray *)getGiftList
{
    return self.giftLIstOperation.livingBackYearList;
}

// 获取邀请列表
- (void)didRequestShareListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ShareList>)object
{
    [self.shareListOperation didRequestShareListWithInfo:infoDic withNotifiedObject:object];
}
- (NSArray *)getShareList
{
    return self.shareListOperation.shareList;
}

// 获取会员卡信息
- (void)didRequestMyVIPCardWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyVIPCardInfo>)object
{
    [self.myVIPCardOperation didRequestMyVIPCardWithInfo:infoDic withNotifiedObject:object];
}
- (NSDictionary *)getVIPCardInfo
{
    return self.myVIPCardOperation.vipCardInfo;
}

// 会员卡详情
- (void)didRequestMyVIPCardDetailWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyVIPCardDetailInfo>)object
{
    [self.vipCardDetailOperation didRequestMyVIPCardDetailWithInfo:infoDic withNotifiedObject:object];
}
- (NSDictionary *)getVIPCardDetailInfo
{
    return self.vipCardDetailOperation.vipCardDetailInfo;
}

// 禁言
- (void)didRequestShutupWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_Shutup>)object
{
    [self.shutupOperation didRequestShutupWithInfo:infoDic withNotifiedObject:object];
}

// 模拟vip购买
- (void)didRequestMockVIPBuyWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MockVIPBuy>)object
{
    [self.mockVIPBuyOperation didRequestMockVIPBuyWithInfo:infoDic withNotifiedObject:object];
}
- (NSDictionary *)getVIPBuyInfo
{
    return self.mockVIPBuyOperation.vipBuyInfo;
}

// 模拟合伙人购买
- (void)didRequestMockPartnerBuyWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MockPartnerBuy>)object
{
    [self.mockPartnerBuyOperation didRequestMockPartnerBuyWithInfo:infoDic withNotifiedObject:object];
}
- (NSDictionary *)getPartnerBuyInfo
{
    return self.mockPartnerBuyOperation.partnerBuyInfo;
}

// 完善个人信息
- (void)completeUserInfoWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CompleteUserInfoProtocol>)object;
{
    [self.completeOperation didRequestCompleteUserInfoWithWithDic:infoDic withNotifiedObject:object];
}

// 我的消息
- (void)didRequestNotificationListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_NotificationList>)object
{
    [self.myNotificationOperation didRequestNotificationListWithInfo:infoDic withNotifiedObject:object];
}
- (NSArray *)getNotificationArray
{
    return self.myNotificationOperation.list;
}

// 获取收货地址
- (void)getAddressListWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AddressListProtocol>)object
{
    [self.addressListOperation didRequestAddressListWithWithDic:infoDic withNotifiedObject:object];
}
// 编辑收货地址
- (void)editAddressWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_EditAddressProtocol>)object
{
    [self.editAddressOperation didRequestEditAddressWithWithDic:infoDic withNotifiedObject:object];
}
- (NSArray *)getAddressList
{
    return self.addressListOperation.addressList;
}

// 删除地址
- (void)didRequestDeleteAddressWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_DeleteAddressProtocol>)object
{
    [self.deleteAddressOperation didRequestDeleteAddressWithCourseInfo:infoDic withNotifiedObject:object];
}

// 添加购物车
- (void)didRequestAddShoppingCarWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AddShoppingCarProtocol>)object
{
    [self.addShoppingCarOperation didRequestAddShoppingCarWithCourseInfo:infoDic withNotifiedObject:object];
}
// 删除购物车
- (void)didRequestDeleteShoppingCarWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_DeleteShoppingCarProtocol>)object
{
    [self.deleteShoppingCarOperation didRequestDeleteShoppingCarWithCourseInfo:infoDic withNotifiedObject:object];
}
// 清空购物车
- (void)didRequestCleanShoppingCarWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CleanShoppingCarProtocol>)object
{
    [self.cleanShoppingCarOperation didRequestCleanShoppingCarWithCourseInfo:infoDic withNotifiedObject:object];
}
// 我的购物车
- (void)didRequestShoppingCarListWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ShoppingCarListProtocol>)object
{
    [self.shoppingCarListOperation didRequestShoppingCarListWithCourseInfo:infoDic withNotifiedObject:object];
}
// 获取购物车列表
- (NSArray *)getShoppingCarList
{
    return self.shoppingCarListOperation.shoppingList;
}

// 获取订单列表
- (void)didRequestOrderListWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderListProtocol>)object
{
    [self.orderListOperation didRequestOrderListWithCourseInfo:infoDic withNotifiedObject:object];
}
- (NSArray *)getMyOrderList
{
    return self.orderListOperation.orderList;
}
- (int )getMyOrderListTotalCount
{
    return self.orderListOperation.orderTotalCount;
}

// 创建订单
- (void)didRequestCreateOrderWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CreateOrderProtocol>)object
{
    [self.createOrderOperation didRequestCreateOrderWithCourseInfo:infoDic withNotifiedObject:object];
}

// 评论
- (void)didRequestCommentZantWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_CommentZanProtocol>)object
{
    [self.commentZanOperation didRequestCommentZantWithCourseInfo:infoDic withNotifiedObject:object];
}
- (void)didRequestAddCommentWithCourseInfo:(NSDictionary * )infoDic withNotifiedObject:(id<UserModule_AddCommentProtocol>)object
{
    [self.addCommentOperation didRequestAddCommentWithCourseInfo:infoDic withNotifiedObject:object];
}










- (void)getUserInfoWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_GetUserInfo>)object
{
    [self.userInfoOperation didRequestGetUserInfoWithInfo:info withNotifiedObject:object];
}
- (NSDictionary *)getUserInfo
{
    return self.userInfoOperation.infoDic;
}
- (void)getMyCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyCourse>)object
{
    [self.myCourseOperation didRequestGetMyCourseWithInfo:info withNotifiedObject:object];
}
- (NSDictionary *)getMyCourse
{
    return self.myCourseOperation.infoDic;
}

- (NSArray *)getMyCourseList
{
    return self.myCourseOperation.list;
}

- (void)getCourseNoteWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseNoteProtocol>)object
{
    [self.courseNoteOperation getCourseNoteWith:info withNotifiedObject:object];
}
- (NSArray *)getCourseNoteArray
{
    return self.courseNoteOperation.courseNoteList;
}

- (void)getCourseTeacherWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseTeacherProtocol>)object
{
    [self.teacherOperation getCourseTeacherWith:info withNotifiedObject:object];
}
- (NSArray *)getCourseTeaccherArray
{
    return self.teacherOperation.list;
}

- (void)getMyNearlyStudyCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NearlyStudy>)object
{
    [self.nearlyStudyOperation getMyNearlyStudyCourseWith:info withNotifiedObject:object];
}
- (NSArray *)getMyNearlyStudyCourseList
{
    return self.nearlyStudyOperation.list;
}

- (NSDictionary *)getMyNearlyStudyCourseInfo
{
    return self.nearlyStudyOperation.info;
}
- (NSDictionary *)getMyOrderLivingCourseInfo
{
    return self.myOrderLivingCourseOperation.info;
}
- (NSDictionary *)getMyCollectionCourseInfo
{
    return self.myCollectionCourseOperation.info;
}

- (void)getMyOrderLivingCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyOrderLivingCourse>)object
{
    [self.myOrderLivingCourseOperation getMyOrderLivingCourseWith:info withNotifiedObject:object];
}
- (NSArray *)getMyOrderLivingCourseList
{
    return self.myOrderLivingCourseOperation.list;
}

- (void)getMyCollectionCourseWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_MyCollectionCourse>)object
{
    [self.myCollectionCourseOperation getMyCollectionCourseWith:info withNotifiedObject:object];
}
- (NSArray *)getMyCollectionCourseList
{
    return self.myCollectionCourseOperation.list;
}

- (void)getNewsCategoryWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsCategory>)object
{
    [self.newsCategoryOperation getNewsCategoryWith:info withNotifiedObject:object];
}
- (NSArray *)getNewsCategoryList
{
    return self.newsCategoryOperation.list;
}

- (void)getNewsListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsList>)object
{
    [self.newsListOperation getNewsListWith:info withNotifiedObject:object];
}
- (NSArray *)getNewsListList
{
    return self.newsListOperation.list;
}

- (NSDictionary * )getNewsListInfo
{
    return self.newsListOperation.info;
}


- (void)getNewsDetailWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_NewsDetail>)object
{
    [self.newsDetailOperation getNewsDetailWith:info withNotifiedObject:object];
}

- (NSDictionary *)getNewsDetailList
{
    return self.newsDetailOperation.info;
}

// 获取课程学习记录
- (void)getCourseStudyRecordWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_CourseStudyRecord>)object
{
    [self.courseStudyRecord getCourseStudyRecordListWith:info withNotifiedObject:object];
}
- (NSArray *)getCourseStudyRecordList
{
    return self.courseStudyRecord.list;
}

// 添加学习记录
- (void)getAddCourseStudyRecordListWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_AddCourseStudyRecord>)object
{
    [self.addCourseStudyRecordOperation getAddCourseStudyRecordListWith:info withNotifiedObject:object];
}
- (NSDictionary *)getAddCourseStudyRecordInfo
{
    return self.addCourseStudyRecordOperation.info;
}







- (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)pwd withNotifiedObject:(id<UserModule_LoginProtocol>)object
{
    [self.loginOperation didLoginWithUserName:userName andPassword:pwd withNotifiedObject:object];
}

- (void)resetPasswordWithOldPassword:(NSString *)oldPwd andNewPwd:(NSString *)newPwd withNotifiedObject:(id<UserModule_ResetPwdProtocol>)object
{
    [self.resetOperation didRequestResetPwdWithOldPwd:oldPwd andNewPwd:newPwd withNotifiedObject:object];
}

- (void)registWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RegistProtocol>)object
{
    [self.registOperation didRequestRegistWithWithDic:infoDic withNotifiedObject:object];
}

- (void)forgetPsdWithDic:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_ForgetPasswordProtocol>)object
{
    [self.forgetPsdOperation didRequestForgetPsdWithWithDic:infoDic withNotifiedObject:object];
}



- (void)bindRegCodeWithRegCode:(NSString *)regCode withNotifiedObject:(id<UserModule_bindRegCodeProtocol>)object
{
    [self.bindRegCodeOperation didBindRegCodeWithWithCode:regCode withNotifiedObject:object];
}

- (void)payOrderWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_PayOrderProtocol>)object
{
    [self.payOrderOperation didRequestPayOrderWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)payOrderByCoinWith:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_PayOrderByCoinProtocol>)object
{
    [self.payOrderByCoinOperation didRequestPayOrderByCoinWithCourseInfo:infoDic withNotifiedObject:object];
}


- (void)getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber withNotifiedObject:(id<UserModule_VerifyCodeProtocol>)object
{
    [self.verifyCodeOperation didRequestVerifyCodeWithWithPhoneNumber:phoneNumber withNotifiedObject:object];
}

- (void)getVerifyAccountWithAccountNumber:(NSString *)accountNumber withNotifiedObject:(id<UserModule_VerifyAccountProtocol>)object
{
    [self.verfyAccountOperation didRequestVerifyAccountWithWithAccountNumber:accountNumber withNotifiedObject:object];
}

- (void)didRequestAppVersionInfoWithNotifiedObject:(id<UserModule_AppInfoProtocol>)object
{
    [self.infoOperation didRequestAppInfoWithNotifedObject:object];
}



- (void)didRequestMyDiscountCouponWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_discountCouponProtocol>)object
{
    [self.discountCouponOperation didRequestDiscountCouponWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestAcquireDiscountCouponWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AcquireDiscountCouponProtocol>)object
{
    [self.acquireDisCountOperation didRequestAcquireDiscountCouponWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestAcquireDiscountCouponSuccessWithCourseInfo:(NSDictionary *)infoDic
{
    [self.acquireDisCountSuccessOperation didRequestAcquireDiscountCouponSuccessWithCourseInfo:infoDic];
}

- (void)didRequestIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object
{
    [self.recommendOperation didRequestIntegralWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestGetIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object
{
    [self.recommendOperation didRequestGetIntegralWithCourseInfo:infoDic withNotifiedObject:object];
}
- (void)didRequestGetRecommendIntegralWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_RecommendProtocol>)object
{
    [self.recommendOperation didRequestGetRecommendIntegralWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestAssistantWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_AssistantCenterProtocol>)object
{
    [self.assistantCenterOperation didRequestAssistantWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestLevelDetailWithNotifiedObject:(id<UserModule_LevelDetailProtocol>)object
{
    [self.memberLevelDetailOperation didRequestMemberLevelDetailWithNotifiedObject:object];
}

- (void)didRequestSubmitOpinionWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitOperationProtocol>)object
{
    [self.submitOpinionOperation didRequestSubmitOpinionWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestCommonProblemWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CommonProblem>)object
{
    [self.commonProblemOperation didRequestCommonProblemWithNotifiedObject:object];
}

- (void)didRequestGiftListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_GiftList>)object
{
    [self.giftLIstOperation didRequestGiftListWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestSubmitGiftCodeWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_SubmitGiftCode>)object
{
    [self.submitGiftCodeOperation didRequestSubmitGiftCodeWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestLivingBackYearListWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_LivingBackYearList>)object
{
    [self.livingBackYearLiatOperation didRequestLivingBackYearListWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestVerifyInAppPurchaseWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_VerifyInAppPurchase>)object
{
    [self.verifyInAppPurchaseOperation didRequestVerifyInAppPurchaseWithInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestMyCoinsWithInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_MyCoin>)object
{
    [self.myCoinOperation didRequestMyCoinWithNotifiedObject:object];
}

- (NSArray *)getBills
{
    return self.myCoinOperation.bills;
}

// 获取考试倒计时
- (void)getExamCountDownWith:(NSDictionary *)info withNotifiedObject:(id<UserModule_GetExamCountDown>)object
{
    [self.getExamCountDown getExamCountDownWith:info withNotifiedObject:object];
}
- (NSDictionary *)getExamCountDownInfo
{
    return self.getExamCountDown.info;
}

- (void)logout
{
    [self.loginOperation clearLoginUserInfo];
}

- (void)refreshRCDUserInfoWithNickName:(NSString *)nickName andWithPortraitUrl:(NSString *)portraitUrl
{
   
}

- (int)getUserId
{
    return self.userModuleModels.currentUserModel.userID;
}

- (int)getCodeview
{
    return self.userModuleModels.currentUserModel.codeview;
}

- (void)changeCodeViewWith:(int)codeView
{
    self.userModuleModels.currentUserModel.codeview = codeView;
}

- (void)didRequestBindJPushWithCID:(NSString *)cid withNotifiedObject:(id<UserModule_BindJPushProtocol>)object
{
    [self.bindJPushOperation didRequestBindJPushWithCID:cid withNotifiedObject:object];
}


- (void)didRequestOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderLivingCourseProtocol>)object
{
    [self.orderLivingCourseOperation didRequestOrderLivingCourseWithCourseInfo:infoDic withNotifiedObject:object];
}

- (void)didRequestCancelOrderLivingCourseOperationWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_CancelOrderLivingCourseProtocol>)object
{
    [self.cancelOrderLivingCOurseOperation didRequestCancelOrderLivingCourseWithCourseInfo:infoDic withNotifiedObject:object];
}

- (BOOL)isUserLogin
{
    return self.userModuleModels.currentUserModel.isLogin;
}

- (NSString *)getUserName
{
    return self.userModuleModels.currentUserModel.userName;
}
- (NSString *)getUserNickName
{
    return self.userModuleModels.currentUserModel.userNickName;
}

- (NSString *)getVerifyCode
{
    return self.verifyCodeOperation.verifyCode;
}

- (NSString *)getVerifyPhoneNumber
{
    return self.verfyAccountOperation.verifyPhoneNumber;
}

- (NSString *)getRongToken
{
    return @"";
}
- (NSString *)getIconUrl
{
    return self.userModuleModels.currentUserModel.headImageUrl;
}
- (int)getUserLevel
{
    return 0;
}

- (NSString *)getLevelStr
{
    NSString * levelStr = @"";
    
    return levelStr;
}

- (BOOL)isHaveMemberLevel
{
    return NO;
}

- (NSDictionary *)getUserInfos
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (self.userModuleModels.currentUserModel.userID == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfLoginClick object:nil];
        return dic;
    }
    [dic setObject:self.userModuleModels.currentUserModel.userName forKey:kUserName];
    [dic setObject:@(self.userModuleModels.currentUserModel.userID) forKey:kUserId];
    [dic setObject:self.userModuleModels.currentUserModel.userNickName forKey:kUserNickName];
    
    [dic setObject:self.userModuleModels.currentUserModel.headImageUrl forKey:kUserHeaderImageUrl];
    [dic setObject:self.userModuleModels.currentUserModel.telephone forKey:kUserTelephone];
    [dic setObject:self.userModuleModels.currentUserModel.sex forKey:kUserSex];
    [dic setObject:self.userModuleModels.currentUserModel.openId forKey:kOpenId];
//    dic setObject:self.userModuleModels.currentUserModel. forKey:<#(nonnull id<NSCopying>)#>
    return dic;
}

- (void)refreshUserInfoWith:(NSDictionary *)infoDic
{
    
    
    if ([infoDic objectForKey:@"icon"] && [[infoDic objectForKey:@"icon"] length] > 0) {
        self.userModuleModels.currentUserModel.headImageUrl = [infoDic objectForKey:@"icon"];
        
    }else
    {
        
    }
    
    if ([infoDic objectForKey:@"phoneNumber"] && [[infoDic objectForKey:@"phoneNumber"] length] > 0) {
        self.userModuleModels.currentUserModel.telephone = [infoDic objectForKey:@"phoneNumber"];
    }
    
    if ([infoDic objectForKey:@"nickName"] && [[infoDic objectForKey:@"nickName"] length] > 0) {
        self.userModuleModels.currentUserModel.userNickName = [infoDic objectForKey:@"nickName"];
        
    }else
    {
        
    }
    
    NSString *dataPath = [[PathUtility getDocumentPath] stringByAppendingPathComponent:@"user.data"];
    [NSKeyedArchiver archiveRootObject:self.userModuleModels.currentUserModel toFile:dataPath];
}

- (NSDictionary *)getUpdateInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.userModuleModels.appInfoModel.updateContent forKey:kAppUpdateInfoContent];
    [dic setObject:@(self.userModuleModels.appInfoModel.version) forKey:kAppUpdateInfoVersion];
    [dic setObject:self.userModuleModels.appInfoModel.downloadUrl forKey:kAppUpdateInfoUrl];
    [dic setObject:@(self.userModuleModels.appInfoModel.isForce) forKey:kAppUpdateInfoIsForce];
    return dic;
}

- (NSDictionary *)getPayOrderDetailInfo
{
    return self.payOrderOperation.payOrderDetailInfo;
}



// 获取我的订单_未支付列表
- (void)didRequestOrderList_NoPayWithCourseInfo:(NSDictionary *)infoDic withNotifiedObject:(id<UserModule_OrderList_NoPayProtocol>)object
{
    [self.orderList_NoPayOperation didRequestOrderList_NoPayWithCourseInfo:infoDic withNotifiedObject:object];
}
- (NSArray *)getMyOrder_NoPayList
{
    return self.orderList_NoPayOperation.orderList;
}


- (NSArray *)getAllDiscountCoupon
{
    return self.discountCouponOperation.discountCouponArray;
}

- (NSArray *)getAcquireDiscountCoupon
{
    return self.acquireDisCountOperation.discountCouponArray;
}

- (NSArray *)getNormalDiscountCoupon
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * infoDic in self.discountCouponOperation.discountCouponArray) {
        if ([[infoDic objectForKey:@"State"] intValue] == 0) {
            [array addObject:infoDic];
        }
    }
    
    return array;
}
- (NSArray *)getexpireDiscountCoupon
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * infoDic in self.discountCouponOperation.discountCouponArray) {
        if ([[infoDic objectForKey:@"State"] intValue] == 2) {
            [array addObject:infoDic];
        }
    }
    return array;
}
- (NSArray *)getCannotUseDiscountCoupon:(double)price
{
    NSMutableArray * array = [NSMutableArray array];
    
    NSMutableArray * canUseArray = [NSMutableArray array];
    NSMutableArray *cannotArray = [NSMutableArray array];
    for (NSDictionary * infoDic in self.discountCouponOperation.discountCouponArray) {
        if ([[infoDic objectForKey:@"State"] intValue] == 0 &&  [[infoDic objectForKey:@"Area"] doubleValue] <= price) {
            [canUseArray addObject:infoDic];
        }else if ([[infoDic objectForKey:@"State"] intValue] == 0)
        {
            [cannotArray addObject:infoDic];
        }
        
    }
    [array addObject:canUseArray];
    [array addObject:cannotArray];
    return array;
}
- (NSArray *)getHaveUsedDiscountCoupon
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * infoDic in self.discountCouponOperation.discountCouponArray) {
        if ([[infoDic objectForKey:@"State"] intValue] == 1) {
            [array addObject:infoDic];
        }
        
    }
    return array;
}

- (int)getIntegral
{
    return self.recommendOperation.integral;
}
- (NSDictionary *)getRecommendIntegral
{
    return self.recommendOperation.recommendInfo;
}

- (NSArray *)getAssistantList
{
    return self.assistantCenterOperation.assistantList;
}

- (NSArray *)getTelephoneList
{
    return self.assistantCenterOperation.telephoneNumberList;
}

- (NSArray *)getLevelDetailList
{
    return self.memberLevelDetailOperation.memberLevelDetailList;
}

- (NSArray *)getCommonProblemList
{
    return self.commonProblemOperation.commonProblemList;
}

- (NSArray *)getLivingBackYearList
{
    return self.livingBackYearLiatOperation.livingBackYearList;
}



- (void)resetGoldCoinCount:(int )count
{
    self.userModuleModels.currentUserModel.goldCoins = count;
}

- (int)getMyGoldCoins
{
    return self.userModuleModels.currentUserModel.goldCoins;
}

@end
