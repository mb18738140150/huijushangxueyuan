//
//  HttpConfigCreator.m
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#import "HttpConfigCreator.h"
#import "NSString+MD5.h"
#import "NSDictionary+JsonString.h"
#import "NetMacro.h"
#import "UserManager.h"
#import "CommonMacro.h"
#import "DateUtility.h"

@implementation HttpConfigCreator

+ (HttpConfigModel *)getBannerHttpConfigWith:(NSDictionary *)info
{
    HttpConfigModel *bannerHttp = [[HttpConfigModel alloc] init];
    [self setConfigModel:bannerHttp withInfo:info];
    return bannerHttp;
}

+ (HttpConfigModel *)getLeadTypeHttpConfigWith:(NSDictionary *)info
{
    HttpConfigModel *leadTypeHttp = [[HttpConfigModel alloc] init];
    [self setConfigModel:leadTypeHttp withInfo:info];
    return leadTypeHttp;
}

+ (HttpConfigModel *)getCategoryTeacherListHttpConfigWith:(NSDictionary *)info
{
    HttpConfigModel *CategoryTeacherListHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kOneId:[info objectForKey:kOneId],
                          kUid:[info objectForKey:kUid],
                          kUrlName:[info objectForKey:kUrlName]
                          };
    [self setConfigModel:CategoryTeacherListHttp withInfo:dic];
    return CategoryTeacherListHttp;
}
+ (HttpConfigModel *)getSecondCategoeyHttpConfigWith:(NSDictionary *)info
{
    HttpConfigModel *SecondCategoeyHttp = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:SecondCategoeyHttp withInfo:info];
    return SecondCategoeyHttp;
}

+ (HttpConfigModel *)getCategoeyCourseHttpConfigWith:(NSDictionary *)info
{
    HttpConfigModel *SecondCategoeyHttp = [[HttpConfigModel alloc] init];
    [self setConfigModel:SecondCategoeyHttp withInfo:info];
    return SecondCategoeyHttp;
}

+ (HttpConfigModel *)getCourseDetailHttpConfigWith:(NSDictionary *)info
{
    HttpConfigModel *SecondCategoeyHttp = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:SecondCategoeyHttp withInfo:info];
    return SecondCategoeyHttp;
}

+ (HttpConfigModel *)getAddVideoNoteConfigWithInfo:(NSDictionary *)info
{
    HttpConfigModel *add = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:add withInfo:info];
    return add;
}

+ (HttpConfigModel *)getLoginHttpConfigWithUserName:(NSString *)userName andPassword:(NSString *)password
{
    HttpConfigModel *loginHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kUrlName:@"Account/Login",
                          @"userName":userName,
                          @"password":password};
    [self setConfigModel:loginHttp withInfo:dic];
    return loginHttp;
}

+ (HttpConfigModel *)getVerifyCode:(NSDictionary *)phoneNumber
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setVerifyCodeConfigModel:c withInfo:phoneNumber];
    return c;
}


+ (HttpConfigModel *)registWith:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];

    [self setConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getPublishConfigWithInfo:(NSDictionary *)questionInfo
{
    HttpConfigModel *pubModel = [[HttpConfigModel alloc] init];
   
    [self setConfigModel:pubModel withInfo:questionInfo];
    return pubModel;
}

+ (HttpConfigModel *)getQuestionDetailConfigWithQuestionId:(NSDictionary *)infoDic
{
    HttpConfigModel *detailHttp = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:detailHttp withInfo:infoDic];
    return detailHttp;
}

+ (HttpConfigModel *)CollectQuestionWith:(NSDictionary *)infoDic
{
    HttpConfigModel *detailHttp = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:detailHttp withInfo:infoDic];
    return detailHttp;
}

+ (HttpConfigModel *)getReplayQuestionWith:(NSDictionary *)infoDic
{
    HttpConfigModel *detailHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kUid:[infoDic objectForKey:kUid],
                          kAnswerId:[infoDic objectForKey:kAnswerId],
                          kUrlName:[infoDic objectForKey:kUrlName],
                          @"Content":[infoDic objectForKey:kContent]
                          };
    [self setConfigModel:detailHttp withInfo:dic];
    return detailHttp;
}

+ (HttpConfigModel *)getTikuMainInfoWith:(NSDictionary *)infoDic
{
    HttpConfigModel *detailHttp = [[HttpConfigModel alloc] init];

    [self setConfigModel:detailHttp withInfo:infoDic];
    return detailHttp;
}

+ (HttpConfigModel *)getTestSimulateInfoWithId:(NSDictionary *)cateInfo
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:cateInfo];
    return c;
}

+ (HttpConfigModel *)getTestChapterInfoWithId:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];

    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)completeUserInfo:(NSDictionary *)userInfo
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setConfigModel:c withInfo:userInfo];
    return c;
}

+ (HttpConfigModel *)getUserInfo:(NSDictionary *)userInfo
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setConfigModel:c withInfo:userInfo];
    return c;
}

+ (HttpConfigModel *)orderList:(NSDictionary *)info
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setConfigModel:c withInfo:info];
    return c;
}

+ (HttpConfigModel *)getMyCourse:(NSDictionary *)userInfo
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setConfigModel:c withInfo:userInfo];
    return c;
}

+ (HttpConfigModel *)testDailyPracticeWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+(HttpConfigModel *)getTestCollectionQuestionListWithChapterId:(NSDictionary *)chapterInfo
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:chapterInfo];
    return c;
}

+ (HttpConfigModel *)getTestErrorQuestionWithSectionId:(NSDictionary *)sectionInfo
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:sectionInfo];
    return c;
}

+ (HttpConfigModel *)testRecordWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+(HttpConfigModel *)getTestCollectionInfoWithCategoryId:(NSDictionary *)cateId
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:cateId];
    return c;
}

+ (HttpConfigModel *)getAppVersionInfoConfig
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kUid:@([[UserManager sharedManager] getUserId]),
                          kUrlName:@"tk/GetErrorMade"};
    [self setKJBConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getTestSectionInfoWithId:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getTestHistoryDetailConfigWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getTestCollectQuestionWithQuestionId:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getTestUncollectQuestionWithQuestionId:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)testDailyPracticeQuestionWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getTestMyWrongQuestionWithId:(NSDictionary *)sectionInfo
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:sectionInfo];
    return c;
}

+ (HttpConfigModel *)testRecordQuestionWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getTestSimulateQuestionWithId:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}


+ (HttpConfigModel *)payOrderWithInfo:(NSDictionary *)orderInfo
{
    HttpConfigModel * c = [[HttpConfigModel alloc]init];
    [self setConfigModel:c withInfo:orderInfo];
    
    return c;
}


+(HttpConfigModel *)verifyAppleInAppPurchase:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setConfigModel:c withInfo:infoDic];
    return c;
}

+(HttpConfigModel *)getMyGolgCoin
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{
                          kUrlName:@"Account/GetIosCoinInfo"
                          };
    [self setConfigModel:c withInfo:dic];
    return c;
}

















#pragma mark - 一下不用
+ (HttpConfigModel *)getBannerHttpConfig
{
    HttpConfigModel *bannerHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandBanner};
    [self setConfigModel:bannerHttp withInfo:dic];
    return bannerHttp;
}






+ (HttpConfigModel *)getTestAllCategoryConfig:(int)userId
{
    HttpConfigModel *cate = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandTestCategory,
                          @"userId":@(userId)
                          };
    [self setKJBConfigModel:cate withInfo:dic];
    return cate;
}

+ (HttpConfigModel *)getCategoryDetailConfigWithCategoryId:(int)categoryId andUserId:(int)userId
{
    HttpConfigModel *categoryDetailHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandCategoryDetail,
                          @"userId":@(userId),
                          @"cateId":@(categoryId),
                          @"page":@1,
                          @"limit":@1000
                          };
    [self setConfigModel:categoryDetailHttp withInfo:dic];
    return categoryDetailHttp;
}

+ (HttpConfigModel *)getCourseDetailConfigWithCourseID:(int)courseID
{
    HttpConfigModel *detailHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandDetailCourse,
                          @"courseId":@(courseID),
                          @"page":@1,
                          @"limit":@1000};
    [self setConfigModel:detailHttp withInfo:dic];
    return detailHttp;
}

+ (HttpConfigModel *)getQuestionConfigWithPageCount:(NSDictionary *)infoDic
{
    HttpConfigModel *wendaHttp = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:wendaHttp withInfo:infoDic];
    return wendaHttp;
}













+ (HttpConfigModel *)getHotSearchCourse
{
    HttpConfigModel *searchHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandHotSearchCourse,
                          @"userId":@"0"};
    [self setConfigModel:searchHttp withInfo:dic];
    return searchHttp;
}

+ (HttpConfigModel *)getHottestHttpConfig
{
    HttpConfigModel *hotHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandHottestCourse};
    [self setConfigModel:hotHttp withInfo:dic];
    return hotHttp;
}

+(HttpConfigModel *)getSearchVideoCoueseHttpConfigWith:(NSString *)keyword
{
    HttpConfigModel *hotHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandSearchCourse,
                          @"KeyWord":keyword,
                          @"userId":@"0",
                          @"Type":@"video"};
    [self setConfigModel:hotHttp withInfo:dic];
    return hotHttp;
}

+(HttpConfigModel *)getSearchLivestreamHttpConfigWith:(NSString *)keyword
{
    HttpConfigModel *hotHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandSearchCourse,
                          @"KeyWord":keyword,
                          @"userId":@"0",
                          @"Type":@"liveStream"};
    [self setConfigModel:hotHttp withInfo:dic];
    return hotHttp;
}



+ (HttpConfigModel *)getAllCourseConfig
{
    HttpConfigModel *allCourseHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandAllCourse};
    [self setConfigModel:allCourseHttp withInfo:dic];
    return allCourseHttp;
}

+ (HttpConfigModel *)getAllPackage
{
    HttpConfigModel *allCourseHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kGetAllPackage};
    [self setConfigModel:allCourseHttp withInfo:dic];
    return allCourseHttp;
}


+ (HttpConfigModel *)getAllCategoryConfig
{
    HttpConfigModel *categoryHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandAllCategory};
    [self setConfigModel:categoryHttp withInfo:dic];
    return categoryHttp;
}



+ (HttpConfigModel *)getResetPwdConfigWithOldPwd:(NSString *)oldPwd andNewPwd:(NSString *)newPwd
{
    HttpConfigModel *categoryDetailHttp = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandResetPwd,
                          @"newPassword":newPwd,
                          @"oldPassword":oldPwd};
    [self setConfigModel:categoryDetailHttp withInfo:dic];
    return categoryDetailHttp;
}


+ (HttpConfigModel *)getHistoryConfig
{
    HttpConfigModel *history = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandHistory};
    [self setConfigModel:history withInfo:dic];
    return history;
}



+ (HttpConfigModel *)getDeleteVideoNoteConfigWithId:(int)noteId
{
    HttpConfigModel *delete = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandDeleteVideoNote,
                          @"id":@(noteId)};
    [self setConfigModel:delete withInfo:dic];
    return delete;
}

+ (HttpConfigModel *)getLearningConfig:(NSDictionary *)infoDic
{
    HttpConfigModel *learning = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandLearningCourse,
                          @"type":[infoDic objectForKey:@"type"]};
    [self setConfigModel:learning withInfo:dic];
    return learning;
}

+ (HttpConfigModel *)getMyQuestionAlreadyReplyConfig
{
    HttpConfigModel *reply = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandMyQuestion,
                          @"type":@"1"};
    [self setConfigModel:reply withInfo:dic];
    return reply;
}

+ (HttpConfigModel *)getMyQuestionNotReplyConfig
{
    HttpConfigModel *not = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandMyQuestion,
                          @"type":@"0"};
    [self setConfigModel:not withInfo:dic];
    return not;
}

+ (HttpConfigModel *)getCollectConfig
{
    HttpConfigModel *collect = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandCollectCourse};
    [self setConfigModel:collect withInfo:dic];
    return collect;
}

+ (HttpConfigModel *)getAllMyNoteConfig
{
    HttpConfigModel *note = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kUrlName:@"personal/GetMyNote",
                          kUid:@([[UserManager sharedManager] getUserId])
                          };
    [self setConfigModel:note withInfo:dic];
    return note;
}

+ (HttpConfigModel *)getAddHistoryConfigWithInfo:(NSDictionary *)info
{
    HttpConfigModel *add = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandAddHistory,
                          @"courseId":[info objectForKey:kCourseID],
                          @"chapterId":[info objectForKey:kChapterId],
                          @"videoId":[info objectForKey:kVideoId]};
    [self setConfigModel:add withInfo:dic];
    return add;
}

+ (HttpConfigModel *)getAddCollectCourseConfigWithCourseId:(NSDictionary *)courseId
{
    HttpConfigModel *add = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:add withInfo:courseId];
    return add;
}

+ (HttpConfigModel *)getDeleteCollectCourseConfigWithCourseId:(NSDictionary *)courseId
{
    HttpConfigModel *delete = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:delete withInfo:courseId];
    return delete;
}

+ (HttpConfigModel *)getDeleteMyCourseConfigWithCourseInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *delete = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandDeleteMyLearningCourse,
                          @"id":[infoDic objectForKey:kCourseID],
                          @"type":[infoDic objectForKey:@"type"]};
    [self setConfigModel:delete withInfo:dic];
    return delete;
}









+ (HttpConfigModel *)getTestSimulateScoreWithInfo:(NSArray *)array
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandTestSimulateScore,
                          @"answers":array};
    [self setKJBConfigModel:c withInfo:dic];
    return c;
}



+ (HttpConfigModel *)getTestErrorInfoWithId:(int)cateId
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandTestErrorInfo,
                          @"id":@(cateId),
                          @"type":@"easywrong",
                          @"category":@(2)};
    [self setKJBConfigModel:c withInfo:dic];
    return c;

}



+ (HttpConfigModel *)getTestAddMyWrongQuestionWithQuestionId:(int)questionId
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandAddMyWrongQuestion,
                          @"id":@[@(questionId)],
                          @"contents":@"1",
                          @"type":@"wrongbook"};
    [self setKJBConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getTestMyWrongChapterListWithCategoryId:(int)cateId
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandTestMyWrongChapter,
                          @"id":@(cateId),
                          @"type":@"wrongbook",
                          @"category":@(2)};
    [self setKJBConfigModel:c withInfo:dic];
    return c;
}









+ (HttpConfigModel *)getTestJurisdictionWithCourseId:(int)courseId
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandJurisdictionCourse,
                          @"userId":@"0",
                          @"categoryId":@(courseId)};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getTestHistoryConfigWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    
    [self setKJBConfigModel:c withInfo:infoDic];
    return c;
}



+ (HttpConfigModel *)getNotStartLiveingCourseWith:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandGetLiveingCourse,
                          @"userId":@"0",
                          @"Type":@(2),
                          @"Month":[infoDic objectForKey:@"Month"],
                          @"Year":[infoDic objectForKey:@"year"]};
    [self setConfigModel:c withInfo:dic];
    return c;
}


+ (HttpConfigModel *)getMyLiveingCourseWith:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandMyLivingCourse};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getEndLivingCourse
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandGetLiveingCourse,
                          @"userId":@"0",
                          @"Type":@(0)};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getLivingSectionDetailWithInfo:(NSDictionary *) infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getLivingJurisdictionWithInfo:(NSDictionary *) infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:@"",
                          @"userId":@"0",
                          @"courseId":[infoDic objectForKey:kCourseID]};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getOrderLivingCourseWithCourseInfo:(NSDictionary *)infoDic;
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
   
    [self setConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getCancelOrderLivingCourseWithCourseInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    
    [self setConfigModel:c withInfo:infoDic];
    return c;
}

+ (HttpConfigModel *)getBindJPushWithCId:(NSString *)CID
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandBindJPush,
                          @"userId":@"0",
                          @"device":@(1),
                          @"CID":CID};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getVerifyAccount:(NSString *)accountNumber
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandVerifyAccount,
                          @"accountNumber":accountNumber
                          };
    [self setConfigModel:c withInfo:dic];
    return c;
}


+ (HttpConfigModel *)bindRegCode:(NSString *)regCode
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kBindRegCode,
                          @"regCode":regCode
                          };
    [self setConfigModel:c withInfo:dic];
    return c;
}





+ (HttpConfigModel *)forgetPasswordWith:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandForgetPassword,
                          @"phoneNumber":[infoDic objectForKey:@"phoneNumber"],
                          @"password":[infoDic objectForKey:@"password"],
                          @"accountNumber":[infoDic objectForKey:@"accountNumber"]
                          };
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)discountCoupon
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kDiscountCoupon,
                          @"page":@(1),
                          @"type":@(3)
                          };
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)acquireDiscountCoupon
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kAcquireDiscountCoupon};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)acquireDiscountCouponSuccess:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kAcquireDiscountCouponSuccess,
                          @"couponIdStr":[infoDic objectForKey:@"couponIdStr"],
                          @"page":@(1)
                          };
    [self setConfigModel:c withInfo:dic];
    return c;
}



+ (HttpConfigModel *)recommend
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kRecommend};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getRecommend:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kGetRecommend,
                          @"type":[infoDic objectForKey:@"type"]};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getRecommendIntegral
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kGetRecommendIntegral};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getAssistantCnter:(NSDictionary *)info
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setConfigModel:c withInfo:info];
    return c;
}

+ (HttpConfigModel *)getMemberLevelDetail
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommandMemberLevelDetail};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)submitOpinionWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kSubmitOpinion,
                          @"opinion":[infoDic objectForKey:@"opinion"]};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)commonProblem
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kCommonProblem};
    [self setConfigModel:c withInfo:dic];
    return c;
}








+ (HttpConfigModel *)getLivingBackYearWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kLivingBackYearList};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+ (HttpConfigModel *)getGiftListWithInfo:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    [self setConfigModel:c withInfo:infoDic];
    return c;
}

+(HttpConfigModel *)submitGiftCode:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kSubmitGidtCode,
                          @"actCode":[infoDic objectForKey:@"actCode"]
                          };
    [self setConfigModel:c withInfo:dic];
    return c;
}

+(HttpConfigModel *)allPackage:(NSDictionary *)infoDic
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kGetAllPackage};
    [self setConfigModel:c withInfo:dic];
    return c;
}

+(HttpConfigModel *)getPackageDetail:(int)packageId
{
    HttpConfigModel *c = [[HttpConfigModel alloc] init];
    NSDictionary *dic = @{kCommand:kPackageDetail,
                          @"packageId":@(packageId)
                          };
    [self setConfigModel:c withInfo:dic];
    return c;
}


#pragma mark - utility
+ (void)setConfigModel:(HttpConfigModel *)configModel withInfo:(NSDictionary *)parameters
{
    
    NSString * uri = [parameters objectForKey:kUrlName];
    NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [mInfo removeObjectForKey:kUrlName];
    
    configModel.urlString = [NSString stringWithFormat:@"%@%@",kRootUrl,uri];
    if ([parameters objectForKey:@"requestType"]) {
        configModel.requestType = [parameters objectForKey:@"requestType"];
    }else
    {
        configModel.requestType = @"post";
    }
    [mInfo removeObjectForKey:@"requestType"];
    configModel.parameters = mInfo;
     configModel.token = [self getAES_Str:configModel.parameters andConfiger:configModel];
}

+ (void)setKJBConfigModel:(HttpConfigModel *)configModel withInfo:(NSDictionary *)parameters
{
    
    NSString * uri = [parameters objectForKey:kUrlName];
    NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [mInfo removeObjectForKey:kUrlName];
    if ([parameters objectForKey:@"requestType"]) {
        configModel.requestType = [parameters objectForKey:@"requestType"];
    }else
    {
        configModel.requestType = @"post";
    }
    [mInfo removeObjectForKey:@"requestType"];
    configModel.urlString = [NSString stringWithFormat:@"%@%@",kRootUrl,uri];
    
    configModel.parameters = mInfo;
     configModel.token = [self getAES_Str:configModel.parameters andConfiger:configModel];
}

+ (void)setVerifyCodeConfigModel:(HttpConfigModel *)configModel withInfo:(NSDictionary *)parameters
{
    NSString * uri = [parameters objectForKey:kUrlName];
    NSMutableDictionary * mInfo = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [mInfo removeObjectForKey:kUrlName];
    
    if ([parameters objectForKey:@"requestType"]) {
        configModel.requestType = [parameters objectForKey:@"requestType"];
    }else
    {
        configModel.requestType = @"post";
    }
    [mInfo removeObjectForKey:@"requestType"];
    
    configModel.urlString = [NSString stringWithFormat:@"%@%@",kRootUrl,uri];
    
    configModel.parameters = mInfo;
    configModel.token = [self getAES_Str:configModel.parameters andConfiger:configModel];
}


+ (NSString *)getAES_Str:(NSDictionary *)dic andConfiger:(HttpConfigModel *)model
{
    NSMutableArray * propetyArr = [NSMutableArray array];
    
    NSArray * keyArrar = [dic allKeys];
    
    //升序排列
    NSArray * sortKeyArrar = [keyArrar sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
        return [obj1 compare:obj2]; //升序
    }];

    for (NSString * key in sortKeyArrar) {
        NSString * str;
        
        if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
            if ([[dic objectForKey:key] length] == 0) {
                continue;
            }
        }
        str = [key stringByAppendingFormat:@"=%@",[dic objectForKey:key]];
        
        [propetyArr addObject:str];
    }
    
    NSString * sha1Str = [propetyArr componentsJoinedByString:@"&"];
    
    model.propertyStr = sha1Str;
    
    if (sha1Str.length > 0) {
        sha1Str = [sha1Str stringByAppendingString:@"&key=1bc29b36f623ba82aaf6724fd3b16718"];
    }else
    {
        sha1Str = @"key=1bc29b36f623ba82aaf6724fd3b16718";
    }
    
    sha1Str = [sha1Str SHA1_Cap];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
//    sha1Str = [NSString stringWithFormat:@"{\"time\":\"%@\",\"token\":\"%@\"}", timeString, sha1Str];
    
    NSDictionary * firstdic = @{@"time":timeString,@"token":sha1Str};
    NSString * dicJsonStr = [firstdic JSONString];
    
    NSString * aesStr = [dicJsonStr AES_encryptStringWithString:dicJsonStr andKey:@"PSf_wsIsE:u]G0xz"];

    return aesStr;;
}

@end
