//
//  HttpConfigCreator.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConfigModel.h"

@interface HttpConfigCreator : NSObject

+ (HttpConfigModel *)getBannerHttpConfigWith:(NSDictionary *)info;
+ (HttpConfigModel *)getLeadTypeHttpConfigWith:(NSDictionary *)info;
+ (HttpConfigModel *)getCategoryTeacherListHttpConfigWith:(NSDictionary *)info;
+ (HttpConfigModel *)getSecondCategoeyHttpConfigWith:(NSDictionary *)info;
+ (HttpConfigModel *)getCategoeyCourseHttpConfigWith:(NSDictionary *)info;
+ (HttpConfigModel *)getCourseDetailHttpConfigWith:(NSDictionary *)info;
+ (HttpConfigModel *)getLoginHttpConfigWithUserName:(NSString *)userName andPassword:(NSString *)password;
+ (HttpConfigModel *)getPublishConfigWithInfo:(NSDictionary *)questionInfo;
+ (HttpConfigModel *)getVerifyCode:(NSDictionary *)phoneNumber;

+ (HttpConfigModel *)registWith:(NSDictionary *)infoDic;
+ (HttpConfigModel *)getQuestionDetailConfigWithQuestionId:(NSDictionary *)infoDic;
+ (HttpConfigModel *)CollectQuestionWith:(NSDictionary *)infoDic;
+ (HttpConfigModel *)getReplayQuestionWith:(NSDictionary *)infoDic;
+ (HttpConfigModel *)getTikuMainInfoWith:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getTestChapterInfoWithId:(NSDictionary *)infoDic;
+ (HttpConfigModel *)completeUserInfo:(NSDictionary *)userInfo;
+ (HttpConfigModel *)getUserInfo:(NSDictionary *)userInfo;
+ (HttpConfigModel *)getMyCourse:(NSDictionary *)userInfo;
+ (HttpConfigModel *)getTestSectionInfoWithId:(NSDictionary *)infoDic;
+ (HttpConfigModel *)getTestCollectQuestionWithQuestionId:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getTestUncollectQuestionWithQuestionId:(NSDictionary *)infoDic;
+ (HttpConfigModel *)getTestSimulateQuestionWithId:(NSDictionary *)infoDic;



#pragma mark - 一下不用
+ (HttpConfigModel *)getBannerHttpConfig;


+ (HttpConfigModel *)getHotSearchCourse;

+ (HttpConfigModel *)getHottestHttpConfig;

+(HttpConfigModel *)getSearchVideoCoueseHttpConfigWith:(NSString *)keyword;

+(HttpConfigModel *)getSearchLivestreamHttpConfigWith:(NSString *)keyword;

+ (HttpConfigModel *)getCourseDetailConfigWithCourseID:(int)courseID;

+ (HttpConfigModel *)getAllCourseConfig;

+ (HttpConfigModel *)getAllPackage;

+ (HttpConfigModel *)getQuestionConfigWithPageCount:(NSDictionary *)infoDic;



+ (HttpConfigModel *)getAllCategoryConfig;

+ (HttpConfigModel *)getCategoryDetailConfigWithCategoryId:(int)categoryId andUserId:(int)userId;

+ (HttpConfigModel *)getResetPwdConfigWithOldPwd:(NSString *)oldPwd andNewPwd:(NSString *)newPwd;


+ (HttpConfigModel *)getHistoryConfig;

+ (HttpConfigModel *)getAllMyNoteConfig;

+ (HttpConfigModel *)getLearningConfig:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getCollectConfig;

+ (HttpConfigModel *)getMyQuestionAlreadyReplyConfig;

+ (HttpConfigModel *)getMyQuestionNotReplyConfig;

+ (HttpConfigModel *)getAddCollectCourseConfigWithCourseId:(NSDictionary *)courseId;

+ (HttpConfigModel *)getDeleteCollectCourseConfigWithCourseId:(NSDictionary *)courseId;

+ (HttpConfigModel *)getDeleteMyCourseConfigWithCourseInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getAddVideoNoteConfigWithInfo:(NSDictionary *)info;

+ (HttpConfigModel *)getDeleteVideoNoteConfigWithId:(int)noteId;

+ (HttpConfigModel *)getAddHistoryConfigWithInfo:(NSDictionary *)info;

+ (HttpConfigModel *)getTestAllCategoryConfig:(int)userId;


+ (HttpConfigModel *)getTestSimulateInfoWithId:(NSDictionary *)cateInfo;



+ (HttpConfigModel *)getTestSimulateScoreWithInfo:(NSArray *)array;

+ (HttpConfigModel *)getAppVersionInfoConfig;

+ (HttpConfigModel *)getTestErrorInfoWithId:(int)cateId;

+ (HttpConfigModel *)getTestErrorQuestionWithSectionId:(NSDictionary *)sectionInfo;

+ (HttpConfigModel *)getTestAddMyWrongQuestionWithQuestionId:(int)questionId;

+ (HttpConfigModel *)getTestMyWrongChapterListWithCategoryId:(int)cateId;

+ (HttpConfigModel *)getTestMyWrongQuestionWithId:(NSDictionary *)sectionInfo;

+(HttpConfigModel *)getTestCollectionInfoWithCategoryId:(NSDictionary *)cateId;

+(HttpConfigModel *)getTestCollectionQuestionListWithChapterId:(NSDictionary *)chapterInfo;



+ (HttpConfigModel *)getTestJurisdictionWithCourseId:(int)courseId;

+ (HttpConfigModel *)getTestHistoryConfigWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getTestHistoryDetailConfigWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getNotStartLiveingCourseWith:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getMyLiveingCourseWith:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getEndLivingCourse;

+ (HttpConfigModel *)getLivingSectionDetailWithInfo:(NSDictionary *) infoDic;

+ (HttpConfigModel *)getLivingJurisdictionWithInfo:(NSDictionary *) infoDic;

+ (HttpConfigModel *)getOrderLivingCourseWithCourseInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getCancelOrderLivingCourseWithCourseInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getBindJPushWithCId:(NSString *)CID;



+ (HttpConfigModel *)forgetPasswordWith:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getVerifyAccount:(NSString *)accountNumber;


+ (HttpConfigModel *)bindRegCode:(NSString *)regCode;

+ (HttpConfigModel *)payOrderWithInfo:(NSDictionary *)orderInfo;

+ (HttpConfigModel *)discountCoupon;

+ (HttpConfigModel *)acquireDiscountCoupon;

+ (HttpConfigModel *)acquireDiscountCouponSuccess:(NSDictionary *)infoDic;

+ (HttpConfigModel *)orderList:(NSDictionary *)info;

+ (HttpConfigModel *)recommend;

+ (HttpConfigModel *)getRecommend:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getRecommendIntegral;

+ (HttpConfigModel *)getAssistantCnter:(NSDictionary *)info;

+ (HttpConfigModel *)getMemberLevelDetail;

+ (HttpConfigModel *)submitOpinionWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)commonProblem;

+ (HttpConfigModel *)testRecordWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)testRecordQuestionWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)testDailyPracticeWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)testDailyPracticeQuestionWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getLivingBackYearWithInfo:(NSDictionary *)infoDic;

+ (HttpConfigModel *)getGiftListWithInfo:(NSDictionary *)infoDic;

+(HttpConfigModel *)submitGiftCode:(NSDictionary *)infoDic;

+(HttpConfigModel *)allPackage:(NSDictionary *)infoDic;

+(HttpConfigModel *)getPackageDetail:(int)packageId;

+(HttpConfigModel *)verifyAppleInAppPurchase:(NSDictionary *)infoDic;

+(HttpConfigModel *)getMyGolgCoin;

@end
