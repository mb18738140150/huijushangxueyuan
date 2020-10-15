//
//  NetMacro.h
//  Accountant
//
//  Created by aaa on 2017/2/27.
//  Copyright © 2017年 tianming. All rights reserved.
//

#ifndef NetMacro_h
#define NetMacro_h

// 菜瓜网校
// http://192.168.1.10:9020/api/
//  http://api.caigua5.com/api/

#define kRootUrl @"http://bxapi.iluezhi.com/"
//http://doc.luezhi.com/server/index.php?g=Web&c=Mock&o=simple&projectID=22&uri=api/index/navigation
// 分享地址
#define kShareUrl @"http://bxapi.iluezhi.com/home/load"
#define kDescription @"菜瓜网校是一家中国领先的移动互联网职业教育企业,致力于建工行业资格考试培训的相关服务,我公司以“学员第一,质量至上”为教学理念,专注于为中国建筑行业提供优质的教育资源、科学的课程体系和合理的学习方式,为学员量身制定培训方案和课程。"

// 题库
#define kRootKJBUrl @"http://test.kjjl100.com/getdata.ashx"
#define kMD5String @"tianmingkeji"

// 上传文件
#define kUploadRootUrl @"http://bxapi.iluezhi.com/api/upload/image"

#define kNetError @"请检查网络连接"
#define kInternalServerError @"内部服务错误"

#pragma mark - net paramaters
#define kCommand @"command"

#define kCommandLogin                   @"1"
#define kCommandCategoryDetail          @"4"
#define kCommandQuestion                @"6"
#define kCommandDetailCourse            @"8"
#define kCommandTestCategory            @"9"
#define kCommandResetPwd                @"10"
#define kCommandQuestionDetail          @"12"
#define kCommandPublishQuestion         @"13"
#define kCommandVerifyCode              @"14"
#define kCommandRegist                  @"15"
#define kCommandTestSimulateInfo        @"18"



#define kCommandSearchCourse            @"2"
#define kCommandBanner                  @"3"

#define kCommandHottestCourse           @"5"

#define kCommandAllCourse               @"7"

#define kCommandAllCategory             @"9"
#define kCommandTestChapterInfo         @"6"
#define kCommandTestSectionQuestion     @"7"
#define kCommandTestNote                @"17"

#define kCommandTestSimulateQuestion    @"7"
#define kCommandTestErrorInfo           @"9"
#define kCommandTestErrorQuestion       @"7"
#define kCommandTestCollectionQuestion  @"7"
#define kCommandTestSimulateScore       @"15"
#define kCommandTestMyWrongQuestion     @"7"
#define kCommandTestMyWrongChapter      @"9"
#define kCommandTestCollectQuestion     @"12"
#define kCommandTestUncollectQuestion   @"11"
#define kCommandTestAddHistory          @"16"
#define kCommandTestAddHistoryDetail    @"17"
#define kCommandTestRecord              @"18"
#define kCommandTestRecordQuestion      @"19"
#define kCommandTestDailyPractice       @"20"

#define kCommandAddMyWrongQuestion      @"12"
#define kCommandHistory                 @"21"
#define kCommandAddHistory              @"22"
#define kCommandAddVideoNote            @"23"
#define kCommandAllMyNote               @"24"
#define kCommandMyQuestion              @"25"
#define kCommandCollectCourse           @"26"
#define kCommandLearningCourse          @"27"
#define kCommandAddCollectCourse        @"28"
#define kCommandDeleteCollectCourse     @"29"
#define kCommandDeleteVideoNote         @"30"
#define kCommandGetLiveingCourse        @"31"
#define kCommandHotSearchCourse         @"32"
#define kCommandBindJPush               @"33"
#define kCommandOrderLivingCourse       @"34"
#define kCommandJurisdictionCourse      @"35"
#define kCommandVersionInfo             @"4"


#define kCommandForgetPassword          @"39"
#define kCommandVerifyAccount           @"40"
#define kCommandcompleteUserInfo        @"41"
#define kCommandLivingSectionDetail     @"42"
#define kCommandCancelOrderLivingCourse       @"43"
#define kBindRegCode                    @"44"
#define kPayOrder                       @"46"
#define kCommandMyLivingCourse          @"47"

#define kOrderList                      @"49"
#define kCommandDeleteMyLearningCourse     @"50"
#define kRecommend                      @"51"
#define kGetRecommend                   @"52"
#define kGetRecommendIntegral           @"53"
#define kCommandMemberLevelDetail       @"54"
#define kAssistantCenter                @"55"
#define kPayOrderFromOrderList          @"56"
#define kSubmitOpinion                  @"57"
#define kCommonProblem                  @"58"
#define kLivingBackYearList             @"59"
#define kSubmitGidtCode                 @"60"
#define kGiftLIst                       @"61"
#define kAcquireDiscountCoupon          @"62"
#define kDiscountCoupon                 @"63"
#define kAcquireDiscountCouponSuccess   @"64"
#define kGetAllPackage                  @"65"
#define kPackageDetail               @"66"
#define kInAPPPurchase                  @"67"
#define kMyGoldCoin                     @"68"


#endif /* NetMacro_h */
